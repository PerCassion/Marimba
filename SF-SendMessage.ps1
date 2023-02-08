<#
.SYNOPSIS
   Send message to users

.DESCRIPTION
   Send message to users logged into a particular set of Storefront servers for maintenance purposes

.LINK
   https://docs.citrix.com/en-us/citrix-daas/sdk-api.html
#>

# Explicit authentication to Citrix Cloud
Get-XdAuthentication -verbose

$SFlist = @("1.2.3.4","5.6.7.8")

$users = @()
foreach($server in $SFlist) {
   $SFusers = Get-BrokerSession -LaunchedViaIP $server
   $users += $SFusers
}

if($users) {
   Send-BrokerSessionMessage $sessions -MessageStyle Information -Title "Warning" -Text "This Storefront server will be decommissioned on x.x. Please contact Helpdesk for more information."
}

# Clear credentials
Clear-XdCredentials