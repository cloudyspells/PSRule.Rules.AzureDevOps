---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.ServiceConnections.ProductionCheckProtection.md
---

# Azure.DevOps.ServiceConnections.ProductionCheckProtection

## SYNOPSIS

Een service connection die is beperkt tot productie zou moeten worden
beschermd. Dit zal helpen om ervoor te zorgen dat er geen onbedoelde
wijzigingen worden aangebracht in de productie resources.

## DESCRIPTION

Door een service connection te beperken tot productie, wordt voorkomen dat
deze wordt gebruikt voor het wijzigen van resources in andere omgevingen.
Het beschermen van een service connection met één of meer checks zal helpen
voorkomen dat er per ongeluk wijzigingen worden aangebracht in productie
resources. Bijvoorbeeld, een service connection die is beperkt tot productie
zou moeten worden beschermd met een check die een minimum aantal reviewers
vereist of een specifieke CI pipeline moet doorlopen.

## RECOMMENDATION

Overweeg om een service connection die is beperkt tot productie te
beschermen met één of meer checks.

## LINKS

- [Define approvals and checks](https://learn.microsoft.com/nl-nl/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass)

