param location string = resourceGroup().location
param lbName string = 'lbName'
param pipName string = 'lbpip'
param lbFrontEndConfigure string = 'lbFrontEndConfigureID'
param lbpool string = 'lbpoolID'
param lbProbe string = 'lbProbeID'

var natStartPort = 50000
var natEndPort = 50119
var natBackendPort = 3389

module publicIPAddress 'publicIPAddress.bicep' = {
  name: 'publicIpModule'
  params: {
    location: location
    pipName: pipName
  }
}

resource loadbalancer 'Microsoft.Network/loadBalancers@2022-01-01' = {
  name: lbName
  location: location
  sku: {
    name: 'Basic'
  }

  properties: {
    frontendIPConfigurations: [
      {
        name: 'LoadBalancerFrontend'
        properties: {
          publicIPAddress: {
            id: publicIPAddress.outputs.publicIpAddressID
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'BackEndAddressPool'
      }
    ]
    inboundNatPools: [
      {
        name: 'inboundNatPoolsName'
        properties: {
          frontendIPConfiguration: {
            id: lbFrontEndConfigure
          }
          protocol: 'Tcp'
          frontendPortRangeStart: natStartPort
          frontendPortRangeEnd: natEndPort
          backendPort: natBackendPort
        }
      }

    ]
    loadBalancingRules: [
      {
        name: 'LoadBalancerRuleName'
        properties: {
          frontendIPConfiguration: {
            id: lbFrontEndConfigure
          }
          backendAddressPool: {
            id: lbpool
          }
          protocol: 'Tcp'
          backendPort: 80
          frontendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 5
          probe: {
            id: lbProbe
          }
        }
      }
    ]
    probes: [
      {
        name: 'loadBalancerProbeName'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]

  }
}
