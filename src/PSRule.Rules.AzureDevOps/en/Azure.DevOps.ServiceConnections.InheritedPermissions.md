---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.InheritedPermissions.md
---

# Azure.DevOps.ServiceConnections.InheritedPermissions

## SYNOPSIS

Service connection permissions should not be inherited from the project.

## DESCRIPTION

Service connection permissions should not be inherited from the project.
Inherited permissions can lead to unexpected access to sensitive information
and resources.

Mininum TokenType: `FineGrained`

## RECOMMENDATION

Consider removing inherited permissions from the service connection and setting
permissions explicitly.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
