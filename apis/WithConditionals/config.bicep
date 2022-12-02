param apiName string
param apimServiceName string
param apiRevision int
param apiDisplayName string
param apiPath string
param apiServiceUrl string
param apiTags array

param isNonProdEnv bool

module api '../../modules/api/api.module.bicep' = {
  name: '${apiName}-API'
  params: {
    apiManagementServiceName: apimServiceName
    name: apiName
    apiRevision: apiRevision
    path: apiPath
    displayName: apiDisplayName
    serviceUrl: apiServiceUrl
    tags: apiTags
    products: ['developers', 'petstore']
    value: isNonProdEnv ? loadTextContent('petstore.json') : '${apiServiceUrl}/v2/swagger.json'
    format: isNonProdEnv ? 'openapi+json' : 'swagger-link-json'
  }
}
