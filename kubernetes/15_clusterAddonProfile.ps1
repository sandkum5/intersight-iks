<#
This script creates a new Cluster Addon Profile.
#>

# Source Variables file
. ./00_variables.ps1

Set-IntersightConfiguration @ApiParams

# Variables Section
$clusterAddonProfileName = "pwsh_clusteraddonProfile1"
$clusterProfileName      = "pwsh_k8s1"
$profileAddonName        = "pwsh_addonProfile1"
$addonPolicyName         = "pwsh_addon1"

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
New-IntersightKubernetesClusterAddonProfile -Name $clusterAddonProfileName -Organization $myOrg -AssociatedCluster $clusterProfileObject -Addons $addonsObject
