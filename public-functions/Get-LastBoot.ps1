function Get-LastBoot
{
    <#
    .SYNOPSIS
    Uses WMi to get th last boot time of a server

    .EXAMPLE
    Get-LastBoot -ComputerName server

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
           $LastBootUpTime =  (Get-WmiObject -Class Win32_OperatingSystem -Computer $node | Select -ExpandProperty LastBootUpTime)

           [pscustomobject]@{
                ComputerName = $node
                LastBootUpTime = [Management.ManagementDateTimeConverter]::ToDateTime($LastBootUpTime)
           }
        }
    }
}

Set-Alias -Name LastBoot -Value Get-LastBoot