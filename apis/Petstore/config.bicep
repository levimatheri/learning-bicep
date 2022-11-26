param apiName string
param apimServiceName string
param apiRevision int
param apiDisplayName string
param apiPath string
param apiServiceUrl string
param apiTags array
param backendId string
param backendUrl string

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
    value: '${apiServiceUrl}/v2/swagger.json'
    format: 'swagger-link-json'
    policies: [{
      format: 'rawxml'
      value: loadTextContent('policies/apiPolicy.xml')
      params: {
        backendId: backendId
        backendUrl: backendUrl
      }
    }]
  }
}

module tags '../../modules/service/tag.module.bicep' = [for tag in apiTags : {
  name: '${tag}-Tag'
  params: {
    apiManagementServiceName: apimServiceName
    tagName: tag
    tagDisplayName: tag
  }
}]
