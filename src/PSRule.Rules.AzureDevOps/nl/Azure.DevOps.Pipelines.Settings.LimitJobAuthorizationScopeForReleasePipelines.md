---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines.md
---

# Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines

## SYNOPSIS

De projectinstellingen moeten de machtigingsomvang van de taak beperken tot de huidige project.

## DESCRIPTION

Release-pipelines kunnen worden gebruikt om te implementeren naar meerdere omgevingen. 
Elke omgeving kan worden geconfigureerd om een andere set resources te gebruiken. Door de
machtigingsomvang van de taak te beperken tot het huidige project, kan de taak geen
toegang krijgen tot resources in andere projecten. Dit kan helpen voorkomen dat er per
ongeluk toegang wordt verkregen tot resources in andere projecten.

## RECOMMENDATION

Overweeg om de machtigingsomvang van de taak voor release-pipelines te beperken tot het huidige project in de projectinstellingen.

## LINKS

- [Azure DevOps Security best practices - Tasks](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
