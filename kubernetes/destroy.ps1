<#
This script destroys Kubernetes Profile and Policies. 
#>

# Source Variables file
. ./00_variables.ps1

# Variables Section
$clusterProfileName      = $baseName
$sysConfigPolicyName     = $baseName
$networkCidrPolicyName   = $baseName
$kubeVersionPolicyName   = $baseName
$vmInstancePolicyName    = $baseName
$vmInfraConfigPolicyName = $baseName
$addOnPolicyName         = $baseName

# Delete Kubernetes Cluster Profile 
Write-Host "Deleting Cluster Profile: $($clusterProfileName)" -ForegroundColor Red
$KubernetesClusterProfile =  Get-IntersightKubernetesClusterProfile -Name $clusterProfileName
$KubernetesClusterProfile | Remove-IntersightKubernetesClusterProfile | Out-Null
while ($true) {
    $clusterProfileStatus = Get-IntersightKubernetesClusterProfile -Name $clusterProfileName
    if ($null -eq $clusterProfileStatus) {
        Write-Host "Kuberenetes Cluster Profile: $($clusterProfileName) deleted!" -ForegroundColor Red
        break
    } else {
        Write-Host "Waiting for Cluster Profile delete operation to complete!" -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}

Write-Host "Deleting SysConfigPolicy: $($sysConfigPolicyName)" -ForegroundColor Red
$sysConfigPolicy = Get-IntersightKubernetesSysConfigPolicy -Name $sysConfigPolicyName
$sysConfigPolicy | Remove-IntersightKubernetesSysConfigPolicy

Write-Host "Deleting NetworkPolicy: $($networkCidrPolicyName)" -ForegroundColor Red
$networkCidrPolicy = Get-IntersightKubernetesNetworkPolicy -Name $networkCidrPolicyName
$networkCidrPolicy | Remove-IntersightKubernetesNetworkPolicy

Write-Host "Deleting VersionPolicy: $($kubeVersionPolicyName)" -ForegroundColor Red
$kubeVersionPolicy = Get-IntersightKubernetesVersionPolicy -Name $kubeVersionPolicyName
$kubeVersionPolicy | Remove-IntersightKubernetesVersionPolicy

Write-Host "Deleting VirtualMachineInstanceType Policy: $($vmInstancePolicyName)" -ForegroundColor Red
$vmInstancePolicy = Get-IntersightKubernetesVirtualMachineInstanceType -Name $vmInstancePolicyName
$vmInstancePolicy | Remove-IntersightKubernetesVirtualMachineInstanceType

Write-Host "Deleting VirtualMachineInfraConfigPolicy: $($vmInfraConfigPolicyName)" -ForegroundColor Red
$vmInfraConfigPolicy = Get-IntersightKubernetesVirtualMachineInfraConfigPolicy -Name $vmInfraConfigPolicyName
$vmInfraConfigPolicy | Remove-IntersightKubernetesVirtualMachineInfraConfigPolicy

Write-Host "Deleting AddonPolicy: $($addOnPolicyName)" -ForegroundColor Red
$addOnPolicy = Get-IntersightKubernetesAddonPolicy -Name $addOnPolicyName
$addOnPolicy | Remove-IntersightKubernetesAddonPolicy