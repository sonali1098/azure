param location string

@description('specify the name of the virtual network')
param vnetName string

@description('specify address prefix for vnet')
param vnetAddressprefix string

@description('specify the name of the sub network')
param subNetName1 string

@description('specify the ID for sub Network 1')
param subnetid1 string

@description('specify the address prefix for the sub network')
param subnetAddressPrefix001 string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressprefix
      ]
    }
    subnets: [
      {
        name: subNetName1
        id: subnetid1
        properties: {
          addressPrefix: subnetAddressPrefix001

        }
      }
    ]
  }
}

output vNetID string = virtualNetwork.id
output subNetID string = virtualNetwork.properties.subnets[0].id
