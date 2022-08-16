<#
This script creates a new VM Instance Policy.
#>

# Source Variables file
. ./variables.ps1

$props = @{
    Name=$name
    Description=$description
    Organization=$myOrg
    Tags=$tags
    Cpu=$cpu
    DiskSize=$diskSize
    Memory=$memory
}

# Create VM Instance Type Policy
$result = New-IntersightKubernetesVirtualMachineInstanceType @props

Write-Host "Created VM Instance policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor "DarkMagenta"

# Add Moid to moids.json file
Invoke-UdfAddMoid -File $moidFileName -Name 'vm_instance_moid' -Value $result.Moid

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding "ascii"