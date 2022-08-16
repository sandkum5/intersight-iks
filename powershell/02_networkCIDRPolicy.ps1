<#
This script creates a new Network CIDR Policy.
#>

# Source Variables file
. ./variables.ps1

# Create Network Policy
$policyProps = @{
    Name           = $name
    Description    = $description
    Tags           = $tags
    Organization   = $myOrg
    PodNetworkCidr = $podNetworkCidr
    ServiceCidr    = $serviceCidr
}

$result = New-IntersightKubernetesNetworkPolicy @policyProps

Write-Host "Created Network policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

# Add Moid to moids.json file
Invoke-UdfAddMoid -File $moidFileName -Name 'net_policy_moid' -Value $result.Moid

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding ascii