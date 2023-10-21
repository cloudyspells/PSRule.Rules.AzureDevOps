---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Releases.Definition.SelfApproval.md
---

# Azure.DevOps.Pipelines.Releases.Definition.SelfApproval

## SYNOPSIS

Een release stage die is beperkt tot productie mag geen zelfgoedkeuring toestaan.

## DESCRIPTION

Een release stage die is beperkt tot productie mag geen zelfgoedkeuring toestaan. Deze
regel controleert of een release stage die is beperkt tot productie zelfgoedkeuring heeft ingeschakeld.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om zelfgoedkeuring voor de omgeving uit te schakelen.

## LINKS

- [Release Pipelines](https://docs.microsoft.com/nl-nl/azure/devops/pipelines/release/?view=azure-devops)
