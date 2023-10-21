---
category: Microsoft Azure DevOps Repos
severity: Informational
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Repos.BranchPolicyMergeStrategy.md
---

# Azure.DevOps.Repos.BranchPolicyMergeStrategy

## SYNOPSIS

Een Azure DevOps Repos branch policy zou moeten worden geconfigureerd om een
merge strategie voor pull requests te definiëren.

## DESCRIPTION

Definieer een merge strategie voor pull requests om ervoor te zorgen dat
wijzigingen op een consistente manier worden samengevoegd. Dit helpt om
ervoor te zorgen dat wijzigingen op een consistente manier worden
samengevoegd en vermindert zo het risico op merge conflicten.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om de optie om een merge strategie voor pull requests te definiëren
in te schakelen.

## LINKS

- [Create a branch policy](https://docs.microsoft.com/nl-nl/azure/devops/repos/git/branch-policies?view=azure-devops)
- [Branch policies](https://docs.microsoft.com/nl-nl/azure/devops/repos/git/branch-policies-overview?view=azure-devops)
- [Azure DevOps Security best practices](https://docs.microsoft.com/nl-nl/azure/devops/user-guide/security-best-practices?view=azure-devops#repositories-and-branches)
