function PrintMenu{




}#End PrintMenu

function Format-Menu
{
    <#
    .SYNOPSIS
    Shows a menu of common functions

    .EXAMPLE
    Format-Menu

    .EXAMPLE
 
    .NOTES

    #>
   [cmdletbinding()]
   param()

    process
    {
        Write-Output "List of Functions"
        Write-Output "-----------------"
        Write-Output "LastBoot [Param = list all computers]"
        Write-Output "Reboot [Param = list all computers]"
        Write-Output "Get-ScriptDirectory [no param returns current running directory]"
        write-Output ""
        write-Output "CommandType    Name          Function"
        write-Output "-----------    ----          --------"
        write-Output "Alias          adgroup       Copy Specified User Groups to Clipboard"
        write-Output "Alias          chkuser       Current Logged On User For Specified Workstation"
        write-Output "Alias          enac          Enable User Account in AD"
        write-Output "Alias          getsam        Search SAM Account Name By User Last Name"
        write-Output "Alias          godmode       Access God Mode"
        write-Output "Alias          ghost         Opens SCCM Ghost Session"
        write-Output "Alias          gpr           Group Policy (Remote)"
        write-Output "Alias          huntuser      Query SCCM For Last System Logged On By Specified User"
        write-Output "Alias          memcheck      View RAM Statistics"
        write-Output "Alias          netmsg        On-screen Message For Specified Workstation"
        write-Output "Alias          nithins       Opens Nithin's SCCM Tool"
        write-Output "Alias          np            Notepad++"
        write-Output "Alias          rdp           Remote Desktop"
        write-Output "Alias          rmprint       Clear Printer Drivers"
        write-Output "Alias          sccm          Active Directory"
        write-Output "Alias          swcheck       Check Installed Software For Specified Workstation"
        write-Output "Alias          sys           All Remote System Info"
        write-Output ""
        write-Output ""
   }
}

Set-Alias -Name PrintMenu -Value Format-Menu