---
category: Repository
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.ServiceConnections.ProductionBranchLimit.md
---

# Azure.DevOps.ServiceConnections.ProductionBranchLimit

## SYNOPSIS

Een productieserviceverbinding moet beperkt zijn in de branches waarin deze kan worden gebruikt.

## DESCRIPTION

Een productieserviceverbinding moet beperkt zijn in de branches waarin deze kan worden gebruikt. Dit zorgt ervoor dat de serviceverbinding niet wordt gebruikt in een
niet-productiebranch. Deze regel controleert of de serviceverbinding is beperkt tot een
productiebranch.

## RECOMMENDATION

Overweeg om de serviceverbinding te beperken tot een productiebranch.

## LINKS

- [Azure DevOps Service connections](https://docs.microsoft.com/nl-nl/azure/devops/pipelines/library/service-endpoints?view=azure-devops)
