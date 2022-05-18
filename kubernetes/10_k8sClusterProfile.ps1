<#
This script creates a new Kubernetes Cluster Profile. 
#>

# Source Variables file
. ./00_variables.ps1

# Variables Section
$name             = $baseName
$description      = $descriptionValue
$managedMode      = "Managed" 
$ipPoolPolicyName = $baseName
$lbCount          = 1
$sshKey           = $sshKeyVar
$sysConfigName    = $baseName
$netConfigName    = $baseName


# Cluster Configuration
# IP Pool Policy: IP Pool under Cluster Config
$clusterIpPoolsObject = Initialize-IntersightMoMoRef  -ClassId MoMoRef -ObjectType ippoolPool -Selector "Name eq '$($ipPoolPolicyName)'"

# Management Config: LB Count, SSH User, Public Key
$mgmtConfigObject = Initialize-IntersightKubernetesClusterManagementConfig -LoadBalancerCount $lbCount -SshKeys $sshKey         

# Sys Config Policy
$sysConfigObject = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType kubernetesSysConfigPolicy -Selector "Name eq '$($sysConfigName)'"

# Net Config Policy
$netConfigObject = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType kubernetesNetworkPolicy -Selector "Name eq '$($netConfigName)'"

# Create Cluster Profile
$result = New-IntersightKubernetesClusterProfile -Name $name -Description $description -ManagedMode $managedMode -Organization $myOrg -Tags $tags -ClusterIpPools $clusterIpPoolsObject -ManagementConfig $mgmtConfigObject -SysConfig $sysConfigObject -NetConfig $netConfigObject 
Write-Host "Created Kubernetes Cluster policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

Write-Output "$($result.ClassId),$($result.Name),$($result.Moid)" | Out-File -FilePath ./moids.log -Append

$result | Out-File -FilePath ./results.log -Append -Encoding ascii