---
category: Microsoft Azure DevOps Repos
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/AzureDevOps.Repos.BranchPolicyMinimumReviewers.md
---

# AzureDevOps.Repos.BranchPolicyMinimumReviewers

## SYNOPSIS

De standaard branch van het repository zou een branch policy moeten hebben
met een minimum aantal reviewers.

## DESCRIPTION

Door een minimum aantal reviewers voor een branch policy in te stellen,
wordt ervoor gezorgd dat de code in de standaard branch van hoge kwaliteit
is en dat de Git workflow van het team wordt gevolgd.

Je kunt het minimum aantal reviewers voor deze regel configureren door de
`branchMinimumApproverCount` configuratiewaarde in PSRule in te stellen.

## RECOMMENDATION

Overweeg om de optie om een minimum aantal reviewers voor een branch policy
in te stellen in te schakelen.

## LINKS

- [Create a branch policy](https://docs.microsoft.com/nl-nl/azure/devops/repos/git/branch-policies?view=azure-devops)
- [Branch policies](https://docs.microsoft.com/nl-nl/azure/devops/repos/git/branch-policies-overview?view=azure-devops)
- [Minimum number of reviewers](https://docs.microsoft.com/nl-nl/azure/devops/repos/git/branch-policies-overview?view=azure-devops#minimum-number-of-reviewers)
- [Azure DevOps Security best practices](https://docs.microsoft.com/nl-nl/azure/devops/user-guide/security-best-practices?view=azure-devops#repositories-and-branches)
