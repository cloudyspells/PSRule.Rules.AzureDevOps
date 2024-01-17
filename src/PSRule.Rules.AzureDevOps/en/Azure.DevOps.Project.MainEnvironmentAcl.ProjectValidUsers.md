---
category: Microsoft Azure DevOps Projects
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Project.MainEnvironmentAcl.ProjectValidUsers.md
---

# Azure.DevOps.Project.MainEnvironmentAcl.ProjectValidUsers

## SYNOPSIS

Project level environment acl should not have custom permissions for Project Valid
Users

## DESCRIPTION

Project level environment acl should not have custom permissions for Project Valid
Users. The Project Valid Users group is a special group that is automatically
created when a project is created. It contains all users and groups that have
been added to the project. This group should not be used to grant permissions to
the environments.

Mininum TokenType: `FineGrained`

## RECOMMENDATION

Remove the Project Valid Users group from the environment acl.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
