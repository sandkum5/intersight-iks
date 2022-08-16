<#
Common Variables file for Policies and Profiles
#>

# Add Functions
. ./functions.ps1

$PSStyle.OutputRendering = 'Host'

# Intersight Configuration
$ApiParams = @{
    BasePath          = "https://intersight.com"
    ApiKeyId          = Get-Content -Path "./apiKey.txt" -Raw
    ApiKeyFilePath    = $pwd.Path + "/SecretKey.txt"
    HttpSigningHeader = @("(request-target)", "Host", "Date", "Digest")
}

Set-IntersightConfiguration @ApiParams

# Moid File
$moidFileName            = 'moids.json'

# Org Info
$orgName                 = "default"
$myOrg                   = Get-IntersightOrganizationOrganization -Name $orgName

# Define Tags
$tags                    = Initialize-IntersightMoTag -Key 'Location' -Value 'San Jose'
$name                    = "pwsh_demo"
$description             = "Created using PowerShell"
$sshKeyVar               = "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAEjNtg6YwV8zyHcz5PA91aSUvyPiIPVRi1sTKdsdeFFKmyvBK9yBXJBqIPi1FTikEK3WFN/J6H7O0tzTZUhweJ4tACAC4DBWckWHWn1ZgWqc2nfBA26xY/0ilU9ptwUsevH+u0zQoWIhQe+DAwOxPNoB3LA76ck1BkW55quzFelak0fIg== sandkum5@SANDKUM5-M-WLMC"

# 01_ipPoolPolicy.ps1 variables
# Script Variables. Not defined in Intersight API.
$ipv4Enable              = $True
$ipv6Enable              = $False

# Variables Section
# ipv4
$ipv4StartIp             = "10.1.1.2" # string x.x.x.x
$ipv4Size                = 10 # Int
$ipv4Gateway             = "10.1.1.1"
$ipv4Netmask             = "255.255.255.0"
$ipv4PrimaryDns          = "8.8.8.8"
$ipv4SecondaryDns        = "8.8.4.4"
# ipv6
$ipv6StartIp             = ""
$ipv6Size                = 1
$ipv6Gateway             = ""
$ipv6Prefix              = 64 # 1-127
$ipv6PrimaryDns          = ""
$ipv6SecondaryDns        = ""

# 02_networkCIDRPolicy.ps1 variables
$podNetworkCidr          = "10.1.1.0/16"
$serviceCidr             = "10.2.2.2/24"
# 03_nodeOSConfigPolicy.ps1 variables
$dnsServers              = "8.8.8.8"
$ntpServers              = "4.4.4.4"
$timezone                = "AmericaLosAngeles"

# 05_addOnPolicy.ps1 variables
$installStrategy         = "NoAction"  # Options[None, NoAction, InstallOnly, Always]
$upgradeStrategy         = "NoAction"  # Options[None, NoAction, UpgradeOnly, ReinstallOnFailure, AlwaysReinstall]
$overrides               = ""
$releaseNamespace        = ""

# 06_vmInfraConfigPolicy.ps1 variables
$passphrase              = "adfadfasdaljdlfjds"

# 07_vmInstancePolicy.ps1 variables
$cpu                     = 4       # Range 1-40
$diskSize                = 15      # Range(in GiB) >0
$memory                  = 16384   # Range(in mebibytes) 1-4177920

# 10_k8sClusterProfile.ps1 variables
$managedMode             = "Managed"
$ipPoolPolicyName        = $name
$lbCount                 = 1
$sshKey                  = $sshKeyVar
$sysConfigName           = $name
$netConfigName           = $name

# 11_masterNodeGroupProfiles.ps1 variables
# cp stands for Control Plane Node
$cpName                  = "cpNGProfile"
$cpNodeType              = "ControlPlane"
$cpDesiredSize           = 1
$cpMinSize               = 1
$cpMaxSize               = 2
$clusterProfileName      = $name
$k8sVersionPolicyName    = $name
# $ipPoolPolicyName        = $name

# 12_vmInfraProvidersMaster.ps1 variables
$cpVMInfraProvider       = "cpVMInfraProvider"
$vmInstanceName          = $name
$infraConfigPolicyName   = $name
$nodeGroupName           = $name

# 13_workerNodeGroupProfiles.ps1 variables
# w stands for worker node
$wName                   = "wNGProfile"
$wNodeType               = "Worker"
$wDesiredSize            = 1
$wMinSize                = 1
$wMaxSize                = 2

# 14_vmInfraProvidersWorker.ps1 variables
# Refer 12_vmInfraProvidersMaster.ps1 section
$wVMInfraProvider        = "wVMInfraProvider"
# $vmInstanceName          = $name
# $infraConfigPolicyName   = $name
# $nodeGroupName           = $name

# 15_clusterAddonProfile.ps1 variables
$clusterAddonProfileName = $name
$clusterInstallStrategy  = "NoAction" # Options[NoAction, InstallOnly, Always]
$clusterUpgradeStrategy  = "NoAction" # Options[NoAction, UpgradeOnly, ReinstallOnFailure, AlwaysReinstall]
$clusterOverrides        = ""


# IGNORE
# To remove unsed variable fault, writing vars to Out-Null.
Write-Output $moidFileName $myOrg $tags $baseName $description $sshKeyVar $ipv4Enable $ipv6Enable $ipv4StartIp $ipv4Size $ipv4Gateway $ipv4Netmask $ipv4PrimaryDns $ipv4SecondaryDns $ipv6StartIp $ipv6Size $ipv6Gateway $ipv6Prefix $ipv6PrimaryDns $ipv6SecondaryDns $podNetworkCidr $serviceCidr $dnsServers $ntpServers $timezone $installStrategy $upgradeStrategy $overrides $releaseNamespace $passphrase $cpu $diskSize $memory $managedMode $ipPoolPolicyName $lbCount $sshKey $sysConfigName $netConfigName $cpNodeType $cpDesiredSize $cpMinSize $cpMaxSize $clusterProfileName $k8sVersionPolicyName $vmInstanceName $infraConfigPolicyName $nodeGroupName $wNodeType $wDesiredSize $wMinSize $wMaxSize $clusterAddonProfileName $profileAddonName $addonPolicyName $cpName $cpVMInfraProvider $wName $wVMInfraProvider $clusterInstallStrategy $clusterUpgradeStrategy $clusterOverrides | Out-Null
