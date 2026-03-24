additionalTrustBundlePolicy: Proxyonly
apiVersion: v1
baseDomain: ${ocp_base_domain}
compute:
- architecture: amd64
  hyperthreading: Enabled
  name: worker
  platform: {}
  replicas: ${ocp_master_replicas}
controlPlane:
  architecture: amd64
  hyperthreading: Enabled
  name: master
  platform: {}
  replicas: ${ocp_worker_replicas}
metadata:
  name: ${ocp_cluster_name}
networking:
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  machineNetwork:
  - cidr: 10.0.0.0/16
  networkType: OVNKubernetes
  serviceNetwork:
  - 172.30.0.0/16
platform:
  azure:
    baseDomainResourceGroupName: ${ocp_base_domain_rg}
    cloudName: AzurePublicCloud
    outboundType: Loadbalancer
    region: ${ocp_location}
publish: External
pullSecret: '${ocp_pull_secret}'
sshKey: |
  ${ocp_ssh_public_key}