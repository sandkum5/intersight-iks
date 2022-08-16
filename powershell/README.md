### Create Intersight Kubernetes Policies and Profile using PowerShell

#### Code Files
`01_ipPoolPolicy.ps1`            - Creates IP Pool Policy

`02_networkCIDRPolicy.ps1`       - Creates Kubernetes Network Policy

`03_nodeOSConfigPolicy.ps1`      - Creates Kubernetes SysConfig Policy

`04_kubeVersionPolicy.ps1`       - Creates Kubernetes Version Policy

`05_addOnPolicy.ps1`             - Creates Kubernetes Addon Policy

`06_vmInfraConfigPolicy.ps1`     - Creates Kubernetes Virtual Machine Infra Config Policy

`07_vmInstancePolicy.ps1`        - Creates Kubernetes Virtual Machine Instance Policy

`10_k8sClusterProfile.ps1`       - Creates Kubernetes Cluster Profile

`11_masterNodeGroupProfiles.ps1` - Creates Kubernetes Control Plane Node Group Profile

`12_vmInfraProvidersMaster.ps1`  - Creates Kubernetes Control Plane Virtual Machine Infrastructure Provider

`13_workerNodeGroupProfiles.ps1` - Creates Kubernetes Worker Node Group Profile

`14_vmInfraProvidersWorker.ps1`  - Creates Kubernetes Worker Virtual Machine Infrastructure Provider

`15_clusterAddonProfile.ps1`     - Creates Kubernetes Cluster Addon Profile

`create.ps1`    - Script to Create Intersight Kubernetes Cluster Profile and Policies

`deploy.ps1`    - Script to Deploy Intersight Kubernetes Cluster Profile and Policies

`expand.ps1`    - Script to Expand Intersight Kubernetes Cluster Profile and Policies

`undeploy.ps1`  - Script to Expand Intersight Kubernetes Cluster Profile and Policies

`destroy.ps1`   - Script to Destroy Intersight Kubernetes Cluster Profile and Policies

`functions.ps1` - Functions to Add and Delete Moids from moids.json file

#### Files
`SecretKey.txt` - Intersight SecretKey

`apiKey.txt`    - Intersight API Key

`variables.ps1` - Variable file to create cluster

`updates.ps1`   - Variable file to expand cluster

`moids.json`    - Created when IP Pool policy is created. Holds all the MOID's of the created policies and profiles

`result.log`    - Created to log the Intersight Responses


- Intersight Objects will be created as per file names starting from 01-07, 10-15.
- During the execution, the script will prompt for inputs like Kubernetes Version, Addon Names, Vmware Cluster/Datastore/Network.
- To individually create the policies and profiles, run: ./<xx_name.ps1>.

`Note:` Some Intersight objects are dependent on others. Hence, the sequence from 01 to 15.


#### Sample Output

```
> ./create.ps1
Starting IKS Policy and Profile Creation using PowerShell
Note: The script will prompt for details. Please check the output and enter the values accordingly.
Creating IP Pool Policy
Created IP Pool policy 'pwsh_demo' with Moid xxxxxxxxxxxxxxxxxxx
Creating Network CIDR Policy
Created Network policy 'pwsh_demo' with Moid xxxxxxxxxxxxxxxxxxx
Creating Node OS Configuration Policy
Created Node OS Config policy 'pwsh_demo' with Moid xxxxxxxxxxxxxxxxxxx
Creating Kubernetes Version Policy
Enter a Kubernetes Version from the following list:
1.21.13-iks.0
1.20.14-iks.5
Enter Kubernetes Version from the above list: 1.21.13
Re-Enter Kubernetes Version
Enter Kubernetes Version from the above list: 1.21.13-iks.0
Kubernetes Version looks good!
Created Kubernetes Version policy 'pwsh_demo' with Moid xxxxxxxxxxxxxxxxxxx
Creating Add-ons Policy
Do you want to create an Addon Policy y/n: y
Add-on list:
kubernetes-dashboard
smm
ccp-monitor
Enter an Add-on Name from the above  list: kubernetes
Re-Enter Addon Name
Enter an Add-on Name from the above  list: kubernetes-dashboard
Addon Name looks good!
Created Add-on policy 'kubernetes-dashboard' with Moid xxxxxxxxxxxxxxxxxxx
Do you want to create an Addon Policy y/n: n
Creating VM Infra Config Policy
VMware Cluster List:
cx-hx3
cx-hxe2
cx-hxe1
cx-so-cluster
cx-iks-cluster
cx-iwo-cluster
cx-hci-cluster
vLCM
IST-Cluster
cx-ist-cluster
Cluster
Enter a VMware Cluster name from the above  list: cx-iks
Re-Enter Vmware Cluster Name
Enter a VMware Cluster name from the above  list: cx-iks-cluster
Vmware Cluster Name looks good!
VMware Datastore List:
cx-ucs-8-ssd
cx-ucs-7-ssd
cx-ucs-8-ds
cx-ucs-7-ds
Enter a VMware Datastore name from the above list: cx-ucs
Re-Enter Vmware Datastore Name
Enter a VMware Datastore name from the above list: cx-ucs-8-ds
Vmware Datastore Name looks good!
VMware DVS Network List:
Do you want to choose a VMware DVS Network: y/n? If the DVS Network List is empty, select 'n'!
Enter y or n?: n
VMware Local Network List:
Storage Controller Management Network
vMotion
Storage Controller ISCSI Primary
Storage Hypervisor Data Network
Storage Controller Data Network
Storage Controller ISCSI Secondary
Management Network
Storage Controller Replication Network
VMkernel
Storage Controller Data Network
VLAN-1094
Storage Controller Replication Network
vmotion-3001
Storage Hypervisor Data Network
hx2-storage
vmk1
hx1-storage
Management Network
VM Network
vlan-1096
VLAN 1096
VLAN 1094
Do you want to choose a VMware Local Network: y/n? If the Local Network List is empty, select 'n'!
Enter y or n?: y
Enter a VMware Local Network name from the above list: VLAN 1096
Vmware Local Network Name looks good!
Created VM Infra Config policy 'pwsh_demo' with Moid xxxxxxxxxxxxxxxxxxx
Creating VM Instance Policy
Created VM Instance policy 'pwsh_demo' with Moid xxxxxxxxxxxxxxxxxxx
Creating Kuberenetes Cluster Policy
Created Kubernetes Cluster policy 'pwsh_demo' with Moid xxxxxxxxxxxxxxxxxxx
Creating Control Plane Node Group Profile
Created Control Node Group profile 'cpNGProfile' with Moid xxxxxxxxxxxxxxxxxxx
Creating Control Plane VM Infra Provider
Created Control Plane VM Infra Provider policy 'cpVMInfraProvider' with Moid xxxxxxxxxxxxxxxxxxx
Creating Worker Node Group Profile
Created Worker Node Group Profile 'wNGProfile' with Moid xxxxxxxxxxxxxxxxxxx
Creating Workder VM Infra Provider
Created Worker VM Infra Provider policy 'wVMInfraProvider' with Moid xxxxxxxxxxxxxxxxxxx
Creating Cluster Addon Profile
Created Cluster Addon policy 'pwsh_demo' with Moid xxxxxxxxxxxxxxxxxxx
Kubernetes Policies and Profiles Created Successfully!
```

```
> ./expand.ps1
Updating  Management Config
Updating Control Plane Node Group Profile
Updating Worker Node Group Profile
Do you want to create Add-on Policy y/n: y
Add-on list:
kubernetes-dashboard
smm
ccp-monitor
Enter an Add-on from the above  list: smm
Addon looks good!
Enter an Add-on Name: pwsh_smm
Created Add-on policy 'pwsh_smm' with Moid xxxxxxxxxxxxxxxxxxx
Updating Cluster Addon Profile
Updated Cluster Addon Policy
Do you want to create Add-on Policy y/n: n
```

```
> ./destroy.ps1
Deleting Cluster Profile: pwsh_demo
Waiting for Cluster Profile delete operation to complete!
Waiting for Cluster Profile delete operation to complete!
Waiting for Cluster Profile delete operation to complete!
Kuberenetes Cluster Profile: pwsh_demo deleted!
Deleting SysConfig Policy: pwsh_demo
Deleting Network Policy: pwsh_demo
Deleting Kubernetes Version Policy: pwsh_demo
Deleting VirtualMachineInstanceType Policy: pwsh_demo
Deleting VirtualMachineInfraConfig Policy: pwsh_demo
Deleting Addon Policies
```