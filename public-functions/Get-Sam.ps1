function Get-Sam
{
    <#
    .SYNOPSIS
    Get SAM Account Name for End User with Last Name search

    .EXAMPLE
    GetSam -UserLastName Smith
 
    .NOTES

    #>
   [cmdletbinding()]
   param(
        # Pipeline variable
       [Parameter(
           Mandatory         = $true,
           HelpMessage       = 'enter the users last name',
           Position          = 0,
           ValueFromPipeline = $true
       )]
        [ValidateNotNullOrEmpty()]
       [Alias('LastName')]
       [string[]]$UserLastName
    )

    process
    {
        foreach($node in $UserLastName)
        {
            Write-Verbose $node
            Get-ADUser -Filter "Surname -like '$node*'" | Select-Object GivenName, SurName, SamAccountName
        }
    }
}

Set-Alias -Name getsam -Value Get-Sam
