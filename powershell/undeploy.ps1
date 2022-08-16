<#
This script undeploys Kubernetes Cluster.
#>

# Source Variables file
. ./variables.ps1

# Variables Section
$action         = "Undeploy"
$iksProfileName = $name


$iksClusterProfile =  Get-IntersightKubernetesClusterProfile -Name $iksProfileName

if ($iksClusterProfile.Status -eq "Ready") {
    Set-IntersightKubernetesClusterProfile -Action $action

    while( $true ) {
        $iksClusterProfile =  Get-IntersightKubernetesClusterProfile -Name $iksProfileName
        $clusterStatus = $iksClusterProfile.Status
        Write-Host "IKS Cluster Undeploy Status: $($clusterStatus)"

        if ($iksClusterProfile.Status -eq "Undeploying") {
            Start-Sleep -Seconds 60
        }

        if ($iksClusterProfile.Status -eq "DeployFailedTerminal") {
            Write-Host "IKS Cluster Deployment in Failed State!"
            break
        }
        if ($iksClusterProfile.Status -eq "Undeployed") {
            Write-Host "IKS Cluster Undeployed Successfully!"
            break
        }
    }
}


