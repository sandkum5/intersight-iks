<#
This script creates a new Add-on Policy.
#>

# Source Variables file
. ./variables.ps1

# Get Addon Definitions Name and Moids
$addonDefProps = @{
    InlineCount="allpages"
    Skip=0
    Top=10
    Filter="Labels ne 'Essential' and Labels ne 'EOL' and Labels ne 'Deprecated' and Labels ne 'TechPreview'"
}

$getAddonDefinition = (Get-IntersightKubernetesAddonDefinition @addonDefProps).Results | Select-Object -Property Name,Moid

Write-Host "Add-on list:" -ForegroundColor Yellow
foreach ($_ in $getAddonDefinition.Name) {
    Write-Host $_ -ForegroundColor Yellow
}
while ($True) {
    $addonName = Read-Host -Prompt "Enter an Add-on from the above  list"
    # Addon Names: kubernetes-dashboard, smm, ccp-monitor
    if ($addonName -in $getAddonDefinition.Name) {
        Write-Host "Addon looks good!" -ForegroundColor Green
        break
    } else {
        Write-Host "Re-Enter Addon Name" -ForegroundColor Red
    }
}

$addonMoid = ($getAddonDefinition | Where-Object {$_.Name -eq "$($addonName)"}).moid

# $addonDefinitionObject = Initialize-IntersightMoMoRef -ClassId "MoMoRef" -ObjectType "KubernetesAddonDefinition" -Moid $addonMoid
$addonDefinitionObject = Get-IntersightKubernetesAddonDefinition -Moid $addonMoid | Get-IntersightMoMoRef

$addonConfigProps = @{
    InstallStrategy  = $installStrategy
    UpgradeStrategy  = $upgradeStrategy
    Overrides        = $overrides
    ReleaseNamespace = $releaseNamespace
}
$addonConfig = Initialize-IntersightKubernetesAddonConfiguration @addonConfigProps

# Create IKS Addon-Policy
$addonProps = @{
    Name               = Read-Host -Prompt "Enter an Add-on Name" # $addonName
    Description        = $description
    Tags               = $tags
    Organization       = $myOrg
    AddonDefinition    = $addonDefinitionObject
    AddonConfiguration = $addonConfig
}

$result = New-IntersightKubernetesAddonPolicy @addonProps

Write-Host "Created Add-on policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

# Add moid to the moids.json file
Invoke-UdfAddMoid -File $moidFileName -Name 'addon_moid_list' -Value $result.Moid

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding ascii