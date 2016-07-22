# Some modules may require SQLPS module that changes the drive letter.
push-location

$moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path
$moduleName = Split-Path $moduleRoot -Leaf

Write-Verbose "Importing Functions"
# Import everything in the functions folder
$publicFunctions = LS "$moduleRoot\Public-Functions\*.ps1" |
  Where-Object { -not ($_.FullName.Contains(".Tests.")) } 
 
$publicFunctions | ForEach-Object { Write-Verbose $_.FullName; . $_.FullName} 
  
Write-Verbose "Create eventlog source"
$EveriEventLog =@{
    LogName = 'Application'
    Source = $moduleName
}
New-EventLog @EveriEventLog -ErrorAction SilentlyContinue

# (ls .\functions\ | where name -notmatch 'tests.ps1' | % basename) -join ',' | clip
Export-ModuleMember -Function $publicFunctions.BaseName

# This restores the working directory
pop-location