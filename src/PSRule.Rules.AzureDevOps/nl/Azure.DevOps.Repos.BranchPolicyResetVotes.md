---
category: Microsoft Azure DevOps Repos
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/AzureDevOps.Repos.BranchPolicyResetVotes.md
---

# AzureDevOps.Repos.BranchPolicyResetVotes

## SYNOPSIS

De branch policy zou stemmen moeten resetten wanneer wijzigingen worden
bijgewerkt. Dit zal helpen om ervoor te zorgen dat de code in de standaard
branch van hoge kwaliteit is en dat de Git workflow van het team wordt
gevolgd.

## DESCRIPTION

Als een branch policy is geconfigureerd om een minimum aantal reviewers en
stemmen te vereisen, moet de policy worden geconfigureerd om stemmen te
resetten wanneer wijzigingen worden bijgewerkt. Dit zal helpen om ervoor te
zorgen dat de code in de standaard branch van hoge kwaliteit is en dat de
Git workflow van het team wordt gevolgd.

## RECOMMENDATION

Overweeg om de branch policy te configureren om stemmen te resetten wanneer
wijzigingen worden bijgewerkt.

## LINKS

- [Create a branch policy](https://docs.microsoft.com/nl-nl/azure/devops/repos/git/branch-policies?view=azure-devops)
- [Branch policies](https://docs.microsoft.com/nl-nl/azure/devops/repos/git/branch-policies-overview?view=azure-devops)
- [Azure DevOps Security best practices](https://docs.microsoft.com/nl-nl/azure/devops/user-guide/security-best-practices?view=azure-devops#repositories-and-branches)
