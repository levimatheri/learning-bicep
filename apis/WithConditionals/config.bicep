param apiName string
param apimServiceName string
param apiRevision int
param apiDisplayName string
param apiPath string
param apiServiceUrl string
param apiTags array

param isNonProdEnv bool
param isStagingEnv bool
param isProdEnv bool

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
    value: isNonProdEnv ? loadTextContent('petstore.nonprod.json') : isStagingEnv ? loadTextContent('petstore.staging.json') : isProdEnv ? loadTextContent('petstore.prod.json') : ''
    format: 'openapi+json'
  }
}
