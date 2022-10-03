//..................................Vnet paramaters................................................

@description('azure region')
param location string

@description('vNet Name')
param vnetName string

@description('vnetAddress Prefix')
param vnetAddressprefix string

@description('subnet ID1')
param subnetid1 string

@description('subnetAddressprefix 1')
param subnetAddressPrefix001 string

@description('subnet name 2')
param subNetName1 string

//...............................................................Public Ip parameters........................................................

@description('specify the name of the public ip address')
param pipName string

//.................................................................VMSS Paramters..........................................................
@description('specify the vmssname')
param vmssName string

@description('specify the adminusername')
param adminUsername string

@description('specify the adminpassword')
@secure()
param adminPassword string

@description('specify the nice name')
param nicName string

@description('specify the ipConfigName')
param ipConfigName string

@description('specify the subnetname')
param subnetName string

@description('specify the addressprefix')
param addressPrefix string

//..........................................VNet Module.........................................................................

module virtualNetwork 'vnet.bicep' = {
  name: 'vnetPrivate'
  params: {
    location: location
    subNetName1: subNetName1
    subnetAddressPrefix001: subnetAddressPrefix001
    subnetid1: subnetid1
    vnetAddressprefix: vnetAddressprefix
    vnetName: vnetName
  }

}

//...................................................Public Ip Module.............................................................

module publiIPAddress 'publicIPAddress.bicep' = {
  name: 'publicipaddress'
  params: {
    pipName: pipName
    location: location
  }

}

//....................................................VMss Module....................................................................

module vmscaleset 'vmss.bicep' = {
  name: 'virtualscaleset'
  dependsOn: [
    virtualNetwork
    publiIPAddress
  ]
  params: {
    location: location
    addressPrefix: addressPrefix
    adminPassword: adminPassword
    adminUsername: adminUsername
    ipConfigName: ipConfigName
    nicName: nicName
    subnetName: subnetName
    vmssName: vmssName
    vnetName: vnetName
  }
}
