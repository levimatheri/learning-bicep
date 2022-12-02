@description('Required. API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.')
param name string

@description('Optional. Policy to apply to the Service API.')
param policy object = {}

@description('Optional. Array of Operation policies to apply to the Service API.')
param operationPolicies array = []

@description('Optional. Array of Tags to apply to the Service API.')
param tags array = []

@description('Optional. Array of Products to assign to the Service API. Each item should only specify the product\'s \'name\' property')
param products array = []

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Optional. Describes the Revision of the API. If no value is provided, default revision 1 is created.')
param apiRevision int = 1

@description('Optional. Description of the API Revision.')
param apiRevisionDescription string = ''

@description('Optional. Type of API to create. * http creates a SOAP to REST API * soap creates a SOAP pass-through API.')
@allowed([
  'http'
  'soap'
])
param apiType string = 'http'

@description('Optional. Indicates the Version identifier of the API if the API is versioned.')
param apiVersion string = ''

@description('Optional. Indicates the Version identifier of the API version set.')
param apiVersionSetId string = ''

@description('Optional. Description of the API Version.')
param apiVersionDescription string = ''

@description('Optional. Collection of authentication settings included into this API.')
param authenticationSettings object = {}

@description('Optional. Description of the API. May include HTML formatting tags.')
param apiDescription string = ''

@description('Required. API name. Must be 1 to 300 characters long.')
@maxLength(300)
param displayName string

@description('Optional. Format of the Content in which the API is getting imported.')
@allowed([
  'wadl-xml'
  'wadl-link-json'
  'swagger-json'
  'swagger-link-json'
  'wsdl'
  'wsdl-link'
  'openapi'
  'openapi+json'
  'openapi-link'
  'openapi+json-link'
])
param format string = 'openapi'

@description('Optional. Indicates if API revision is current API revision.')
param isCurrent bool = true

@description('Required. Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.')
param path string

@description('Optional. Describes on which protocols the operations in this API can be invoked. - HTTP or HTTPS.')
param protocols array = [
  'https'
]

@description('Optional. Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.')
@maxLength(2000)
param serviceUrl string = ''

@description('Optional. API identifier of the source API.')
param sourceApiId string = ''

@description('Optional. Protocols over which API is made available.')
param subscriptionKeyParameterNames object = {}

@description('Optional. Specifies whether an API or Product subscription is required for accessing the API.')
param subscriptionRequired bool = false

@description('Optional. Type of API.')
@allowed([
  'http'
  'soap'
])
param type string = 'http'

@description('Optional. Content value when Importing an API.')
param value string = ''

@description('Optional. Criteria to limit import of WSDL to a subset of the document.')
param wsdlSelector object = {}


resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

// API
resource api 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: apiRevision > 1 ? '${name};rev=${apiRevision}' : name
  parent: service
  properties: {
    apiRevision: string(apiRevision)
    apiRevisionDescription: !empty(apiRevisionDescription) ? apiRevisionDescription : null
    apiType: !empty(apiType) ? apiType : null
    apiVersion: !empty(apiVersion) ? apiVersion : null
    apiVersionDescription: !empty(apiVersionDescription) ? apiVersionDescription : null
    apiVersionSetId: !empty(apiVersionSetId) ? apiVersionSetId : null
    authenticationSettings: authenticationSettings
    description: apiDescription
    displayName: displayName
    format: !empty(value) ? format : null
    isCurrent: isCurrent
    path: path
    protocols: protocols
    serviceUrl: !empty(serviceUrl) ? serviceUrl : null
    sourceApiId: !empty(sourceApiId) ? sourceApiId : null
    subscriptionKeyParameterNames: !empty(subscriptionKeyParameterNames) ? subscriptionKeyParameterNames : null
    subscriptionRequired: subscriptionRequired
    type: type
    value: !empty(value) ? value : null
    wsdlSelector: wsdlSelector
  }
}

// API policy
resource api_policy 'Microsoft.ApiManagement/service/apis/policies@2021-08-01' = {
  name: 'policy'
  parent: api
  properties: {
    format: contains(policy, 'format') ? policy.format : 'rawxml'
    value: !contains(policy, 'params') ? policy.value : reduce(items(policy.params), policy.value, (result, param) => replace(string(result), '\$(${param.key})', param.value))
  }
}

resource operationPolicyResources 'Microsoft.ApiManagement/service/apis/operations@2021-08-01' existing = [for i in range(0, length(operationPolicies)): {
  name: operationPolicies[i].operationName
  parent: api
}]

resource api_operation_policies 'Microsoft.ApiManagement/service/apis/operations/policies@2021-08-01' = [for i in range(0, length(operationPolicies)): {
  name: 'policy'
  parent: operationPolicyResources[i]
  properties: {
    format: contains(operationPolicies[i], 'format') ? operationPolicies[i].format : 'rawxml'
    value: !contains(operationPolicies[i], 'params') ? operationPolicies[i].value : reduce(items(operationPolicies[i].params), operationPolicies[i].value, (result, param) => replace(string(result), '\$(${param.key})', param.value))
  }
}]

// API tags
resource api_tags 'Microsoft.ApiManagement/service/apis/tags@2021-08-01' = [for tag in tags: {
  parent: api
  name: tag
}]

resource tagResources 'Microsoft.ApiManagement/service/tags@2021-08-01' = [for tag in tags: {
  name: tag
  parent: service
  properties: {
    displayName: tag
  }
}]

resource productResourceNames 'Microsoft.ApiManagement/service/products@2021-08-01' existing = [for i in range(0, length(products)): {
  parent: service
  name: products[i]
}]

// API products
resource api_product 'Microsoft.ApiManagement/service/products/apis@2021-08-01' = [for i in range(0, length(products)): {
  name: api.name
  parent: productResourceNames[i]
}]
