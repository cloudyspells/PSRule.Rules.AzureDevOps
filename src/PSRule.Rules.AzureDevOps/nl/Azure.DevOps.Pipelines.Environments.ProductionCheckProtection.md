---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Environments.ProductionCheckProtection.md
---

# Azure.DevOps.Pipelines.Environments.ProductionCheckProtection

## SYNOPSIS

Een Azure DevOps Pipelines environment die is beperkt tot productie zou
moeten worden beschermd met een of meer controles om te voorkomen dat er
per ongeluk wijzigingen worden aangebracht in productiebronnen.

## DESCRIPTION

Een Azure DevOps Pipelines environment die is beperkt tot productie zou
moeten worden beschermd met een of meer controles om te voorkomen dat er
per ongeluk wijzigingen worden aangebracht in productiebronnen. Controles
kunnen worden gebruikt om te eisen dat een gebruiker een implementatie
goedkeurt of dat er een succesvolle build moet zijn voordat een
implementatie kan worden uitgevoerd.

## RECOMMENDATION

Overweeg om een of meer controles toe te voegen aan de Azure DevOps
Pipelines environment die is beperkt tot productie.

## LINKS

- [Define approvals and checks](https://learn.microsoft.com/nl-nl/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass)
- [Create an environment](https://docs.microsoft.com/nl-nl/azure/devops/pipelines/process/environments?view=azure-devops&tabs=yaml#create-an-environment)
