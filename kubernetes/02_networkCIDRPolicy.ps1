<#
This script creates a new Network CIDR Policy. 
#>

# Source Variables file
. ./00_variables.ps1

# Variables Section 
$name           = $baseName
$description    = $descriptionValue
$podNetworkCidr = "10.1.1.0/16"
$serviceCidr    = "10.2.2.2/24"

# Create Network Policy
$result = New-IntersightKubernetesNetworkPolicy -Name $name -Description $description -Tags $tags -Organization $myOrg  -PodNetworkCidr $podNetworkCidr -ServiceCidr $serviceCidr
Write-Host "Created Network policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

Write-Output "$($result.ClassId),$($result.Name),$($result.Moid)" | Out-File -FilePath ./moids.log -Append

$result | Out-File -FilePath ./results.log -Append -Encoding ascii