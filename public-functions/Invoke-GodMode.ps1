function Invoke-Godmode
{
    <#
    .SYNOPSIS
    Opens the God mode control pannel

    .EXAMPLE
    Invoke-Godmode -ComputerName server

    .EXAMPLE
 
    .NOTES

    #>
   [cmdletbinding()]
   param(
        # Pipeline variable
       [Parameter(
           Mandatory         = $true,
           HelpMessage       = ' ',
           Position          = 0,
           ValueFromPipeline = $true,
           ValueFromPipelineByPropertyName = $true
       )]
        [ValidateNotNullOrEmpty()]
       [Alias('Server')]
       [string[]]$ComputerName
    )

    process
    {
        #GodMode path based on current $env and current user
        $userpath = [environment]::getfolderpath("desktop")
        $godpath = "\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
        $finalpath = $userpath + $godpath
        if (!(Test-Path -Path $finalpath)) 
        {
            #Creates GodMode path for current user
            New-Item -Type directory -Path $finalpath -force | out-null
        }   
        #Opens GodMode path
        Start-Process "$finalpath"  
    }
}

Set-Alias -Name godmode -Value Invoke-GodMode
