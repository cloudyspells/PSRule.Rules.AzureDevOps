---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope.md
---

# Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope

## SYNOPSIS

De projectinstellingen moeten de machtigingsomvang van de taak beperken tot de huidige project.

## DESCRIPTION

Het beperken van de machtigingsomvang van de taak tot het huidige project voorkomt dat de taak toegang krijgt tot resources in andere projecten. Dit kan helpen voorkomen dat er per ongeluk toegang wordt verkregen tot resources in andere projecten.

## RECOMMENDATION

Overweeg om de machtigingsomvang van de taak voor release-pipelines te beperken tot het huidige project in de projectinstellingen.

## LINKS

- [Azure DevOps Security best practices - Tasks](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
