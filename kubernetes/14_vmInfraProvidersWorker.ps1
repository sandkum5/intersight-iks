<#
This script creates a new VM Infra Provider Worker Policy.
Depends_on Node Group Profiles. 
#>

# Source Variables file
. ./00_variables.ps1

# Variables Section
$name                  = $baseName
$vmInstanceName        = $baseName
$infraConfigPolicyName = $baseName
$nodeGroupName         = $baseName

# Initialize Objects
$instanceTypeObject = Initialize-IntersightMoMoRef -ClassId "MoMoRef" -ObjectType "kubernetesVirtualMachineInstanceType" -Selector "Name eq '$($vmInstanceName)'"

$infraConfigPolicyObject = Initialize-IntersightMoMoRef -ClassId "MoMoRef" -ObjectType "kubernetesVirtualMachineInfraConfigPolicy" -Selector "Name eq '$($infraConfigPolicyName)'"

$nodeGroupObject = Initialize-IntersightMoMoRef -ClassId "MoMoRef" -ObjectType "kubernetesNodeGroupProfile" -Selector "Name eq '$($nodeGroupName)'"

# Create Virtual Machine Infrastructure Providers Policy
$result = New-IntersightKubernetesVirtualMachineInfrastructureProvider -Name $name -InstanceType $instanceTypeObject -InfraConfigPolicy $infraConfigPolicyObject -NodeGroup $nodeGroupObject
Write-Host "Created Worker VM Infra Providers policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

Write-Output "$($result.ClassId),$($result.Name),$($result.Moid)" | Out-File -FilePath ./moids.log -Append

$result | Out-File -FilePath ./results.log -Append -Encoding ascii