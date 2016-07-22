function New-RDPSession
{
    <#
    .SYNOPSIS
    New remote desktop session

    .EXAMPLE
    New-RDPSession -ComputerName server

    .EXAMPLE
 
    .NOTES

    #>
   [cmdletbinding()]
   param(

       [Parameter(
           Mandatory         = $true,
           Position          = 0,
           ValueFromPipeline = $true
       )]
        [ValidateNotNullOrEmpty()]
       [Alias('Server')]
       [string[]]$ComputerName
    )

    process
    {
        foreach($node in $ComputerName)
       {
            Write-Verbose $node
            & "C:\windows\system32\mstsc.exe" /v:$node /fullscreen
       }
   }
}