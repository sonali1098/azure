param pipName string
param location string = resourceGroup().location

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: pipName
  location: location
  sku: {
    name: 'Standard'
  }

  properties: {
    publicIPAllocationMethod: 'Static'

  }
}
output publicIpAddressID string = publicIPAddress.id
