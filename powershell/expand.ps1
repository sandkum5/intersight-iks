<#
This script deploys Kubernetes Cluster.
    Step1: Update Load balancer Count
    Step2: Control Plane Node Configuration:
        - Desired size: 1 or 3
        - Min Size
        - Max Size
    Step3: Worker Node Poolx Configuration
        - Desired Size
        - Min Size
        - Max Size
    Step4: Add Addon's and Update Cluster Addon Profile
#>

# Source Variables file
. ./variables.ps1
. ./updates.ps1

# Read File
$moids = Get-Content -Path "$pwd/$moidFileName" | ConvertFrom-Json

# Update IKS Cluster Profile Loadbalancer Count
Write-Host "Updating  Management Config" -ForegroundColor Green
$mgmtConfigObject = Initialize-IntersightKubernetesClusterManagementConfig -LoadBalancerCount $lbCountNew -SshKeys $sshKeyNew

Set-IntersightKubernetesClusterProfile -Moid $moids.cluster_profile_moid -ManagementConfig $mgmtConfigObject | Out-Null

# Update CP Node Group Profile
Write-Host "Updating Control Plane Node Group Profile" -ForegroundColor Green
$cpProps = @{
    Moid              = $moids.cp_node_group_moid
    Desiredsize       = $cpDesiredsizeNew
    Minsize           = $cpMinsizeNew
    Maxsize           = $cpMaxsizeNew
}
Set-IntersightKubernetesNodeGroupProfile @cpProps | Out-Null

# Update Worker Node Group Profile
Write-Host "Updating Worker Node Group Profile" -ForegroundColor Green
$wProps = @{
    Moid        = $moids.worker_node_group_moid
    Desiredsize = $wDesiredsizeNew
    Minsize     = $wMinsizeNew
    Maxsize     = $wMaxsizeNew
}
Set-IntersightKubernetesNodeGroupProfile @wProps | Out-Null

# Create Kubernetes Addon Policy
while ($True) {
    $addAddon = Read-Host -Prompt "Do you want to create Add-on Policy y/n"
    if ($addAddon -eq "y") {
        & "./05_addOnPolicy.ps1"

        # Update Cluster Addon Profile
        Write-Host "Updating Cluster Addon Profile" -ForegroundColor Green
        & "./15_clusterAddonProfile.ps1"
    }
    if ($addAddon -eq "n") {
        break
    }
}

EXIT
