
#requires -modules psake, buildhelpers, pester
<#
.SYNOPSIS
Handles all the build related tasks for this module
.EXAMPLE
Invoke-PSake psake.ps1
.EXAMPLE

.NOTES

#>

task Default -Depends UpdateExportFunctions, BuildMissingTests, RunTests, UpdateBuildVersion

task Clean {

    Write-Verbose "Cleans any build artifacts"

    $parent     = resolve-path "$PSScriptRoot\.."
    $module     = Split-path $psscriptroot -leaf
    $zipPattern = '{0}_.*zip$' -f $module
    $zipFiles   = LS $parent | where name -match $zipPattern

    foreach($zip in $zipFiles)
    {
        Write-verbose "Removeing $zip"
        Remove-Item $zip.fullname
    }
}


task UpdateExportFunctions {

    $module    = Split-Path $PSScriptRoot -Leaf

    $functions = Get-ChildItem "$PSScriptRoot\Public-Functions\*.ps1" | 
                    Where-Object{ $_.name -notmatch 'Tests'} | 
                    ForEach-Object { $_.basename.tostring()}
    
    $modulePath = Join-Path $PSScriptRoot "$module.psd1"

    Set-ModuleFunctions -Name $modulePath -FunctionsToExport $functions 

    # The previous function recreated the manifest with Unicode
    Set-FileEncoding $modulePath -Encoding UTF8
    
}


Task BuildMissingTests {

    $functions    = LS (Join-Path $psscriptroot Public-Functions) | 
                        where name -notmatch 'Tests'

    # Checks for a missing *.Tests.ps1 that should be next to each function
    $missingTests = $functions | Where-Object {-not (Test-Path ($_.fullname.replace('.ps1','.Tests.ps1')))}

    foreach( $file in $missingTests)
    {
        New-PesterTest -Path $file.fullname
    }
}


Task RunTests {

    $testResults = Invoke-Pester $PSScriptRoot -PassThru

    if($testResults.FailedCount -gt 0)
    {
        # Because we may run hundreds of tests, echo out the failed ones at the end so they are easy to find
        $FailedTests = $testResults.Testresult | where passed -eq $false        
        $FailedTests | %{
            Write-Warning ('[{0,-20}][{1,-20}][{2,-20}][{3}]' -f $_.Describe,$_.Context,$_.Name,$_.Failuremessage)
        }

        # This error causes the build to fail
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
}

Task Zip -Depends Clean {

    $Destination  = resolve-path "$PSScriptRoot\.."
    $basename     = Split-path $psscriptroot -leaf
    $module       = Get-Item (join-Path $psscriptroot "$basename.psd1")
    $manifest     = Get-Hashtable -Path $module
    $zipName      = "{0}_{1}.zip" -f $basename, ($manifest.ModuleVersion)
    $publishedZip = Join-Path $Destination $zipname

    Write-Verbose $publishedZip

    if(-NOT (test-path $publishedZip ))
    {
        $zip = Add-Zip -Path $PSScriptRoot -Destination $publishedZip
    }
}

Task InstallLocal {

    $moduleName = Split-path $psscriptroot -Leaf
    $destination = "$env:USERPROFILE\Documents\WindowsPowershell\Modules\$moduleName"

    if(Test-Path $destination)
    {
        Write-Verbose "Removing module $destination"
        Remove-Item -Path $destination -Recurse | Out-Null
    }
    Robocopy $PSScriptRoot $destination /e | Out-Null
}



Task UpdateBuildVersion  {

    $checksumFile = (Join-Path $PSScriptRoot '.checksum')
    $shouldRev = $true

    if(Test-Path $checksumFile)
    {
        $hashes = LS $PSScriptRoot -Recurse -Exclude .checksum, *.psd1 -File | Get-FileHash -Algorithm SHA1 | Select -ExpandProperty Hash
        $checksums = Get-Content -Path $checksumFile

        if(-Not(Compare-Object $hashes $checksums -SyncWindow 1000))
        {
            $shouldRev = $false
        }
    }

    # prevent reving the verison if nothing changed
    if($shouldRev)
    {
        $module = Split-Path $PSScriptRoot -Leaf    
        Step-ModuleVersion -path "$psscriptroot\$module.psd1"

        Set-FileEncoding "$psscriptroot\$module.psd1" -Encoding UTF8

        # generate new checksum file
        $hashes = LS $PSScriptRoot -Recurse -Exclude .checksum, *.psd1 -File | Get-FileHash -Algorithm SHA1 | Select -ExpandProperty Hash
        Set-Content -Path (Join-Path $PSScriptRoot '.checksum') -Value $hashes
    }
}

