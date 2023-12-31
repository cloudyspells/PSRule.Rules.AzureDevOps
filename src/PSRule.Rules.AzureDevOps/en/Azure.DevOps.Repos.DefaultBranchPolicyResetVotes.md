---
category: Microsoft Azure DevOps Repos
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.DefaultBranchPolicyResetVotes.md
---

# Azure.DevOps.Repos.DefaultBranchPolicyResetVotes

## SYNOPSIS

The branch policy should reset votes when changes are updated. This will help
ensure that the code in the default branch is of a high quality and that the
team's Git workflow is followed.

## DESCRIPTION

When a branch policy is configured to require a minimum number of reviewers and
votes, the policy should be configured to reset votes when changes are updated.
This will help ensure that the code in the default branch is of a high quality
and that the team's Git workflow is followed.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider configuring the branch policy to reset votes when changes are updated.

## LINKS

- [Create a branch policy](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops)
- [Branch policies](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies-overview?view=azure-devops)
- [Azure DevOps Security best practices](https://docs.microsoft.com/en-us/azure/devops/user-guide/security-best-practices?view=azure-devops#repositories-and-branches)
