@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

param apiVersionSetName string
param apiVersionSetDisplayName string
param apiVersioningScheme string
param apiVersionSetDescription string = ''
param apiVersionHeaderName string = ''
param apiVersionQueryName string = ''

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource apiVersionSet 'Microsoft.ApiManagement/service/apiVersionSets@2021-08-01' = {
  name: apiVersionSetName
  parent: service
  properties: {
    description: !empty(apiVersionSetDescription) ? apiVersionSetDescription : null
    displayName: apiVersionSetDisplayName
    versionHeaderName: !empty(apiVersionHeaderName) ? apiVersionHeaderName : null
    versioningScheme: apiVersioningScheme
    versionQueryName: !empty(apiVersionQueryName) ? apiVersionQueryName : null
  }
}
