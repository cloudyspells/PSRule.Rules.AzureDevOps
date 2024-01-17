---
category: Microsoft Azure DevOps Variable Groups
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.ProjectValidUsers.md
---

# Azure.DevOps.Tasks.VariableGroup.ProjectValidUsers

## SYNOPSIS

Variable groups should not be assigned directly to the Project Valid Users
group.

## DESCRIPTION

Variable groups should not be assigned directly to the Project Valid Users
group. This group is inherited by all users in the project and will grant
access to all variables in the group.

Mininum TokenType: `FineGrained`

## RECOMMENDATION

Remove the Project Valid Users group from the variable group acl.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
