---
category: Microsoft Azure DevOps Environments
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.InheritedPermissions.md
---

# Azure.DevOps.Pipelines.Environments.InheritedPermissions

## SYNOPSIS

Environment permissions should not be inherited from the project.

## DESCRIPTION

Environment permissions should not be inherited from the project.
Inherited permissions can lead to unexpected access to sensitive information
and resources.

Mininum TokenType: `FineGrained`

## RECOMMENDATION

Consider removing inherited permissions from the environment and setting
permissions explicitly.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
