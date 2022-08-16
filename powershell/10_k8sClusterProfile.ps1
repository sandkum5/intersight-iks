<#
This script creates a new Kubernetes Cluster Profile.
#>

# Source Variables file
. ./variables.ps1

# Read File
$moids = Get-Content -Path "$pwd/$moidFileName" | ConvertFrom-Json

# Cluster Configuration
# IP Pool Policy: IP Pool under Cluster Config
$clusterIpPoolsObject = Get-IntersightIppoolPool -Moid $moids.ippool_moid | Get-IntersightMoMoRef

# Management Config: LB Count, SSH User, Public Key
$mgmtConfigObject = Initialize-IntersightKubernetesClusterManagementConfig -LoadBalancerCount $lbCount -SshKeys $sshKey

# Sys Config Policy
$sysConfigObject = Get-IntersightKubernetesSysConfigPolicy -Moid $moids.sys_config_moid

# Net Config Policy
$netConfigObject = Get-IntersightKubernetesNetworkPolicy -Moid $moids.net_policy_moid

# Create Cluster Profile
$profileProps = @{
    Name             = $name
    Description      = $description
    ManagedMode      = $managedMode
    Organization     = $myOrg
    Tags             = $tags
    ClusterIpPools   = $clusterIpPoolsObject
    ManagementConfig = $mgmtConfigObject
    SysConfig        = $sysConfigObject
    NetConfig        = $netConfigObject
}

$result = New-IntersightKubernetesClusterProfile @profileProps

Write-Host "Created Kubernetes Cluster policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor "DarkMagenta"

# Add Moid to moids.json file
Invoke-UdfAddMoid -File $moidFileName -Name 'cluster_profile_moid' -Value $result.Moid

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding "ascii"