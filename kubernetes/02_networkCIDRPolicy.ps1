<#
This script creates a new Network CIDR Policy. 
#>

# Source Variables file
. ./00_variables.ps1

# Variables Section 
$name           = "pwsh_netcidr1"
$description    = "pwsh network cidr policy"
$podNetworkCidr = "10.1.1.0/16"
$serviceCidr    = "10.2.2.2/24"

# Create Network Policy
$result = New-IntersightKubernetesNetworkPolicy -Name $name -Description $description -Tags $tags -Organization $myOrg  -PodNetworkCidr $podNetworkCidr -ServiceCidr $serviceCidr
Write-Host "Created Network policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta
$result | Out-File -FilePath ./output.log -Append