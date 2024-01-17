---
category: Microsoft Azure DevOps Variable Groups
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.InheritedPermissions.md
---

# Azure.DevOps.Tasks.VariableGroup.InheritedPermissions

## SYNOPSIS

Variable group permissions should not be inherited from the project.

## DESCRIPTION

Variable group permissions should not be inherited from the project. Inherited
permissions can lead to unexpected access to sensitive information.

Mininum TokenType: `FineGrained`

## RECOMMENDATION

Consider removing inherited permissions from the variable group and setting
permissions explicitly.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
