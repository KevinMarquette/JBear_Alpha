function Get-SysInfo
{
    <#
    .SYNOPSIS
    

    .EXAMPLE
    Get-SysInfo -ComputerName server

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
        foreach($computer in $ComputerName)
       {
            Write-Verbose $computer
            #Gather specified workstation information
            $ComputerProgram = Get-WmiObject -class Win32_Product | Select-Object -Property Name | Sort-Object Name 
            $computerSystem = get-wmiobject Win32_ComputerSystem -Computer $Computer
            $computerBIOS = get-wmiobject Win32_BIOS -Computer $Computer
            $computerOS = get-wmiobject Win32_OperatingSystem -Computer $Computer
            $computerCPU = get-wmiobject Win32_Processor -Computer $Computer
            $computerHDD = Get-WmiObject Win32_LogicalDisk -ComputerName $Computer -Filter drivetype=3

            #Write all gathered workstation information to shell
            write-Verbose "System Information for: " $computerSystem.Name -BackgroundColor DarkCyan
            [pscustomobject] @{
                "ComputerName"     = $computerSystem.Name
                "Last Reboot"      = $computerOS.ConvertToDateTime($computerOS.LastBootUpTime)
                "Operating System" = $computerOS.OSArchitecture + " " + $computerOS.caption
                "Model"            = $computerSystem.Model
                "RAM"              = "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"
                "HDD Capacity"     = "{0:N2}" -f ($computerHDD.Size/1GB) + "GB"
                "HDD Space"        = "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size)
                "HDD Free"         = "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB"
                "User Logged In"   = $computerSystem.UserName
           }
       }
   }
}

Set-Alias -Name sys -Value Get-SysInfo