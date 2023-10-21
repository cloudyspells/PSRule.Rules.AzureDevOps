---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ClassicAzure.md
---

# Azure.DevOps.ServiceConnections.ClassicAzure

## SYNOPSIS

A Service connection should not use the Classic Azure service connection type.

## DESCRIPTION

A service connection is a securely stored object that contains information about how to
connect to a service. Service connections are used during the build or release pipeline to
connect to external and remote resources. The Classic Azure service connection type can not
be scoped to a specific resource group or subscription. This means that any user with
access to the service connection can deploy to any resource group or subscription. Also
the Classic Azure service connection type does not support modern ways of authentication.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider using a service connection type that can be scoped to a specific resource group
with modern authentication.

## LINKS

- [Azure DevOps security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scope-service-accounts)
- [Create a service connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-using-workload-identity-federation)
