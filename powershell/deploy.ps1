<#
This script deploys Kubernetes Cluster.
#>

# Source Variables file
. ./variables.ps1

# Read File
$moids = Get-Content -Path "$pwd/$moidFileName" | ConvertFrom-Json

# Variables Section
$action         = "Deploy"
# $iksProfileName = $name

function Get-IksProfileStatus {
    param (
        $iksProfileMoid
    )
    while( $true ) {
        # Pull Cluster Profile Status
        $iksProfile =  Get-IntersightKubernetesClusterProfile -Moid $iksProfileMoid
        $clusterStatus = $iksProfile.Status
        Write-Host "IKS Cluster Deploy Status: $($clusterStatus)"

        # Add 30 Secs delay
        Start-Sleep -Seconds 30

        # Verify Cluster Status
        if ($iksProfile.Status -eq "DeployFailedTerminal") {
            Write-Host "IKS Cluster Deployment Failed!"
            break
        }
        if ($iksProfile.Status -eq "Ready") {
            Write-Host "IKS Cluster Deployment Failed!"
            break
        }
    }
}

$iksClusterProfile =  Get-IntersightKubernetesClusterProfile -Moid $moids.cluster_profile_moid # -Name $iksProfileName

if ($iksClusterProfile.Status -eq "Undeployed") {
    Set-IntersightKubernetesClusterProfile -Action $action -Moid $moids.cluster_profile_moid | Out-Null

    Get-IksProfileStatus($moids.cluster_profile_moid)
    # while( $true ) {
    #     # Pull Cluster Profile Status
    #     $iksClusterProfile =  Get-IntersightKubernetesClusterProfile -Moid $moids.cluster_profile_moid
    #     $clusterStatus = $iksClusterProfile.Status
    #     Write-Host "IKS Cluster Deploy Status: $($clusterStatus)"
    #
    #     # Add 60 Secs delay
    #     Start-Sleep -Seconds 60
    #
    #     # Verify Cluster Status
    #     if ($iksClusterProfile.Status -eq "DeployFailedTerminal") {
    #         Write-Host "IKS Cluster Deployment Failed!"
    #         break
    #     }
    #     if ($iksClusterProfile.Status -eq "Ready") {
    #         Write-Host "IKS Cluster Deployment Failed!"
    #         break
    #     }
    # }
}
if ($iksClusterProfile.Status -eq "Ready") {
    Write-Host "IKS Cluster Already Deployed!"
}

if ($iksClusterProfile.Status -eq "Configuring") {
    Write-Host "IKS Cluster State is Configuring, which means a change is in-progress"
    Get-IksProfileStatus($moids.cluster_profile_moid)
}

if ($iksClusterProfile.Status -eq "Deploying") {
    Write-Host "IKS Cluster State is Deploying!"
    Get-IksProfileStatus($moids.cluster_profile_moid)
}

EXIT