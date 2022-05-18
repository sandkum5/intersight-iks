<#
This script creates a new Node Group Profile for Control Plane Node. 
#>

# Source Variables file
. ./00_variables.ps1

Set-IntersightConfiguration @ApiParams

# Variables Section
$name                 = "pwsh_cpNodegroup_profile"
$nodeType             = "ControlPlane"
$desiredSize          = 1
$minSize              = 1
$maxSize              = 2
$clusterProfileName   = "pwsh_k8s1"
$k8sVersionPolicyName = "pwsh_kubeversion1"
$ipPoolPolicyName     = "pwsh_ippool1"

# Initialize Objects
$clusterProfileObject = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType kubernetesClusterProfile -Selector "Name eq '$($clusterProfileName)'"

$kubernetesVersionObject = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType kubernetesVersionPolicy -Selector "Name eq '$($k8sVersionPolicyName)'"

$ipPoolsObject = Initialize-IntersightMoMoRef -ClassId MoMoRef -ObjectType ippoolPool -Selector "Name eq '$($ipPoolPolicyName)'"

$label1 = Initialize-IntersightKubernetesNodeGroupLabel -Key "Location" -Value "SJ"
$label2 = Initialize-IntersightKubernetesNodeGroupLabel -Key "Type" -Value "DC"
$labels = @($label1, $label2)

# Create Kubernetes Node Group Profile
$result = New-IntersightKubernetesNodeGroupProfile -Name $name -NodeType $nodeType -Desiredsize $desiredSize -Minsize $minSize -Maxsize $maxSize -ClusterProfile $clusterProfileObject -KubernetesVersion $kubernetesVersionObject -IpPools $ipPoolsObject -Labels $labels
Write-Host "Created Control Node Group profile '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta
$result | Out-File -FilePath ./output.log -Append