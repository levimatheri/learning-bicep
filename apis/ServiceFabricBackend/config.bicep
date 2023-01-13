param apiName string
param apimServiceName string
param apiRevision int
param apiDisplayName string
param apiPath string
param apiServiceUrl string
param apiTags array

param backendId string
param backendTitle string
param backendUrl string
param clientCertificateId string
param managementEndpoint string
param serverCertificateName string

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
    products: ['AdminPortal', 'frontend-mhol', 'developers', 'digitalconcierge', 'mobile', 'providerportal', 'contactcenterdashboard', 'chatbot']
    value: '${apiServiceUrl}/docs/v1/swagger'
    format: 'swagger-link-json'
    policy: {
      format: 'rawxml'
      value: loadTextContent('policies/apiPolicy.xml')
      params: {
        backendId: backendId
        backendUrl: backendUrl
      }
    }
  }
  dependsOn: [
    backend
  ]
}

module backend '../../modules/api/backend.module.bicep' = {
  name: '${apiName}-Backend'
  params: {
    apiManagementServiceName: apimServiceName
    name: backendId
    title: backendTitle
    backendDescription: 'Service Fabric backend for ${backendUrl}'
    url: backendUrl
    protocol: 'http'
    serviceFabricCluster: {
      clientCertificateId: clientCertificateId
      maxPartitionResolutionRetries: 3
      managementEndpoints: [ managementEndpoint ]
      serverCertificateThumbprints: []
      serverX509Names: [
        {
          name: serverCertificateName
        }
      ]
    }
  }
}
