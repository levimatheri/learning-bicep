@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Required. The properties product resource.')
param product object


resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource productResource 'Microsoft.ApiManagement/service/products@2021-08-01' = {
  name: product.name
  parent: service
  properties: {
    approvalRequired: product.approvalRequired
    description: product.description
    displayName: product.displayName
    state: product.state
    subscriptionRequired: product.subscriptionRequired
    subscriptionsLimit: product.subscriptionsLimit
    terms: !empty(product.terms) ? product.terms : null
  }
}
