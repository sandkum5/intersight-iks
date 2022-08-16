<#
This script creates a new Kubernetes Version Policy.
#>

# Source Variables file
. ./variables.ps1

# Get Kubernetes Version Moids
$versionProps = @{
    InlineCount='allpages'
    Skip=0
    Top=10
    Filter="not(Tags/any(t:t/Key eq 'intersight.profile.SolutionOwnerType' or (t/Key eq 'intersight.kubernetes.SupportStatus' and t/Value in ('Unsupported', 'Deprecated', 'UpgradeRequired'))))"
}
$versionMoids = (Get-IntersightKubernetesVersion @versionProps).results | Select-Object Name,Moid

Write-Host "Enter a Kubernetes Version from the following list:" -ForegroundColor Yellow
foreach ($kubeVersion in $versionMoids.Name) {
    Write-Host $kubeVersion -ForegroundColor Yellow
}

# Get Kubernetes Version
while ($True) {
    $k8sVersion = Read-Host -Prompt "Enter Kubernetes Version from the above list"
    if ($k8sVersion -in $versionMoids.Name) {
        Write-Host "Kubernetes Version looks good!" -ForegroundColor Yellow
        break
    } else {
        Write-Host "Re-Enter Kubernetes Version" -ForegroundColor Yellow
    }
}

# Get the desired Verion Moid
$versionMoid = ($versionMoids | Where-Object {$_.Name -eq "$($k8sVersion)"}).moid

# Initialize Version Object
# $versionObject = Initialize-IntersightMoMoRef -ClassId "MoMoRef" -ObjectType "KubernetesVersion" -Moid $versionMoid
$versionObject = Get-IntersightKubernetesVersion -Moid $versionMoid | Get-IntersightMoMoRef

# Create Kubernetes Version Policy
$policyProps = @{
    Name         = $name
    Description  = $description
    Tags         = $tags
    Organization = $myOrg
    Version      = $versionObject
}

$result = New-IntersightKubernetesVersionPolicy @policyProps

Write-Host "Created Kubernetes Version policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor DarkMagenta

# Add Moid to moids.json file
Invoke-UdfAddMoid -File $moidFileName -Name 'kube_version_moid' -Value $result.Moid

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding ascii