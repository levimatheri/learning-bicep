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
    products: ['developers', 'petstore']
    value: '${apiServiceUrl}/v2/swagger.json'
    format: 'swagger-link-json'
  }
}

module backend '../../modules/service/backend.module.bicep' = {
  name: '${apiName}-Backend'
  params: {
    apiManagementServiceName: apimServiceName
    name: backendId
    title: backendTitle
    backendDescription: 'Service Fabric backend for ${backendId}'
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
          issuerCertificateThumbprint: ''
        }
      ]
    }
  }
}
