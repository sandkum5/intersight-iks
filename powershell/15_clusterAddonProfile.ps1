<#
This script creates a new Cluster Addon Profile.
#>

# Source Variables file
. ./variables.ps1

# Read File
$moids = Get-Content -Path "$pwd/$moidFileName" | ConvertFrom-Json

# Initialize Cluster Object
$clusterProfileObject = Get-IntersightKubernetesClusterProfile -Moid $moids.cluster_profile_moid | Get-IntersightMoMoRef
$clusterObject = Get-IntersightKubernetesCluster -Parent $clusterProfileObject | Get-IntersightMoMoRef

$addonsList = [System.Collections.ArrayList]@()
foreach ($moid in $moids.addon_moid_list) {
    # Get Addon Policy Info
    $addonPolicyName = (Get-IntersightKubernetesAddonPolicy -Moid $moid).Name

    # Initialize Addon Policy
    $addonPolicy = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType KubernetesAddonPolicy -Moid $moid
    # For some reason, when we use below command, the cluster addon profile is not created.
    # $addonPolicy = Get-IntersightKubernetesAddonPolicy -Moid $moid | Get-IntersightMoMoRef

    # Initialize Cluster Profile Addon configuration object
    $addonConfigObject = Initialize-IntersightKubernetesAddonConfiguration -InstallStrategy $clusterInstallStrategy -Overrides $clusterOverrides -UpgradeStrategy $clusterUpgradeStrategy

    # Initialize Kubernetes Cluster Profile Addon Object
    $addonsObject =  Initialize-IntersightKubernetesAddon -Name $addonPolicyName -AddonPolicy $addonPolicy -AddonConfiguration $addonConfigObject

    #  ArrayList.Add() returns the index at which the new item was added.
    # [void] prefix was added to remove the output from Add()
    # alternative solution: [void]$addonsList.Add($addonsObject)
    $addonsList.Add($addonsObject) | Out-Null
}

# Initialize Org Object
$orgObject = $myOrg | Get-IntersightMoMoRef

# Create Cluster Addon Policy
$policyProps = @{
    Name              = $clusterAddonProfileName
    Organization      = $orgObject
    AssociatedCluster = $clusterObject
    Addons            = $addonsList
}

if ( -not $moids.cluster_addon_moid ){
    $result = New-IntersightKubernetesClusterAddonProfile @policyProps

    Write-Host "Created Cluster Addon policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

    # Add Moid to moids.json file
    Invoke-UdfAddMoid -File $moidFileName -Name 'cluster_addon_moid' -Value $result.Moid
}

if ($moids.cluster_addon_moid ){
    $result = Set-IntersightKubernetesClusterAddonProfile -Moid $moids.cluster_addon_moid @policyProps
    Write-Host "Updated Cluster Addon Policy" -ForegroundColor Green
}

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding ascii
