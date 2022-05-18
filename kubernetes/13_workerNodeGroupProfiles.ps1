<#
This script creates a new Node Group Profile for Worker Node. 
#>

# Source Variables file
. ./00_variables.ps1

# Variables Section
$name                 = $baseName
$nodeType             = "Worker"
$desiredSize          = 1
$minSize              = 1
$maxSize              = 2
$clusterProfileName   = $baseName
$k8sVersionPolicyName = $baseName
$ipPoolPolicyName     = $baseName

# Initialize Objects
$clusterProfileObject = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType kubernetesClusterProfile -Selector "Name eq '$($clusterProfileName)'"

$kubernetesVersionObject = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType kubernetesVersionPolicy -Selector "Name eq '$($k8sVersionPolicyName)'"

$ipPoolsObject = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType ippoolPool -Selector "Name eq '$($ipPoolPolicyName)'"

$label1 = Initialize-IntersightKubernetesNodeGroupLabel -Key "Location" -Value "SJ"
$label2 = Initialize-IntersightKubernetesNodeGroupLabel -Key "Type" -Value "DC"
$labels = @($label1, $label2)

# Create Kubernetes Node Group Profile
$result = New-IntersightKubernetesNodeGroupProfile -Name $name -NodeType $nodeType -Desiredsize $desiredSize -Minsize $minSize -Maxsize $maxSize -ClusterProfile $clusterProfileObject -KubernetesVersion $kubernetesVersionObject -IpPools $ipPoolsObject -Labels $labels
Write-Host "Created Worker Node Group Profile '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

Write-Output "$($result.ClassId),$($result.Name),$($result.Moid)" | Out-File -FilePath ./moids.log -Append

$result | Out-File -FilePath ./results.log -Append -Encoding ascii