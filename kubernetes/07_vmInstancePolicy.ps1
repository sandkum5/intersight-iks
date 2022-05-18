<#
This script creates a new VM Instance Policy. 
#>

# Source Variables file
. ./00_variables.ps1

Set-IntersightConfiguration @ApiParams

# Variables Section
$name        = "pwsh_vm_instance"
$description = "pwsh VM Instance Policy"
$cpu         = 4       # Range 1-40
$diskSize    = 15      # Range(in GiB) >0
$memory      = 16384   # Range(in mebibytes) 1-4177920

# Create VM Instance Type Policy
$result = New-IntersightKubernetesVirtualMachineInstanceType -Name $name -Description $description -Organization $myOrg -Tags $tags -Cpu $cpu -DiskSize $diskSize -Memory $memory
Write-Host "Created VM Instance policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta
$result | Out-File -FilePath ./output.log -Append