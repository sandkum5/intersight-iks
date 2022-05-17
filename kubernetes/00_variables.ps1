<#
Common Variables file for Policies and Profiles
#>

# Intersight Configuration
$ApiParams = @{
    BasePath          = "https://intersight.com"
    ApiKeyId          = Get-Content -Path ./apiKey.txt -Raw
    ApiKeyFilePath    = $pwd.Path + "/SecretKey.txt"
    HttpSigningHeader = @("(request-target)", "Host", "Date", "Digest")
}

Set-IntersightConfiguration @ApiParams

# Org Info
$orgName = "default"
$myOrg   = Get-IntersightOrganizationOrganization -Name $orgName

# Define Tags
$tags    = Initialize-IntersightMoTag -Key 'Location' -Value 'San Jose' 

$k8sSSHKey = ""  # Copy the public key from ~/.ssh/ dir. Command to generate the keys: ssh-keygen -t ecdsa -b 521