---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Groups.ProjectValidUsers.DoNotAssignMemberOfOtherGroups.md
---

# Azure.DevOps.Groups.ProjectValidUsers.DoNotAssignMemberOfOtherGroups

## SYNOPSIS

The project valid users group should not be a member of any other group.

## DESCRIPTION

The project valid users group is the minimum permissions level group for a
project. This group should not be a member of any other group. This rule applies
to the default project valid users group.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider removing the project valid users group from any other groups.

## LINKS

- [Azure DevOps Security best practices - Tasks](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
