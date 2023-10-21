---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.ServiceConnections.ProductionHumanApproval.md
---

# Azure.DevOps.ServiceConnections.ProductionHumanApproval

## SYNOPSIS

Een service connection die is beperkt tot productie moet worden beschermd 
door een menselijke review en goedkeuring. Dit zal helpen om ervoor te
zorgen dat er geen onbedoelde wijzigingen worden aangebracht in de
productie resources.

## DESCRIPTION

Door een service connection te beperken tot productie, wordt voorkomen dat
deze wordt gebruikt voor het wijzigen van resources in andere omgevingen.
Bijvoorbeeld, een service connection die is beperkt tot productie zou moeten
worden beschermd met een check die een minimum aantal reviewers vereist.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om een service connection die is beperkt tot productie te
beschermen met een menselijke review en goedkeuring.

## LINKS

- [Define approvals and checks](https://learn.microsoft.com/nl-nl/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass)

