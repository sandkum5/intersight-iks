<#
This script creates a new Node Group Profile for Control Plane Node.
#>

# Source Variables file
. ./variables.ps1

# Read File
$moids = Get-Content -Path "$pwd/$moidFileName" | ConvertFrom-Json

# Initialize Objects
$clusterProfileObject = Get-IntersightKubernetesClusterProfile -Moid $moids.cluster_profile_moid

$kubernetesVersionObject = Get-IntersightKubernetesVersionPolicy -Moid $moids.kube_version_moid

$ipPoolsObject = Get-IntersightIppoolPool -Moid $moids.ippool_moid | Get-IntersightMoMoRef

$label1 = Initialize-IntersightKubernetesNodeGroupLabel -Key "Location" -Value "SJ"
$label2 = Initialize-IntersightKubernetesNodeGroupLabel -Key "Type" -Value "DC"
$labels = @($label1, $label2)

# Create Kubernetes Node Group Profile
$policyProps = @{
    Name              = $cpName
    NodeType          = $cpNodeType
    Desiredsize       = $cpDesiredSize
    Minsize           = $cpMinSize
    Maxsize           = $cpMaxSize
    ClusterProfile    = $clusterProfileObject
    KubernetesVersion = $kubernetesVersionObject
    IpPools           = $ipPoolsObject
    Labels            = $labels
}

$result = New-IntersightKubernetesNodeGroupProfile @policyProps

Write-Host "Created Control Node Group profile '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

# Add Moid to moids.json file
Invoke-UdfAddMoid -File $moidFileName -Name 'cp_node_group_moid' -Value $result.Moid

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding ascii