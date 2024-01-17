---
category: Microsoft Azure DevOps Projects
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Project.MainServiceConnectionAcl.ProjectValidUsers.md
---

# Azure.DevOps.Project.MainServiceConnectionAcl.ProjectValidUsers

## SYNOPSIS

Project level service connection acl should not have custom permissions for Project Valid
Users

## DESCRIPTION

Azure DevOps allows you to set custom permissions for Project Valid Users on the project
level service connection acl. This is not recommended as it can lead to unintended access
to service connections. It is recommended to use the default permissions for Project Valid
Users and use custom permissions for specific users or custom groups.


Mininum TokenType: `FineGrained`

## RECOMMENDATION

Remove the Project Valid Users group from the service connection acl.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
