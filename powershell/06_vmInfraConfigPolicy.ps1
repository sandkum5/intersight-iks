<#
This script creates a new VM Infra Config Policy.
#>

# Source Variables file
. ./variables.ps1

# Get VMware Cluster
$vmwareCluster = (Get-IntersightVirtualizationVmwareCluster -InlineCount allpages).results | Select-Object Name,Moid

# Choose Cluster Name
Write-Host "VMware Cluster List:" -ForegroundColor "Yellow"
foreach ($vmwareClusterName in $vmwareCluster.Name) {
    Write-host $vmwareClusterName -ForegroundColor "Yellow"
}
while ($True) {
    $clusterName = Read-Host -Prompt "Enter a VMware Cluster name from the above  list"
    if ($clusterName -in $vmwareCluster.Name) {
        Write-Host "Vmware Cluster Name looks good!" -ForegroundColor "Green"
        break
    } else {
        Write-Host "Re-Enter Vmware Cluster Name" -ForegroundColor "Red"
    }
}
# Write-Host "`r`n"

# Get Vmware Cluster Moid
$vmwareClusterMoid = (Get-IntersightVirtualizationVmwareCluster -InlineCount allpages -Filter "Name eq '$($clusterName)'").results.moid

# Get Datastores:
# $vmwareDatastoresList = (Get-IntersightVirtualizationVmwareDatastore -InlineCount allpages -Filter "Cluster.Moid eq '$($vmwareClusterMoid)'").results | Select-Object -Property Name,Moid, @{n='deviceMoid';e={$_ | Select-Object -Expand "RegisteredDevice" | Select-Object -ExpandProperty "ActualInstance" | Select-Object -ExpandProperty "Moid"}}
$vmwareDatastoresList = (Get-IntersightVirtualizationVmwareDatastore -InlineCount allpages -Filter "Cluster.Moid eq '$($vmwareClusterMoid)'").results | Select-Object -Property Name,Moid, @{n='deviceMoid';e={$_.RegisteredDevice.ActualInstance.Moid}}

# Select Datastore Name
Write-Host "VMware Datastore List:" -ForegroundColor "Yellow"
foreach ($vmwareDatastoreName in $vmwareDatastoresList.Name) {
    Write-host $vmwareDatastoreName -ForegroundColor "Yellow"
}

while ($True) {
    $datastoreName = Read-Host -Prompt "Enter a VMware Datastore name from the above list"
    if ($datastoreName -in $vmwareDatastoresList.Name) {
        Write-Host "Vmware Datastore Name looks good!" -ForegroundColor "Green"
        break
    } else {
        Write-Host "Re-Enter Vmware Datastore Name" -ForegroundColor "Red"
    }
}
# Write-Host "`r`n"

# Get Datastore Device Moid
# $registeredDeviceMoid = ((Get-IntersightVirtualizationVmwareDatastore -InlineCount allpages -Filter "Cluster.Moid eq '$($vmwareClusterMoid)'").results | Select-Object -Property Name,Moid, @{n='deviceMoid';e={$_ | Select-Object -Expand RegisteredDevice | Select-Object -ExpandProperty "ActualInstance" | Select-Object -ExpandProperty "Moid"}} | Where-Object {$_.Name -eq $datastoreName}).deviceMoid | Get-Unique

$registeredDeviceMoid = ((Get-IntersightVirtualizationVmwareDatastore -InlineCount allpages -Filter "Cluster.Moid eq '$($vmwareClusterMoid)'").results | Select-Object -Property Name,Moid, @{n='deviceMoid';e={$_.RegisteredDevice.ActualInstance.Moid}} | Where-Object {$_.Name -eq $datastoreName}).deviceMoid | Get-Unique

# Get DVS Networks
$vmwareDvsNetList = (Get-IntersightVirtualizationVmwareDistributedNetwork -Filter "RegisteredDevice.Moid eq '$($registeredDeviceMoid)'" -InlineCount allpages).results | Select-Object Name,VlanId -Unique


Write-Host "VMware DVS Network List:" -ForegroundColor "Yellow"
foreach ($vmwareDvsNetName in $vmwareDvsNetList.Name) {
    Write-host $vmwareDvsNetName -ForegroundColor "Yellow"
}
# Write-Host "`r`n"
Write-Host "Do you want to choose a VMware DVS Network: y/n? If the DVS Network List is empty, select 'n'! " -ForegroundColor Yellow
$dvsNetDecision = Read-Host "Enter y or n?"
if ($dvsNetDecision -eq "y") {
    while ($True) {
        $vmwareDvsNetName = Read-Host -Prompt "Enter a VMware DVS Network name from the above list"
        if ($vmwareDvsNetName -in $vmwareDvsNetList.Name) {
            Write-Host "Vmware DVS Network Name looks good!" -ForegroundColor "Green"
            break
        } else {
            Write-Host "Re-Enter Vmware DVS Network Name" -ForegroundColor "Red"
        }
    }
}

# Get Local Networks
$vmwareLocalNetList = (Get-IntersightVirtualizationVmwareNetwork -Filter "RegisteredDevice.Moid eq '$($registeredDeviceMoid)'" -InlineCount allpages).results | Select-Object Name,VlanId -Unique

Write-Host "VMware Local Network List:" -ForegroundColor Yellow
foreach ($vmwareLocalNetName in $vmwareLocalNetList.Name) {
    Write-host $vmwareLocalNetName -ForegroundColor "Yellow"
}

Write-Host "Do you want to choose a VMware Local Network: y/n? If the Local Network List is empty, select 'n'! " -ForegroundColor Yellow
$localNetDecision = Read-Host "Enter y or n?"
if ($localNetDecision -eq "y") {
    while ($True) {
        $vmwareLocalNetName = Read-Host -Prompt "Enter a VMware Local Network name from the above list"
        if ($vmwareLocalNetName -in $vmwareLocalNetList.Name) {
            Write-Host "Vmware Local Network Name looks good!" -ForegroundColor "Green"
            break
        } else {
            Write-Host "Re-Enter Vmware Local Network Name" -ForegroundColor "Red"
        }
    }
}

if ($vmwareDvsNetName) {
    $interfaces = @($vmwareDvsNetName)
} elseif ($vmwareLocalNetName) {
    $interfaces = @($vmwareLocalNetName)
} else {
    $interfaces = @()
}

# Initialize Target Object
$target = Get-IntersightAssetDeviceRegistration -Moid $registeredDeviceMoid | Get-IntersightMoMoRef

# Create VM Config Objects
$vmConfigProps = @{
    Cluster=$clusterName
    Datastore=$datastoreName
    Interfaces=$interfaces
    Passphrase=$passphrase
    ClassId="KubernetesEsxiVirtualMachineInfraConfig"
    ObjectType="KubernetesEsxiVirtualMachineInfraConfig"
}

$vmConfigObject = Initialize-IntersightKubernetesEsxiVirtualMachineInfraConfig @vmConfigProps

# Create VM Infra Config Policy
$vmInfraProps = @{
    Name=$name
    Description=$description
    Organization=$myOrg
    Tags=$tags
    Target=$target
    VmConfig=$vmConfigObject
}

$result = New-IntersightKubernetesVirtualMachineInfraConfigPolicy @vmInfraProps

Write-Host "Created VM Infra Config policy '$($result.Name)' with Moid $($result.Moid)" -ForegroundColor "DarkMagenta"

# Add Moid to moids.json file
Invoke-UdfAddMoid -File $moidFileName -Name 'vm_infra_config_moid' -Value $result.Moid

# Write logs to results.log
$result | Out-File -FilePath ./results.log -Append -Encoding "ascii"