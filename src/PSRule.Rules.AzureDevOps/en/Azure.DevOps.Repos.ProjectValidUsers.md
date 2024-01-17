---
category: Microsoft Azure DevOps Repos
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.ProjectValidUsers.md
---

# Azure.DevOps.Repos.ProjectValidUsers

## SYNOPSIS

Repositories should not be assigned directly to the Project Valid Users
group.

## DESCRIPTION

Repositories should not be assigned directly to the Project Valid Users
group. This group is inherited by all users in the project and will grant
access to the repository to all users.

Mininum TokenType: `FineGrained`

## RECOMMENDATION

Remove the Project Valid Users group from the repository acl.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
