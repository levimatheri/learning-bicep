@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent Product. Required if the template is used in a standalone deployment.')
param productName string

@description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName

  resource product 'products@2021-08-01' existing = {
    name: productName
  }
}

resource tag 'Microsoft.ApiManagement/service/products/apis@2021-08-01' = {
  name: apiName
  parent: service::product
}
