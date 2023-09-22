---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Environments.ProductionHumanApproval.md
---

# Azure.DevOps.Pipelines.Environments.ProductionHumanApproval

## SYNOPSIS

Een Azure DevOps Pipelines environment die is beperkt tot productie zou
moeten worden beschermd met een menselijke goedkeuring om te voorkomen dat
er per ongeluk wijzigingen worden aangebracht in productiebronnen.

## DESCRIPTION

De implementatie van een Azure DevOps Pipelines environment die is beperkt
tot productie zou moeten worden beschermd met een menselijke goedkeuring om
te voorkomen dat er per ongeluk wijzigingen worden aangebracht in
productiebronnen. Een goedkeuring kan worden gebruikt om te eisen dat een
gebruiker een implementatie goedkeurt voordat deze kan worden uitgevoerd.

## RECOMMENDATION

Overweeg om een menselijke goedkeuring toe te voegen aan de Azure DevOps
Pipelines environment die is beperkt tot productie.

## LINKS

- [Define approvals and checks](https://learn.microsoft.com/nl-nl/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass)
- [Create an environment](https://docs.microsoft.com/nl-nl/azure/devops/pipelines/process/environments?view=azure-devops&tabs=yaml#create-an-environment)
