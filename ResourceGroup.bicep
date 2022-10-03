targetScope = 'subscription'
param location string = 'centralindia'
resource azbicepresourcegroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-dev-006'
  location: location
}

output name string = azbicepresourcegroup.name
