<#
This script creates a SysConfig Policy.
#>

# Source Variables file
. ./variables.ps1

# Create Node OS Configuration / Sys configuration Policy
$policyProps = @{
    Name         = $name
    Description  = $description
    Tags         = $tags
    Organization = $myOrg
    DnsServers   = $dnsServers
    NtpServers   = $ntpServers
    Timezone     = $timezone
}

$result = New-IntersightKubernetesSysConfigPolicy @policyProps

# Additional Parameters: -DnsDomainName <string>
Write-Host "Created Node OS Config policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

# Add Moid to moids.json file
Invoke-UdfAddMoid -File $moidFileName -Name 'sys_config_moid' -Value $result.Moid

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding ascii