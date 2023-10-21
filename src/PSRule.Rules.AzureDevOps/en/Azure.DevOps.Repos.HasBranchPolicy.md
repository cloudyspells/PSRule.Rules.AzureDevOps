---
category: Microsoft Azure DevOps Repos
severity: Critical
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/AzureDevOps.Repos.HasBranchPolicy.md
---

# AzureDevOps.Repos.HasBranchPolicy

## SYNOPSIS

The repository's default branch should have a branch policy

## DESCRIPTION

A branch policy is a set of rules that govern the quality of the code and the
team's Git workflow. Branch policies can enforce your team's code quality and
change management standards. They can also help your team find and fix bugs
earlier in the development cycle.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider adding a branch policy to the default branch of your repository.
This will help ensure that the code in the default branch is of a high quality
and that the team's Git workflow is followed.

## LINKS

- [Create a branch policy](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops)
- [Branch policies](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies-overview?view=azure-devops)
- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#secure-azure-repos)
