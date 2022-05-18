<#
This script creates a new IP Pool Policy, updates it, and destroys it. 
#>

# Source Variables file
. ./00_variables.ps1

Set-IntersightConfiguration @ApiParams

# Script Variables. Not defined in Intersight API.
$ipv4Enable         = $True
$ipv6Enable         = $False

# Variables Section
$name               = "pwsh_ippool1"
$description        = "pwsh demo IP Pool"
# ipv4
$ipv4StartIp        = "10.1.1.2" # string x.x.x.x
$ipv4Size           = 10 # Int 
$ipv4Gateway        = "10.1.1.1"
$ipv4Netmask        = "255.255.255.0"
$ipv4PrimaryDns     = "8.8.8.8"
$ipv4SecondaryDns   = "8.8.4.4"
# ipv6
$ipv6StartIp        = ""
$ipv6Size           = 1
$ipv6Gateway        = ""
$ipv6Prefix         = 64 # 1-127
$ipv6PrimaryDns     = ""
$ipv6SecondaryDns   = ""

# IPv4 Configuration
if ($ipv4Enable) {
    $ipv4Block1 = Initialize-IntersightIppoolIpV4Block -From $ipv4StartIp -Size $ipv4Size
    $ipv4Blocks = @($ipv4Block1)
    $ipv4ConfigObject = Initialize-IntersightIppoolIpV4Config -Gateway $ipv4Gateway -Netmask $ipv4Netmask -PrimaryDns $ipv4PrimaryDns -SecondaryDns $ipv4SecondaryDns
}

# IPv6 Configuration
if ($ipv6Enable) {
    $ipv6Block1 = Initialize-IntersightIppoolIpV4Block -From $ipv6StartIp -Size $ipv6Size
    $ipv6Blocks = @($ipv6Block1)
    $ipv6ConfigObject = Initialize-IntersightIppoolIpV6Config -Gateway $ipv6Gateway -Prefix $ipv6Prefix -PrimaryDns $ipv6PrimaryDns -SecondaryDns $ipv6SecondaryDns
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
switch ($case)
{
    1 {$result = New-IntersightIppoolPool -Name $name -Description $description -Organization $myOrg -Tags $tags -IpV4Blocks $ipv4Blocks -IpV4Config $ipv4ConfigObject}
    2 {$result = New-IntersightIppoolPool -Name $name -Description $description -Organization $myOrg -Tags $tags -IpV6Blocks $ipv6Blocks -IpV6Config $ipv6ConfigObject}
    3 {$result = New-IntersightIppoolPool -Name $name -Description $description -Organization $myOrg -Tags $tags -IpV4Blocks $ipv4Blocks -IpV4Config $ipv4ConfigObject -IpV6Blocks $ipv6Blocks -IpV6Config $ipv6ConfigObject}
}

Write-Host "Created IP Pool policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta
$result | Out-File -FilePath ./output.log -Append