<#
This script creates a new Node OS Configuration Policy. 
#>

# Source Variables file
. ./00_variables.ps1

Set-IntersightConfiguration @ApiParams

# Variables Section
$name        = "pwsh_nodosconfig1"
$description = "pwsh Node OS/Sys config policy"
$dnsServers  = "8.8.8.8"
$ntpServers  = "4.4.4.4"
$timezone    = "AmericaLosAngeles"

# Create Node OS Configuration/ Sys configuration Policy
New-IntersightKubernetesSysConfigPolicy -Name $name -Description $description -Tags $tags -Organization $myOrg -DnsServers $dnsServers -NtpServers $ntpServers -Timezone $timezone

# Additional Parameters: -DnsDomainName <string>