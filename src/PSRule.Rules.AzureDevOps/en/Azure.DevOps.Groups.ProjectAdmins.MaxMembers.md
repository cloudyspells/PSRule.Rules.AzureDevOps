---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Groups.ProjectAdmins.MaxMembers.md
---

# Azure.DevOps.Groups.ProjectAdmins.MinMembers

## SYNOPSIS

The project administrators group should have at most 4 members.

## DESCRIPTION

The project administrators group should have at most 4 members. This ensures that there is not too many people who can manage the project. This rule applies to the default project administrators group.

Mininum TokenType: `ReadOnly`

This setting is configurable and can be changed to suit your organization's needs with `ProjectAdminsMaxMembers` in the `configuration` section of your ps-rule.yaml file.

## RECOMMENDATION

Consider removing members from the project administrators group.

## LINKS

- [Azure DevOps Security best practices - Tasks](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
