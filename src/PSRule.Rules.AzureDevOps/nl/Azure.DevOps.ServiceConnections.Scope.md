---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en-US/Azure.DevOps.ServiceConnections.Scope.md
---

# Azure.DevOps.ServiceConnections.Scope

## SYNOPSIS

Een service connection die is beperkt tot productie zou een smalle scope
moeten gebruiken. Dit zal helpen om ervoor te zorgen dat er geen onbedoelde
wijzigingen worden aangebracht in de productie resources of daarbuiten.

## DESCRIPTION

Een service connection die is beperkt tot productie zou een smalle scope
moeten gebruiken. Bijvoorbeeld, een service connection die is beperkt tot
productie zou alleen toegang moeten hebben tot de productie resource groups.
Dit zal helpen om ervoor te zorgen dat er geen onbedoelde wijzigingen worden
aangebracht in de productie resources of daarbuiten. Normaal gesproken is
het niet wenselijk om een service connection te hebben met toegang tot alle
resource groups in een abonnement.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om een service connection die is beperkt tot productie te beperken
tot een smalle scope.

## LINKS

- [Azure DevOps security best practices](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#scope-service-accounts)
- [Create a service connection](https://docs.microsoft.com/nl-nl/azure/devops/pipelines/library/connect-to-azure?view=azure-devops&tabs=yaml)
