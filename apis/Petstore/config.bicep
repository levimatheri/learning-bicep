param apiName string
param apimServiceName string
param apiRevision int
param apiDisplayName string
param apiPath string
param apiServiceUrl string
param apiTags array

// policy file  parameters
param statusCode string
param statusReason string

// environment parameters
@allowed([
  'nonprod','prod'
])
param environmentConfig string

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
    policy: {
      format: 'rawxml'
      value: loadTextContent('policies/apiPolicy.xml')
      params: {
        statusCode: statusCode
        statusReason: statusReason
      }
    }
    operationPolicies: [
      {
        operationName: 'updatePetWithForm'
        value: loadTextContent('policies/operationPolicy.xml')
      }
    ]
  }
}
