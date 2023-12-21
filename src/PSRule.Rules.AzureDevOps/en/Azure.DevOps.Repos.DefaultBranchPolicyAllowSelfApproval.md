---
category: Microsoft Azure DevOps Repos
severity: Critical
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.DefaultBranchPolicyAllowSelfApproval.md
---

# Azure.DevOps.Repos.DefaultBranchPolicyAllowSelfApproval

## SYNOPSIS

Change authors should not be allowed to approve their own changes.

## DESCRIPTION

The branch policy on the default branch should not allow creators to approve
their own changes. This will help ensure that the code in the default branch
is of a high quality and that the team's Git workflow is followed.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider disabling the option to allow creators to approve their own changes.

## LINKS

- [Create a branch policy](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops)
- [Branch policies](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies-overview?view=azure-devops)
- [Azure DevOps Security best practices](https://docs.microsoft.com/en-us/azure/devops/user-guide/security-best-practices?view=azure-devops#repositories-and-branches)
