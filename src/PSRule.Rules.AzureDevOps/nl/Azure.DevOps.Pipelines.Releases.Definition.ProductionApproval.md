---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval.md
---

# Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval

## SYNOPSIS

Een Azure DevOps Pipelines release stage die is beperkt tot productie zou
moeten worden beschermd met een menselijke goedkeuring om te voorkomen dat
er per ongeluk wijzigingen worden aangebracht in productiebronnen.

## DESCRIPTION

Het toevoegen van een menselijke goedkeuring aan een Azure DevOps Pipelines
release stage die is beperkt tot productie kan helpen om per ongeluk wijzigingen in productiebronnen te voorkomen. Een goedkeuring kan worden
gebruikt om te eisen dat een gebruiker een implementatie goedkeurt voordat
deze kan worden uitgevoerd.

U kunt het vereiste aantal goedkeurders voor deze regel configureren door de
`releaseMinimumProductionApproverCount` configuratiewaarde in PSRule in te
stellen. De standaardwaarde is `1`.

## RECOMMENDATION

Overweeg om een menselijke goedkeuring toe te voegen aan de Azure DevOps
Pipelines release stage die is beperkt tot productie.

## LINKS

- [Release Pipelines](https://docs.microsoft.com/nl-nl/azure/devops/pipelines/release/?view=azure-devops)
