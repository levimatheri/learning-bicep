param apiName string
param apimServiceName string
param apiRevision int
param apiDisplayName string
param apiPath string
param apiServiceUrl string
param apiTags array

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
    type: 'graphql'
    products: ['developers', 'starwars']
    value: 'https://swapi-graphql.azure-api.net/graphql'
    format: 'graphql-link'
  }
}
