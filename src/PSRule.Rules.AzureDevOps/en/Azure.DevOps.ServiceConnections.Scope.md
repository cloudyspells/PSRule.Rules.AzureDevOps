---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.Scope.md
---

# Azure.DevOps.ServiceConnections.Scope

## SYNOPSIS

A service connection scoped to production should use a narrow scope.
This will help ensure no unwanted changes or access is made to the
production resources or beyond

## DESCRIPTION

A service connection scoped to production should use a narrow scope. For
example, a service connection scoped to production should only have access
to the production resource groups. This will help ensure no unwanted changes
or access is made to the production resources or beyond. Normally it is not
desirable to have a service connection with access to all resource groups
in a subscription.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider using a resource group scope for a service connection scoped to
production.

## LINKS

- [Azure DevOps security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scope-service-accounts)
- [Create a service connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops&tabs=yaml)
