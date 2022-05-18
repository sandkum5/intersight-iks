# Main Script to Create IKS Policies and Profile

Write-Host "Starting IKS Policy and Profile Creation using PowerShell" -ForegroundColor Blue

Write-Host "Note: The script will prompt for details. Please check the output and enter the values accordingly." -ForegroundColor Red

Write-Host "Creating IP Pool Policy" -ForegroundColor Green
& "./01_ipPoolPolicy.ps1"

Write-Host "Creating Network CIDR Policy" -ForegroundColor Green
& "./02_networkCIDRPolicy.ps1"

Write-Host "Creating Node OS Configuration Policy" -ForegroundColor Green
& "./03_nodeOSConfigPolicy.ps1"

Write-Host "Creating Kubernetes Version Policy" -ForegroundColor Green
& "./04_kubeVersionPolicy.ps1"

Write-Host "Creating Add-ons Policy" -ForegroundColor Green
& "./05_addOnPolicy.ps1"

Write-Host "Creating VM Infra Config Policy" -ForegroundColor Green
& "./06_vmInfraConfigPolicy.ps1"

Write-Host "Creating VM Instance Policy" -ForegroundColor Green
& "./07_vmInstancePolicy.ps1"

Write-Host "Creating Container Runtime Policy" -ForegroundColor Green
& "./08_containerRuntimePolicy.ps1"

Write-Host "Creating Trusted CA Authorities Policy" -ForegroundColor Green
& "./09_trustedCAAuthorities.ps1"

Write-Host "Creating Kuberenetes Cluster Policy" -ForegroundColor Green
& "./10_k8sClusterProfile.ps1"

Write-Host "Creating Control Plane Node Group Profile" -ForegroundColor Green
& "./11_masterNodeGroupProfiles.ps1"

Write-Host "Creating Control Plane VM Infra Provider" -ForegroundColor Green
& "./12_vmInfraProvidersMaster.ps1"

Write-Host "Creating Worker Node Group Profile" -ForegroundColor Green
& "./13_workerNodeGroupProfiles.ps1"

Write-Host "Creating Workder VM Infra Provider" -ForegroundColor Green
& "./14_vmInfraProvidersWorker.ps1"

Write-Host "Creating Cluster Addon Profile" -ForegroundColor Green
& "./15_clusterAddonProfile.ps1"

Write-Host "Kubernetes Policies and Profiles Created Successfully!" -ForegroundColor Green

EXIT