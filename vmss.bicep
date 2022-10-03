@description('Specifie the name of the VMSS')
param vmssName string

@description('Specifie the Location')
param location string = resourceGroup().location

@description('Give the username')
param adminUsername string

@description('Give the password')
@secure()
param adminPassword string

@description('Specifie the name of the network Interface')
param nicName string

@description('Give the Ip config name Eg: IpConfig')
param ipConfigName string

@description('Give the name of the Virtual Network')
param vnetName string

@description('Specifie the Name of the subnet for vmss')
param subnetName string

@description('Give the Address Prefix for vmss subnet')
param addressPrefix string

var imageReference = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2019-Datacenter'
  version: 'latest'
}

resource vmssSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  name: '${vnetName}/${subnetName}'
  properties: {
    addressPrefix: addressPrefix
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
  }
}

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2022-03-01' = {
  name: vmssName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    capacity: 1
    name: 'Standard_D2s_v3'
    tier: 'Standard'
  }
  properties: {
    overprovision: false
    upgradePolicy: {
      automaticOSUpgradePolicy: {
        enableAutomaticOSUpgrade: false
      }
      mode: 'Manual'
    }
    virtualMachineProfile: {
      storageProfile: {
        osDisk: {
          caching: 'ReadWrite'
          createOption: 'FromImage'
        }
        imageReference: imageReference
      }
      osProfile: {
        computerNamePrefix: 'agent'
        adminUsername: adminUsername
        adminPassword: adminPassword

      }
      diagnosticsProfile: {
        bootDiagnostics: {
          enabled: true
        }
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: nicName
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: ipConfigName
                  properties: {
                    subnet: {
                      id: vmssSubnet.id
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}
