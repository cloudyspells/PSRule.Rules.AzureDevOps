---
category: Microsoft Azure DevOps Pipelines
severity: Important
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork.md
---

# Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork

## SYNOPSIS

De projectinstellingen moeten een opmerking vereisen voor pull-aanvragen van een fork.

## DESCRIPTION

Voordat een fork wordt gebouwd, moet een lid van het project de wijzigingen bekijken en de
pull-aanvraag goedkeuren. Dit kan helpen voorkomen dat er kwaadaardige code in het project
wordt geïntroduceerd.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om een opmerking te vereisen voor pull-aanvragen van een fork in de
projectinstellingen.

## LINKS

- [Azure DevOps Security best practices - Repos and branches](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#repositories-and-branches)
