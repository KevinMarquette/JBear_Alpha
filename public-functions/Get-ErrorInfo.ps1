function Get-ErrorInfo
{
    <#
    .SYNOPSIS
    Opens browser to show last error

    .EXAMPLE
    Get-ErrorInfo 
 
    .NOTES

    #>
   [cmdletbinding()]
   param()

    process
    {
        & "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"  https://www.google.com/search?q=$error[0].Exception
   }
}