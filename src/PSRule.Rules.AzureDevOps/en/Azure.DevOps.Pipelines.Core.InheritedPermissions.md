---
category: Microsoft Azure DevOps Repos
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Core.InheritedPermissions.md
---

# Azure.DevOps.Pipelines.Core.InheritedPermissions

## SYNOPSIS

Pipeline permissions should not be inherited from the project.

## DESCRIPTION

Pipeline permissions should not be inherited from the project. Inherited
permissions can lead to unexpected access to resources.

Mininum TokenType: `FineGrained`

## RECOMMENDATION

Consider removing inherited permissions from the pipeline and setting
permissions explicitly.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
