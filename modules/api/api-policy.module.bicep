@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@description('Optional. The name of the policy.')
param name string = 'policy'

@description('Optional. Format of the policyContent.')
@allowed([
  'rawxml'
  'rawxml-link'
  'xml'
  'xml-link'
])
param format string = 'xml'

@description('Required. Contents of the Policy as defined by the format.')
param value string

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName

  resource api 'apis@2021-08-01' existing = {
    name: apiName
  }
}

resource policy 'Microsoft.ApiManagement/service/apis/policies@2021-08-01' = {
  name: name
  parent: service::api
  properties: {
    format: format
    value: value
  }
}
