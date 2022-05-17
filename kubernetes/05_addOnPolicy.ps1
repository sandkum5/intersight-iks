<#
This script creates a new Add-on Policy. 
#>

# Source Variables file
. ./00_variables.ps1

Set-IntersightConfiguration @ApiParams

# Variables Section
$name             = "pwsh_addon1"
$description      = "pwsh Addon Policy"
$installStrategy  = "NoAction"  # Options[None, NoAction, InstallOnly, Always]
$upgradeStrategy  = "NoAction"  # Options[None, NoAction, UpgradeOnly, ReinstallOnFailure, AlwaysReinstall]
$overrides        = ""
$releaseNamespace = ""


# Get Addon Definitions Name and Moids
$getAddonDefinition = (Get-IntersightKubernetesAddonDefinition -InlineCount allpages -Skip 0 -Top 10 -Filter "Labels ne 'Essential' and Labels ne 'EOL' and Labels ne 'Deprecated' and Labels ne 'TechPreview'").Results | Select-Object -Property Name,Moid

Write-Host "Add-on list:"
foreach ($selectAddonName in $getAddonDefinition.Name) {
    Write-Host $selectAddonName
}
while ($True) {
    $addonName = Read-Host -Prompt "Enter an Add-on Name from the above  list"
    # Addon Names: kubernetes-dashboard, smm, ccp-monitor
    if ($addonName -in $getAddonDefinition.Name) {
        Write-Host "Addon Name looks good!"
        break
    } else {
        Write-Host "Re-Enter Addon Name"
    }
}

$addonMoid = ($getAddonDefinition | Where-Object {$_.Name -eq "$($addonName)"}).moid

$addonDefinitionObject = Initialize-IntersightMoMoRef -ClassId "MoMoRef" -ObjectType "KubernetesAddonDefinition" -Moid $addonMoid

$addonConfig = Initialize-IntersightKubernetesAddonConfiguration -InstallStrategy $installStrategy -UpgradeStrategy $upgradeStrategy -Overrides $overrides -ReleaseNamespace $releaseNamespace

# Create IKS Addon-Policy
New-IntersightKubernetesAddonPolicy -Name $name -Description $description -Tags $tags -Organization $myOrg -AddonDefinition $addonDefinitionObject -AddonConfiguration $addonConfig
