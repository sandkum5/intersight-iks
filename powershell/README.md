### Create Intersight Kubernetes Policies and Profile using PowerShell

- Intersight Objects will be created as per file names starting from 01 to 15.
- To create all the policies and profile with one command, run: `./create.ps1` from powershell prompt.
- To individually create the policies and profiles, run: ./<xx_name.ps1>. 
- `Note:` The Intersight objects are dependent on each other. Hence, the sequence from 01 to 15. 
- To destroy the created policies and profile, run: `./destroy.ps1`

`Sample Output:`

```
> ./create.ps1
Starting IKS Policy and Profile Creation using PowerShell
Note: The script will prompt for details. Please check the output and enter the values accordingly.
Creating IP Pool Policy
Created IP Pool policy 'pwsh_atx_demo1' with Moid xxxxx
Creating Network CIDR Policy
Created Network policy 'pwsh_atx_demo1' with Moid xxxxx
Creating Node OS Configuration Policy
Created Node OS Config policy 'pwsh_atx_demo1' with Moid xxxxx
Creating Kubernetes Version Policy
Enter a Kubernetes Version from the following list:
1.20.14-iks.4
1.21.11-iks.2
Enter Kubernetes Version from the above list: 1.21.11-iks.2
Kubernetes Version looks good!
Created Kubernetes Version policy 'pwsh_atx_demo1' with Moid xxxxx
Creating Add-ons Policy
Add-on list:
kubernetes-dashboard
smm
ccp-monitor
Enter an Add-on Name from the above  list: smm
Addon Name looks good!
Created Add-on policy 'pwsh_atx_demo1' with Moid xxxxx
Creating VM Infra Config Policy
VMware Cluster List:
cx-hx3
cx-ucs
demo-iwo-apps
cx-iks-cluster
Enter a VMware Cluster name from the above  list: cx-ucs
Vmware Cluster Name looks good!
VMware Datastore List:
cx-ucs-6-ds
cx-ucs-4-ssd
cx-ucs-9-ssd
cx-ucs-3-ssd
cx-ucs-2-ssd
cx-ucs-1-ds
Enter a VMware Datastore name from the above list: cx-ucs-1-ds
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
VM Network
vlan-1096
VLAN 1096
VLAN 1094
Do you want to choose a VMware Local Network: y/n? If the Local Network List is empty, select 'n'! 
Enter y or n?: y
Enter a VMware Local Network name from the above list: VLAN 1094
Vmware Local Network Name looks good!
Created VM Infra Config policy 'pwsh_atx_demo1' with Moid xxxxx
Creating VM Instance Policy
Created VM Instance policy 'pwsh_atx_demo1' with Moid xxxxx
Creating Container Runtime Policy
Creating Trusted CA Authorities Policy
Creating Kuberenetes Cluster Policy
Created Kubernetes Cluster policy 'pwsh_atx_demo1' with Moid xxxxx
Creating Control Plane Node Group Profile
Created Control Node Group profile 'pwsh_atx_demo1' with Moid xxxxx
Creating Control Plane VM Infra Provider
Created Control Plane VM Infra Provider policy 'pwsh_atx_demo1' with Moid xxxxx
Creating Worker Node Group Profile
Created Worker Node Group Profile 'pwsh_atx_demo1' with Moid xxxxx
Creating Workder VM Infra Provider
Created Worker VM Infra Providers policy 'pwsh_atx_demo1' with Moid xxxxx
Creating Cluster Addon Profile
Created Cluster Add-on policy 'pwsh_atx_demo1' with Moid xxxxx
Kubernetes Policies and Profiles Created Successfully!
```

```
> ./destroy.ps1
Deleting Cluster Profile: pwsh_atx_demo1
Waiting for Cluster Profile delete operation to complete!
Waiting for Cluster Profile delete operation to complete!
Waiting for Cluster Profile delete operation to complete!
Kuberenetes Cluster Profile: pwsh_atx_demo1 deleted!
Deleting SysConfigPolicy: pwsh_atx_demo1
Deleting NetworkPolicy: pwsh_atx_demo1
Deleting VersionPolicy: pwsh_atx_demo1
Deleting VirtualMachineInstanceType Policy: pwsh_atx_demo1
Deleting VirtualMachineInfraConfigPolicy: pwsh_atx_demo1
Deleting AddonPolicy: pwsh_atx_demo1
```