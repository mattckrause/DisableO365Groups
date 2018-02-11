<#
    .DESCRIPTION
    Disable-Groups.ps1
    Matt Krause 2018

    This script is meant to be run through a remote powershell connection to an Office 365 tenant. 
    It disables all users ability to create Groups in O365. An exception can be to allow members of
    a security group to continue to create groups throughout the tenant.

#>

# Make the required remote powershell connection to your tenant.
Import-Module AzureADPreview
$cred = Get-Credential
Connect-AzureAD -Credential $cred

#create a new directory setting that disables all users ability to create a Group. Include an exception for Global Admins
#Looks up the GUID of security group you want to user for an excption.
$GA = (Get-AzureADGroup -SearchString "AllowGroup").ObjectId

#Creates a new directory setting based on a template for Groups
$NewSetting = Get-AzureADDirectorySettingTemplate | where-object {$_.DisplayName -eq "Group.Unified"}

#Set the desired policy settings
$Policy = $NewSetting.CreateDirectorySetting()
#Disable group creation for all users.
$Policy["EnableGroupCreation"] = $False
#Add the Global Admins group as an exception.
$Policy["GroupCreationAllowedGroupId"] = $GA

#This line creates the new policy. If you need to UPDATE the existing policy, comment this line out.
New-AzureADDirectorySetting -DirectorySetting $Policy
#If you are UPDATING the policy, you need to uncomment the following line.
#Get-AzureADDirectorySetting | Set-AzureADDirectorySetting -DirectorySetting $Policy
