---
category: Microsoft Azure DevOps Repos
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/AzureDevOps.Repos.BranchPolicyMinimumReviewers.md
---

# AzureDevOps.Repos.BranchPolicyMinimumReviewers

## SYNOPSIS

The repository's default branch should have a branch policy with a minimum
number of reviewers.

## DESCRIPTION

Having a minimum number of reviewers for a branch policy helps ensure that the
code in the default branch is of a high quality and that the team's Git
workflow is followed. 

You can configure the minimum number of reviewers for this rule by setting the
`branchMinimumApproverCount` configuration value in PSRule. The default
value is `1`.


## RECOMMENDATION

Make sure that the branch policy has a minimum number of reviewers for the
default branch of your repository. This will help ensure that the code in the
default branch is of a high quality and that the team's Git workflow is
followed.

## LINKS

- [Create a branch policy](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops)
- [Branch policies](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies-overview?view=azure-devops)
- [Minimum number of reviewers](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies-overview?view=azure-devops#minimum-number-of-reviewers)
- [Azure DevOps Security best practices](https://docs.microsoft.com/en-us/azure/devops/user-guide/security-best-practices?view=azure-devops#repositories-and-branches)
