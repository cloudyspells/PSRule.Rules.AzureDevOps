---
category: Microsoft Azure DevOps Projects
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/Azure.DevOps.Project.MainVariableGroupAcl.ProjectValidUsers.md
---

# Azure.DevOps.Project.MainVariableGroupAcl.ProjectValidUsers

## SYNOPSIS

Project level variable group acl should not have custom permissions for Project Valid
Users

## DESCRIPTION

Project level variable group acl should not have custom permissions for Project Valid
Users. The Project Valid Users group is a special group that is automatically
created when a project is created. It contains all users and groups that have
been added to the project. This group should not be used to grant permissions to
the variable groups.

Mininum TokenType: `FineGrained`

## RECOMMENDATION

Remove the Project Valid Users group from the variable group acl.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
