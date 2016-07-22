function Get-RemoteGroupPolicy
{
    <#
    .SYNOPSIS
    Opens (Remote) Group Policy for specified workstation

    .EXAMPLE
    Get-RemoteGroupPolicy -ComputerName server

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
            gpedit.msc /gpcomputer: $node
        }
    }
}

New-Alias -Name gpr -Value Get-RemoteGroupPolicy