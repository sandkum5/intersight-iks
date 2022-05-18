<#
This script creates a new Kubernetes Version Policy. 
#>

# Source Variables file
. ./00_variables.ps1

Set-IntersightConfiguration @ApiParams

# Variables Section
$name        = "pwsh_kubeversion1"
$description = "pwsh Kubernetes Version Policy"

# Get Kubernetes Version Moids
$versionMoids = (Get-IntersightKubernetesVersion -InlineCount 'allpages' -Skip 0 -Top 10 -Filter "not(Tags/any(t:t/Key eq 'intersight.profile.SolutionOwnerType' or (t/Key eq 'intersight.kubernetes.SupportStatus' and t/Value in ('Unsupported', 'Deprecated', 'UpgradeRequired'))))").results | Select-Object Name,Moid

Write-Host "Enter a Kubernetes Version from the following list:" -ForegroundColor Yellow
foreach ($kubeVersion in $versionMoids.Name) {
    Write-Host $kubeVersion -ForegroundColor Yellow
}
while ($True) {
    $k8sVersion = Read-Host -Prompt "Enter Kubernetes Version from the above list"
    if ($k8sVersion -in $versionMoids.Name) {
        Write-Host "Kubernetes Version looks good!" -ForegroundColor Green
        break
    } else {
        Write-Host "Re-Enter Kubernetes Version" -ForegroundColor Red
    }
}

# Get the desired Verion Moid
$versionMoid = ($versionMoids | Where-Object {$_.Name -eq "$($k8sVersion)"}).moid

# Initialize Version Object
$versionObject = Initialize-IntersightMoMoRef -ClassId "MoMoRef" -ObjectType "KubernetesVersion" -Moid $versionMoid

# Create Kubernetes Version Policy
$result = New-IntersightKubernetesVersionPolicy -Name $name -Description $description -Tags $tags -Organization $myOrg -Version $versionObject
Write-Host "Created Kubernetes Version policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta
$result | Out-File -FilePath ./output.log -Append