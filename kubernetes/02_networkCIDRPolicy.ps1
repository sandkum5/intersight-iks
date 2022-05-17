<#
This script creates a new Network CIDR Policy. 
#>

# Source Variables file
. ./00_variables.ps1

Set-IntersightConfiguration @ApiParams

# Variables Section 
$name           = "pwsh_netcidr1"
$description    = "pwsh network cidr policy"
$podNetworkCidr = "10.1.1.0/16"
$serviceCidr    = "10.2.2.2/24"

# Create Network Policy
New-IntersightKubernetesNetworkPolicy -Name $name -Description $description -Tags $tags -Organization $myOrg  -PodNetworkCidr $podNetworkCidr -ServiceCidr $serviceCidr
