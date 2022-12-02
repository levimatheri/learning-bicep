@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Required. Gateway Name.')
param name string

param gatewayDescription string = ''
param locationData object = {}

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource symbolicname 'Microsoft.ApiManagement/service/gateways@2021-08-01' = {
  name: name
  parent: service
  properties: {
    description: !empty(gatewayDescription) ? gatewayDescription : null
    locationData: locationData
  }
}
