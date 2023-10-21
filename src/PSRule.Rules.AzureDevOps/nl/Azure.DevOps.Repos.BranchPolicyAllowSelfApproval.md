---
category: Microsoft Azure DevOps Repos
severity: Critical
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/AzureDevOps.Repos.BranchPolicyAllowSelfApproval.md
---

# AzureDevOps.Repos.BranchPolicyAllowSelfApproval

## SYNOPSIS

Auteur van wijzigingen zou niet moeten worden toegestaan om hun eigen
wijzigingen goed te keuren.

## DESCRIPTION

De branch policy zou niet moeten toestaan dat de auteur van wijzigingen zijn
eigen wijzigingen goedkeurt. Dit zal helpen om ervoor te zorgen dat de code
in de standaard branch van hoge kwaliteit is en dat de Git workflow van het
team wordt gevolgd.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om de optie om makers hun eigen wijzigingen te laten goedkeuren
uit te schakelen.

## LINKS

- [Create a branch policy](https://docs.microsoft.com/nl-nl/azure/devops/repos/git/branch-policies?view=azure-devops)
- [Branch policies](https://docs.microsoft.com/nl-nl/azure/devops/repos/git/branch-policies-overview?view=azure-devops)
- [Azure DevOps Security best practices](https://docs.microsoft.com/nl-nl/azure/devops/user-guide/security-best-practices?view=azure-devops#repositories-and-branches)
