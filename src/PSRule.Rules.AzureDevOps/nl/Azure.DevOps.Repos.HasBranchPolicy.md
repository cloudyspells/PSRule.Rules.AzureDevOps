---
category: Microsoft Azure DevOps Repos
severity: Critical
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/AzureDevOps.Repos.HasBranchPolicy.md
---

# AzureDevOps.Repos.HasBranchPolicy

## SYNOPSIS

Het standaard branch van het repository zou een branch policy moeten hebben.

## DESCRIPTION

Een branch policy is een set regels die de kwaliteit van de code en de Git
workflow van het team bepalen. Branch policies kunnen de codekwaliteit en
de normen voor wijzigingsbeheer van uw team afdwingen. Ze kunnen uw team ook
helpen om bugs eerder in de ontwikkelingscyclus te vinden en op te lossen.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om een branch policy toe te voegen aan de standaard branch van uw
repository. Dit zal helpen om ervoor te zorgen dat de code in de standaard
branch van hoge kwaliteit is en dat de Git workflow van het team wordt gevolgd.

## LINKS

- [Create a branch policy](https://docs.microsoft.com/nl-nl/azure/devops/repos/git/branch-policies?view=azure-devops)
- [Branch policies](https://docs.microsoft.com/nl-nl/azure/devops/repos/git/branch-policies-overview?view=azure-devops)
- [Azure DevOps Security best practices](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#secure-azure-repos)
