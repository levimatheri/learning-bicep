param apiName string
param apimServiceName string
param apiRevision int
param apiDisplayName string
param apiPath string
param apiServiceUrl string
param apiTags array

module api_version_set '../../modules/api/api-version-set.module.bicep' = {
  name: '${apiName}-API-VersionSet'
  params: {
    apiManagementServiceName: apimServiceName
    apiVersionSetName: '${apiName}-VersionSet'
    apiVersionSetDisplayName: apiDisplayName
    apiVersioningScheme: 'Path'
    apiVersionSetDescription: 'Version set for ${apiName} API'
  }
}

module apiv1 '../../modules/api/api.module.bicep' = {
  name: '${apiName}-API'
  params: {
    apiManagementServiceName: apimServiceName
    name: apiName
    apiVersion: ''
    apiVersionSetId: '${apiName}-VersionSet'
    apiRevision: apiRevision
    path: apiPath
    displayName: apiDisplayName
    serviceUrl: apiServiceUrl
    tags: apiTags
    products: ['developers', 'petstore']
    value: '${apiServiceUrl}/v1/swagger.json'
    format: 'swagger-link-json'
  }
}

module apiv2 '../../modules/api/api.module.bicep' = {
  name: '${apiName}-API'
  params: {
    apiManagementServiceName: apimServiceName
    name: '${apiName}-v2'
    apiVersion: 'v2'
    apiVersionSetId: '${apiName}-VersionSet'
    apiRevision: apiRevision
    path: apiPath
    displayName: '${apiDisplayName}.v2'
    serviceUrl: apiServiceUrl
    tags: apiTags
    products: ['developers', 'petstore']
    value: '${apiServiceUrl}/v2/swagger.json'
    format: 'swagger-link-json'
  }
}
