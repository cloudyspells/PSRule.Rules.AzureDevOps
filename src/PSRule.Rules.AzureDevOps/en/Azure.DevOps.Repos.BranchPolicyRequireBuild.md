---
category: Microsoft Azure DevOps Repos
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyRequireBuild.md
---

# Azure.DevOps.Repos.BranchPolicyRequireBuild

## SYNOPSIS

The branch policy should be configured to require a build or CI pipeline to pass
before changes can be merged into the default branch.

## DESCRIPTION

The branch policy should be configured to require a build or CI pipeline to pass
before changes can be merged into the default branch. This ensures that changes
are validated before being merged into the default branch. This rule does not
validate that the build or CI pipeline is configured correctly. It only validates
that a build or CI pipeline is configured.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider enabling the branch policy to require a build or CI pipeline to pass

## LINKS

- [Create a branch policy](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops)
- [Branch policies](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies-overview?view=azure-devops)
- [Azure DevOps Security best practices](https://docs.microsoft.com/en-us/azure/devops/user-guide/security-best-practices?view=azure-devops#policies)
