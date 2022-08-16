<#
This script creates a new Node Group Profile for Worker Node.
#>

# Source Variables file
. ./variables.ps1

# Read File
$moids = Get-Content -Path "$pwd/$moidFileName" | ConvertFrom-Json

# Initialize Objects
$iksClusterProfile = Get-IntersightKubernetesClusterProfile -Moid $moids.cluster_profile_moid

$kubernetesVersionPolicy = Get-IntersightKubernetesVersionPolicy -Moid $moids.kube_version_moid

$ipPoolsObject = Get-IntersightIppoolPool -Moid $moids.ippool_moid | Get-IntersightMoMoRef

$label1 = Initialize-IntersightKubernetesNodeGroupLabel -Key "Location" -Value "SJ"
$label2 = Initialize-IntersightKubernetesNodeGroupLabel -Key "Type" -Value "DC"
$labels = @($label1, $label2)

# Create Kubernetes Node Group Profile
$policyProps = @{
    Name              = $wName
    NodeType          = $wNodeType
    Desiredsize       = $wDesiredSize
    Minsize           = $wMinSize
    Maxsize           = $wMaxSize
    ClusterProfile    = $iksClusterProfile
    KubernetesVersion = $kubernetesVersionPolicy
    IpPools           = $ipPoolsObject
    Labels            = $labels
}

$result = New-IntersightKubernetesNodeGroupProfile @policyProps

Write-Host "Created Worker Node Group Profile '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor "DarkMagenta"

# Add Moid to moids.json file
Invoke-UdfAddMoid -File $moidFileName -Name 'worker_node_group_moid' -Value $result.Moid

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding ascii