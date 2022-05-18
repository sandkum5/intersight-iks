<#
This script creates a new Node OS Configuration Policy. 
#>

# Source Variables file
. ./00_variables.ps1

# Variables Section
$name        = "pwsh_nodosconfig1"
$description = "pwsh Node OS/Sys config policy"
$dnsServers  = "8.8.8.8"
$ntpServers  = "4.4.4.4"
$timezone    = "AmericaLosAngeles"

# Create Node OS Configuration/ Sys configuration Policy
$result = New-IntersightKubernetesSysConfigPolicy -Name $name -Description $description -Tags $tags -Organization $myOrg -DnsServers $dnsServers -NtpServers $ntpServers -Timezone $timezone

# Additional Parameters: -DnsDomainName <string>
Write-Host "Created Node OS Config policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta
$result | Out-File -FilePath ./output.log -Append