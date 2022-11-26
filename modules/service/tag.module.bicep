@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Required. The name of the tag resource.')
param tagName string

@description('Required. The display name of the tag resource.')
param tagDisplayName string

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource tag 'Microsoft.ApiManagement/service/tags@2021-08-01' = {
  name: tagName
  parent: service
  properties: {
    displayName: tagDisplayName
  }
}
