---
category: Repository
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Environments.ProductionBranchLimit.md
---

# Azure.DevOps.Pipelines.Environments.ProductionBranchLimit

## SYNOPSIS

Een productie environment moet beperkt zijn in de branches waarin deze kan worden gebruikt.

## DESCRIPTION

Een productie environment moet beperkt zijn in de branches waarin deze kan worden gebruikt. Dit zorgt ervoor dat de omgeving niet wordt gebruikt in een
niet-productiebranch. Deze regel controleert of de environment is beperkt tot een
productiebranch.

## RECOMMENDATION

Overweeg om de environment te beperken tot een productiebranch.

## LINKS

- [Azure DevOps Pipelines Environments](https://docs.microsoft.com/nl-nl/azure/devops/pipelines/process/environments)
