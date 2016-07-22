function Get-Latest
{
    <#
    .SYNOPSIS
    Gets the latest howtogeek post

    .EXAMPLE
    Get-Latest
 
    .NOTES

    #>
   [cmdletbinding()]
   param( )

    process
    {
        ((Invoke-WebRequest -Uri 'http://howtogeek.com').Links | Where-Object class -eq "title").Title 
    }
}