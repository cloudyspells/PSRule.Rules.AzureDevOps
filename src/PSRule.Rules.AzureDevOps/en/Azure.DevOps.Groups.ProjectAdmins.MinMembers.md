---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Groups.ProjectAdmins.MinMembers.md
---

# Azure.DevOps.Groups.ProjectAdmins.MinMembers

## SYNOPSIS

The project administrators group should have at least 2 members.

## DESCRIPTION

The project administrators group should have at least 2 members. This ensures that there is more than one person who can manage the project. This rule applies to the default project administrators group.


Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider adding more than one member to the project administrators group.

## LINKS

- [Azure DevOps Security best practices - Tasks](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
