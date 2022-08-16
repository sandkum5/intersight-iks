<#
This script creates a new VM Infra Provider Worker Policy.
Depends_on Node Group Profiles.
#>

# Source Variables file
. ./variables.ps1

# Read File
$moids = Get-Content -Path "$pwd/$moidFileName" | ConvertFrom-Json

# Initialize Objects
$instanceTypeObject = Get-IntersightKubernetesVirtualMachineInstanceType -Moid $moids.vm_instance_moid

$infraConfigObject = Get-IntersightKubernetesVirtualMachineInfraConfigPolicy -Moid $moids.vm_infra_config_moid

$nodeGroupObject = Get-IntersightKubernetesNodeGroupProfile -Moid $moids.worker_node_group_moid

# Create Virtual Machine Infrastructure Providers Policy
$policyProps = @{
    Name              = $wVMInfraProvider
    InstanceType      = $instanceTypeObject
    InfraConfigPolicy = $infraConfigObject
    NodeGroup         = $nodeGroupObject
}

$result = New-IntersightKubernetesVirtualMachineInfrastructureProvider @policyProps

Write-Host "Created Worker VM Infra Provider policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

# Add Moid to moids.json file
Invoke-UdfAddMoid -File $moidFileName -Name 'worker_vm_infra_provider_moid' -Value $result.Moid

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding ascii