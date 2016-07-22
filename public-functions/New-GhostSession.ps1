function New-GhostSession
{
    <#
    .SYNOPSIS
    Opens SCCM Ghost Session

    .EXAMPLE
    New-GhostSession -ComputerName server

    .EXAMPLE
 
    .NOTES

    #>
   [cmdletbinding()]
   param(
        # Pipeline variable
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
            Start-Process 'C:\Program Files (x86)\Microsoft Configuration Manager Console\AdminUI\bin\i386\rc.exe' "1 $node"
       }
   }
}

Set-Alias -Name Ghost -Value New-GhostSession