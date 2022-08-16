<#
    Common Functions
    Udf - User Defined function
#>
Function Invoke-UdfAddMoid {
    param (
        $File,
        $Name,
        $Value
    )

    # Create file if Absent
    [string]$fileexist = Test-Path -Path "$pwd/$File"
    If ($fileexist -eq "False") {
        $jsonData = @{
            cluster_addon_moid = ""
            cluster_profile_moid = ""
            cp_node_group_moid = ""
            cp_vm_infra_provider_moid = ""
            ippool_moid = ""
            kube_version_moid = ""
            net_policy_moid = ""
            sys_config_moid = ""
            vm_infra_config_moid = ""
            vm_instance_moid = ""
            worker_node_group_moid = ""
            worker_vm_infra_provider_moid = ""
            addon_moid_list = @()
        }
        $jsonData | ConvertTo-Json | Out-File "$pwd/$File"
    }

    # Read File
    $moids = Get-Content -Path "$pwd/$File" | ConvertFrom-Json

    If ($Name -eq "addon_moid_list") {
        # Create a list and add Addon Moids
        $tempMoidList = [System.Collections.ArrayList]@()
        foreach ($moid in $moids.addon_moid_list) {
            $tempMoidList += $moid }
        $moidData = $tempMoidList + $Value
        Add-Member -InputObject $moids -MemberType "NoteProperty" -Name "addon_moid_list" -Value $moidData -Force
    }

    # Add Moid Data
    If ($Name -ne "addon_moid_list") {
        Add-Member -InputObject $moids -MemberType "NoteProperty" -Name $Name -Value $Value -Force
    }

    # Write-Host $moids
    # Write File
    $moids | ConvertTo-Json -Depth 4 | Out-File "$pwd/$File"
}

function Invoke-UdfDelMoid {
    param (
        $File,
        $Name,
        $Value
    )
    [string]$fileexist = Test-Path -Path "$pwd/$File"
    If ($fileexist) {
        # Read File
        $moids = Get-Content -Path "$pwd/$File" | ConvertFrom-Json

        # Remove Addon Moids
        Add-Member -InputObject $moids -MemberType "NoteProperty" -Name $Name -Value $Value -Force

        # Write File
        $moids | ConvertTo-Json -Depth 4 | Out-File "$pwd/$File"
    }
}