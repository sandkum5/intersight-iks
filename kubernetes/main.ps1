# Main Script to Create IKS Policies and Profile

Write-Host "Starting IKS Policy and Profile Creation using PowerShell"

Write-Host "Note: The script will prompt for details. Please check the output and enter the values accordingly."

Write-Host "Creating IP Pool Policy"
& "./01_ipPoolPolicy.ps1"

Write-Host "Creating Network CIDR Policy"
& "./02_networkCIDRPolicy.ps1"

Write-Host "Creating Node OS Configuration Policy"
& "./03_nodeOSConfigPolicy.ps1"

Write-Host "Creating Kubernetes Version Policy"
& "./04_kubeVersionPolicy.ps1"

Write-Host "Creating Add-ons Policy"
& "./05_addOnPolicy.ps1"

Write-Host "Creating VM Infra Config Policy"
& "./06_vmInfraConfigPolicy.ps1"

Write-Host "Creating VM Instance Policy"
& "./07_vmInstancePolicy.ps1"

Write-Host "Creating Container Runtime Policy"
& "./08_containerRuntimePolicy.ps1"

Write-Host "Creating Trusted CA Authorities Policy"
& "./09_trustedCAAuthorities.ps1"

Write-Host "Creating Kuberenetes Cluster Policy"
& "./10_k8sClusterProfile.ps1"

Write-Host "Creating Control Plane Node Group Profile"
& "./11_masterNodeGroupProfiles.ps1"

Write-Host "Creating Control Plane VM Infra Provider"
& "./12_vmInfraProvidersMaster.ps1"

Write-Host "Creating Worker Node Group Profile"
& "./13_workerNodeGroupProfiles.ps1"

Write-Host "Creating Workder VM Infra Provider"
& "./14_vmInfraProvidersWorker.ps1"

Write-Host "Creating Cluster Addon Profile"
& "./15_clusterAddonProfile.ps1"

Write-Host "Kubernetes Policies and Profiles Created Successfully!"

EXIT