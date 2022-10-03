targetScope = 'resourceGroup'
param location string

resource storagecc 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'stbicepdev'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    accessTier: 'Hot'

  }
}
