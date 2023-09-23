---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.WorkloadIdentityFederation.md
---

# Azure.DevOps.ServiceConnections.WorkloadIdentityFederation

## SYNOPSIS

A Service connection should use Workload Identity Federation.

## DESCRIPTION

Workload Identity Federation allows you to use a service principal
managed by Azure Active Directory to authenticate to Azure services
instead of using a service principal managed by Azure DevOps. This is
more secure as the service principal is not stored in Azure DevOps.

## RECOMMENDATION

Consider using Workload Identity Federation for your service connections.

## LINKS

- [Azure DevOps security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scope-service-accounts)
- [Create a service connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-using-workload-identity-federation)
