---
category: Microsoft Azure DevOps Repos
severity: Critical
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en-US/AzureDevOps.Repos.BranchPolicyAllowSelfApproval.md
---

# AzureDevOps.Repos.BranchPolicyAllowSelfApproval

## SYNOPSIS

Change authors should not be allowed to approve their own changes.

## DESCRIPTION

The branch policy should not allow creators to approve their own changes.
This will help ensure that the code in the default branch is of a high quality
and that the team's Git workflow is followed.

## RECOMMENDATION

Consider disabling the option to allow creators to approve their own changes.

## LINKS

- [Create a branch policy](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops)
- [Branch policies](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies-overview?view=azure-devops)
- [Azure DevOps Security best practices](https://docs.microsoft.com/en-us/azure/devops/user-guide/security-best-practices?view=azure-devops#repositories-and-branches)
