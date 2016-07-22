function Get-UserLastComputer
{
    <#
    .SYNOPSIS
    Query SCCM Server for list of workstations last logged on by specified SAM account name

    .EXAMPLE
    Get-UserLastComputer -UserName john.smith

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
       [Alias('SamAccountName')]
       [string[]]$UserName,
        
        #SCCM Site Name
        [string]$SiteName="SITENAME",

        #SCCM Server Name
        [string]$SCCMServer="SCCMSERVER"        
    )

    process
    {
        #SCCM Namespace
        [string]$SCCMNameSpace="root\sms\site_$SiteName"

        foreach($user in $SamAccountName)
        {
            Write-Verbose $user
            Get-WmiObject -namespace $SCCMNameSpace -computer $SCCMServer -query "select Name from sms_r_system where LastLogonUserName='$user'" | select Name
        }
    }
}

Set-Alias -Name suntuser -Value 'Get-UserLastComputer'