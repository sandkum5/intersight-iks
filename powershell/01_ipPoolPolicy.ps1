<#
This script creates a new IP Pool Policy, updates it, and destroys it.
#>

# Source Variables file
. ./variables.ps1

# IPv4 Configuration
$v4config = @{
    Gateway      = $ipv4Gateway
    Netmask      = $ipv4Netmask
    PrimaryDns   = $ipv4PrimaryDns
    SecondaryDns = $ipv4SecondaryDns
}
if ($ipv4Enable) {
    $ipv4Block1 = Initialize-IntersightIppoolIpV4Block -From $ipv4StartIp -Size $ipv4Size
    $ipv4Blocks = @($ipv4Block1)
    $ipv4ConfigObject = Initialize-IntersightIppoolIpV4Config @v4config
}

# IPv6 Configuration
$v6config = @{
    Gateway      = $ipv6Gateway
    Prefix       = $ipv6Prefix
    PrimaryDns   = $ipv6PrimaryDns
    SecondaryDns = $ipv6SecondaryDns
}
if ($ipv6Enable) {
    $ipv6Block1 = Initialize-IntersightIppoolIpV4Block -From $ipv6StartIp -Size $ipv6Size
    $ipv6Blocks = @($ipv6Block1)
    $ipv6ConfigObject = Initialize-IntersightIppoolIpV6Config @v6config
}

# Set case variable based on if IPv4 and IPv6 are enabled
if ($ipv4Enable -and !$ipv6Enable) {
    $case = 1
} elseif (!$ipv4Enable -and $ipv6Enable) {
    $case = 2
} elseif ($ipv4Enable -and $ipv6Enable) {
    $case = 3
}

# Create Policy
$commProps = @{
    Name         = $name
    Description  = $description
    Organization = $myOrg
    Tags         = $tags
}

$v4Props = @{
    IpV4Blocks = $ipv4Blocks
    IpV4Config = $ipv4ConfigObject
}

$v6Props = @{
    IpV6Blocks = $ipv6Blocks
    IpV6Config = $ipv6ConfigObject
}

switch ($case)
{
    1 {$result = New-IntersightIppoolPool @commProps @v4Props}
    2 {$result = New-IntersightIppoolPool @commProps @v6Props}
    3 {$result = New-IntersightIppoolPool @commProps @v4Props @v6Props}
}

Write-Host "Created IP Pool policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

# Add Moid to moids.json file
Invoke-UdfAddMoid -File $moidFileName -Name 'ippool_moid' -Value $result.Moid

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding ascii
