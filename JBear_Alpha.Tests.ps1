#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a module for all needed components
.EXAMPLE
    Invoke-Pester 
.NOTES
    This is a very generic set of tests that should apply to all modules that use a functions sub folder
#>


$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$module = Split-Path -Leaf $here

Describe "Module: $module" -Tags Unit {
    
    Context "Module Configuration" {
        
        It "Has a root module file ($module.psm1)" {        
            
            "$here\$module.psm1" | Should Exist
        }

        It "Is valid Powershell (Has no script errors)" {

            $contents = Get-Content -Path "$here\$module.psm1" -ErrorAction SilentlyContinue
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
            $errors.Count | Should Be 0
        }

        It "Has a manifest file ($module.psd1)" {
            
            "$here\$module.psd1" | Should Exist
        }

        It "Contains a root module path in the manifest (RootModule = '$module.psm1')" {
            
            "$here\$module.psd1" | Should Exist
            "$here\$module.psd1" | Should Contain "$module.psm1"
        }

        It "Has a functions folder" {        
            
            "$here\public-functions" | Should Exist
        }
        
        It "Exports all public functions" {
            $functions = LS "$here\public-functions\*.ps1" | where name -NotMatch '\.Tests\.ps1'
            $manifest = IEX (Get-Content "$here\$module.psd1" -Raw)
            
            $functions | should Not BeNullOrEmpty
            $manifest.FunctionsToExport | should Not BeNullOrEmpty
            
            foreach($node in $functions.basename)
            {
                ($manifest.FunctionsToExport -eq $node) | Should Not BeNullOrEmpty
            }
        }

        It "Has functions in the functions folder" {        
            
            "$here\public-functions\*.ps1" | Should Exist
        }
    }

    Write-Verbose "Test individual functions found in the public and private function folders"
    
    $publicFunctions = Get-ChildItem "$here\public-functions\*.ps1" -ErrorAction SilentlyContinue | Where-Object {$_.name -NotMatch "Tests.ps1"}
    $privateFunctions = Get-ChildItem "$here\private-functions\*.ps1" -ErrorAction SilentlyContinue | Where-Object {$_.name -NotMatch "Tests.ps1"}
    
    $manifest = IEX (Get-Content "$here\$module.psd1" -Raw)
    
    Context "Exported Functions listed in manifest that should exist" {
        
        foreach($currentFunction in $manifest.FunctionsToExport)
        {
            it "$currentFunction.ps1 exists" {
                "$here\public-functions\$CurrentFunction.ps1" | Should Exist
            }
        }
    }
    
    Context "Public functions that should be in manifest" {
        
        foreach($currentFunction in $publicFunctions.BaseName)
        {
            it "$currentFunction is exported" {
                ($manifest.FunctionsToExport -eq $currentFunction) | Should Not BeNullOrEmpty
            }
        }
    }

    foreach($currentFunction in ($privateFunctions + $publicFunctions ))
    {
        Context "Private Function $module::$($currentFunction.BaseName)" {
        
            It "Has a Pester test" {

                $currentFunction.FullName.Replace(".ps1",".Tests.ps1") | should exist
            }

            It "Has show-help comment block" {

                $currentFunction.FullName | should contain '<#'
                $currentFunction.FullName | should contain '#>'
            }

            It "Has show-help comment block has a synopsis" {

                $currentFunction.FullName | should contain '\.SYNOPSIS'
            }

            It "Has show-help comment block has an example" {

                $currentFunction.FullName | should contain '\.EXAMPLE'
            }

            It "Is an advanced function" {

                $currentFunction.FullName | should contain 'function'
                $currentFunction.FullName | should contain 'cmdletbinding'
                $currentFunction.FullName | should contain 'param'
            }

            It "Is valid Powershell (Has no script errors)" {

                $contents = Get-Content -Path $currentFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors.Count | Should Be 0
            }
        }
    }    
}