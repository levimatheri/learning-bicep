@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string


@description('Required. API Version set properties.')
param apiVersionSetProperties object

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource apiVersionSet 'Microsoft.ApiManagement/service/apiVersionSets@2021-08-01' = {
  name: apiVersionSetProperties.name
  parent: service
  properties: {
    description: !empty(apiVersionSetProperties.description) ? apiVersionSetProperties.description : null
    displayName: apiVersionSetProperties.displayName
    versionHeaderName: !empty(apiVersionSetProperties.versionHeaderName) ? apiVersionSetProperties.versionHeaderName : null
    versioningScheme: !empty(apiVersionSetProperties.versioningScheme) ? apiVersionSetProperties.versioningScheme : null
    versionQueryName: !empty(apiVersionSetProperties.versionQueryName) ? apiVersionSetProperties.versionQueryName : null
  }
}
