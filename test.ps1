<#
.SYNOPSIS
   Test Citrix Cloud

.DESCRIPTION
   Test Citrix Cloud

.LINK
   https://docs.citrix.com/en-us/citrix-daas/sdk-api.html
#>

# Explicit authentication to Citrix Cloud
Get-XdAuthentication -verbose

# Declare sample variables
$users = "xd.local\Domain Users"
$TSVDACatalogName = "TSVDA"
$TSVDADGName = "TSVDA"
$TSVDAMachineName = "xd\ds-tsvda2"

#Create TSVDA Catalog
$brokerUsers = New-BrokerUser -Name $users
$catalog = New-BrokerCatalog -Name $TSVDACatalogName -AllocationType "Random" -Description $TSVDACatalogName -PersistUserChanges "OnLocal" -ProvisioningType "Manual" -SessionSupport "MultiSession" -MachinesArePhysical $true

#Add TSVDA Machine to Catalog
$BrokeredMachine = New-BrokerMachine -MachineName $TSVDAMachineName -CatalogUid $catalog.uid

#Create new desktops & applications delivery group
$dg = New-BrokerDesktopGroup -Name $TSVDADGName -PublishedName $TSVDADGName -DesktopKind "Shared" -SessionSupport "MultiSession" -DeliveryType DesktopsAndApps -Description $TSVDADGName

#Create notepad application
New-BrokerApplication -ApplicationType HostedOnDesktop -Name "Notepad" -CommandLineExecutable "notepad.exe" -DesktopGroup $dg

#Assign users to desktops and applications
New-BrokerEntitlementPolicyRule -Name $TSVDADGName -DesktopGroupUid $dg.Uid -IncludedUsers $brokerUsers -description $TSVDADGName
New-BrokerAccessPolicyRule -Name $TSVDADGName -IncludedUserFilterEnabled $true -IncludedUsers $brokerUsers -DesktopGroupUid $dg.Uid -AllowedProtocols @("HDX","RDP")
New-BrokerAppEntitlementPolicyRule -Name $TSVDADGName -DesktopGroupUid $dg.Uid -IncludedUsers $brokerUsers -description $TSVDADGName

#Add machine to delivery group
Add-BrokerMachine -MachineName $TSVDAMachineName -DesktopGroup $dg

# Clear credentials
Clear-XdCredentials