<#
This script creates a new Cluster Addon Profile.
#>

# Source Variables file
. ./00_variables.ps1

# Variables Section
$clusterAddonProfileName = $baseName
$clusterProfileName      = $baseName
$profileAddonName        = $baseName
$addonPolicyName         = $baseName

# Initialize Cluster Profile Object
$clusterProfileObject = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType KubernetesCluster -Selector "Name eq '$($clusterProfileName)'"

# Initialize Addon Policy Object
# $addonPolicyName = "iks-demo-addon"
# $addonPolicy = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType KubernetesAddonPolicy -Selector "Name eq '$($addonPolicyName)'"
$addonPolicyMoid = (Get-IntersightKubernetesAddonPolicy -Filter "Name eq '$($addonPolicyName)'"-InlineCount allpages).results.Moid

$addonPolicy = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType KubernetesAddonPolicy -Moid $addonPolicyMoid

# Initialize Cluster Profile Addon configuration object
$addonConfigObject = Initialize-IntersightKubernetesAddonConfiguration -InstallStrategy "NoAction" -Overrides "" -UpgradeStrategy "NoAction"

# Initialize Kubernetes Cluster Profile Addon Object
$addonsObject =  Initialize-IntersightKubernetesAddon -Name $profileAddonName -AddonPolicy $addonPolicy -AddonConfiguration $addonConfigObject

# Create Cluster Addon Policy
$result = New-IntersightKubernetesClusterAddonProfile -Name $clusterAddonProfileName -Organization $myOrg -AssociatedCluster $clusterProfileObject -Addons $addonsObject
Write-Host "Created Cluster Add-on policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

Write-Output "$($result.ClassId),$($result.Name),$($result.Moid)" | Out-File -FilePath ./moids.log -Append

$result | Out-File -FilePath ./results.log -Append -Encoding ascii