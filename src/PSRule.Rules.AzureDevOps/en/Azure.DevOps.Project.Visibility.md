---
category: Microsoft Azure DevOps Projects
severity: Critical
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Project.Visibility.md
---

# Azure.DevOps.Project.Visibility

## SYNOPSIS

Projects should not be publicly accessible.

## DESCRIPTION

Projects can be configured to be publicly accessible. This means anyone with the URL can
view the project. Consider restricting access to projects to prevent unauthorized access.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider restricting access to projects to prevent unauthorized access.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
