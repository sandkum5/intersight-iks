<#
This script destroys Kubernetes Profile and Policies.
#>

# Source Variables file
. ./variables.ps1

# Variables Section
$clusterProfileName      = $name
$sysConfigPolicyName     = $name
$networkCidrPolicyName   = $name
$kubeVersionPolicyName   = $name
$vmInstancePolicyName    = $name
$vmInfraConfigPolicyName = $name
# $addOnPolicyName         = $name

# Read File
$moids = Get-Content -Path "$pwd/$moidFileName" | ConvertFrom-Json

# Delete Kubernetes Cluster Profile
Write-Host "Deleting Cluster Profile: $($clusterProfileName)" -ForegroundColor Red
$KubernetesClusterProfile = Get-IntersightKubernetesClusterProfile -Moid $moids.cluster_profile_moid

$KubernetesClusterProfile | Remove-IntersightKubernetesClusterProfile | Out-Null
while ($true) {
    $clusterProfileStatus = Get-IntersightKubernetesClusterProfile -Moid $moids.cluster_profile_moid
    if ($null -eq $clusterProfileStatus) {
        Write-Host "Kuberenetes Cluster Profile: $($clusterProfileName) deleted!" -ForegroundColor Red
        # Remove moid from moids.json
        Invoke-UdfDelMoid -File $moidFileName -Name 'cluster_profile_moid' -Value ""
        break
    } else {
        Write-Host "Waiting for Cluster Profile delete operation to complete!" -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}

# Delete Kubernetes Policies
Write-Host "Deleting SysConfig Policy: $($sysConfigPolicyName)" -ForegroundColor Red
$sysConfigPolicy = Get-IntersightKubernetesSysConfigPolicy -Moid $moids.sys_config_moid
$sysConfigPolicy | Remove-IntersightKubernetesSysConfigPolicy
# Remove moid from moids.json
Invoke-UdfDelMoid -File $moidFileName -Name 'sys_config_moid' -Value ""

Write-Host "Deleting Network Policy: $($networkCidrPolicyName)" -ForegroundColor Red
$networkCidrPolicy = Get-IntersightKubernetesNetworkPolicy -Moid $moids.net_policy_moid
$networkCidrPolicy | Remove-IntersightKubernetesNetworkPolicy
# Remove moid from moids.json
Invoke-UdfDelMoid -File $moidFileName -Name 'net_policy_moid' -Value ""

Write-Host "Deleting Kubernetes Version Policy: $($kubeVersionPolicyName)" -ForegroundColor Red
$kubeVersionPolicy = Get-IntersightKubernetesVersionPolicy -Moid $moids.kube_version_moid
$kubeVersionPolicy | Remove-IntersightKubernetesVersionPolicy
# Remove moid from moids.json
Invoke-UdfDelMoid -File $moidFileName -Name 'kube_version_moid' -Value ""

Write-Host "Deleting VirtualMachineInstanceType Policy: $($vmInstancePolicyName)" -ForegroundColor Red
$vmInstancePolicy = Get-IntersightKubernetesVirtualMachineInstanceType -Moid $moids.vm_instance_moid
$vmInstancePolicy | Remove-IntersightKubernetesVirtualMachineInstanceType
# Remove moid from moids.json
Invoke-UdfDelMoid -File $moidFileName -Name 'vm_instance_moid' -Value ""

Write-Host "Deleting VirtualMachineInfraConfig Policy: $($vmInfraConfigPolicyName)" -ForegroundColor Red
$vmInfraConfigPolicy = Get-IntersightKubernetesVirtualMachineInfraConfigPolicy -Moid $moids.vm_infra_config_moid
$vmInfraConfigPolicy | Remove-IntersightKubernetesVirtualMachineInfraConfigPolicy
# Remove moid from moids.json
Invoke-UdfDelMoid -File $moidFileName -Name 'vm_infra_config_moid' -Value ""

Write-Host "Deleting Addon Policies" -ForegroundColor Red
foreach ( $addonMoid in $moids.addon_moid_list) {
    $addOnPolicy = Get-IntersightKubernetesAddonPolicy -Moid $addonMoid
    $addOnPolicy | Remove-IntersightKubernetesAddonPolicy
}
# Remove moid from moids.json
Invoke-UdfDelMoid -File $moidFileName -Name 'addon_moid_list' -Value @()

Write-Host "Deleting IP Pool Policy: $($ipPoolPolicyName)" -ForegroundColor Red
$ippoolPolicy = Get-IntersightIppoolPool -Moid $moids.ippool_moid
$ippoolPolicy | Remove-IntersightIppoolPool
# Remove moid from moids.json
Invoke-UdfDelMoid -File $moidFileName -Name 'ippool_moid' -Value ""

Invoke-UdfDelMoid -File $moidFileName -Name 'cluster_addon_moid' -Value ""
Invoke-UdfDelMoid -File $moidFileName -Name 'cp_node_group_moid' -Value ""
Invoke-UdfDelMoid -File $moidFileName -Name 'cp_vm_infra_provider_moid' -Value ""
Invoke-UdfDelMoid -File $moidFileName -Name 'worker_node_group_moid' -Value ""
Invoke-UdfDelMoid -File $moidFileName -Name 'worker_vm_infra_provider_moid' -Value ""

EXIT