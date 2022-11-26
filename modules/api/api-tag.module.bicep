@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@description('Required. The name of the tag resource.')
param tagName string

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName

  resource api 'apis@2021-08-01' existing = {
    name: apiName
  }
}

resource tag 'Microsoft.ApiManagement/service/apis/tags@2021-08-01' = {
  name: tagName
  parent: service::api
}
