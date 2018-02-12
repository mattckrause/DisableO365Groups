<#
    .DESCRIPTION
    Enable-Groups.ps1
    Matt Krause 2018

    This script creates a remote powershell connection to an Office 365 tenant. 
    It re-enables all users ability to create Groups in O365. It's meant to be
    run to undo the changes made in the Disable-Groups.ps1 script

#>

# Make the required remote powershell connection to your tenant.
Import-Module AzureADPreview
$cred = Get-Credential
Connect-AzureAD -Credential $cred

#Get the custom policy put in place by Disable-Groups.ps1
$Policy = Get-AzureADDirectorySetting -All $True | where-object {$_.DisplayName -eq "Group.Unified"}
#Remove the custom policy put in place by Disable-Groups.ps1
Remove-AzureADDirectorySetting -Id $Policy.Id