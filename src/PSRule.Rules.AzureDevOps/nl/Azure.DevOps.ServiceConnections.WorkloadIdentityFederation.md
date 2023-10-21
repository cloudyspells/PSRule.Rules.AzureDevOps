---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.ServiceConnections.WorkloadIdentityFederation.md
---

# Azure.DevOps.ServiceConnections.WorkloadIdentityFederation

## SYNOPSIS

Een Service connection moet Workload Identity Federation gebruiken.

## DESCRIPTION

Workload Identity Federation maakt het mogelijk om een service principal
beheerd door Azure Active Directory te gebruiken om te authenticeren
naar Azure services in plaats van een service principal beheerd door
Azure DevOps. Dit is veiliger omdat de service principal niet wordt
opgeslagen in Azure DevOps.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om Workload Identity Federation te gebruiken voor je service connections.

## LINKS

- [Azure DevOps security best practices](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#scope-service-accounts)
- [Create a service connection](https://learn.microsoft.com/nl-nl/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-using-workload-identity-federation)
