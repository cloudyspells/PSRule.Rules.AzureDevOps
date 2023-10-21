---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime.md
---

# Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime

## SYNOPSIS

De projectinstellingen moeten het instellen van variabelen bij het wachtrijen beperken.

## DESCRIPTION

Het instellen van variabelen bij het wachtrijen kan worden gebruikt om variabelen die in de
pipeline zijn gedefinieerd te overschrijven. Dit kan handig zijn voor testen of debuggen.
Dit kan echter ook worden gebruikt om variabelen te overschrijven die worden gebruikt om
het gedrag van de pipeline te regelen en kan resulteren in onverwacht gedrag.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om het instellen van variabelen bij het wachtrijen uit te schakelen in de
projectinstellingen.

## LINKS

- [Azure DevOps Security best practices - Policies](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#policies)
