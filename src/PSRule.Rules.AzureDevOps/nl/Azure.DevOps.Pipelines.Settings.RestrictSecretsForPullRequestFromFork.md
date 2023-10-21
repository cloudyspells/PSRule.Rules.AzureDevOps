---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork.md
---

# Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork

## SYNOPSIS

De projectinstellingen moeten de toegang tot geheimen voor pull-aanvragen van een fork
beperken.

## DESCRIPTION

Geheimen kunnen worden gebruikt om gevoelige informatie zoals wachtwoorden en
toegangstokens op te slaan. Geheimen kunnen in pipelines worden gebruikt om
resources zoals Azure Key Vault te openen. Geheimen kunnen worden geconfigureerd om
beschikbaar te zijn voor alle pipelines of alleen voor specifieke pipelines. Geheimen
kunnen ook worden geconfigureerd om beschikbaar te zijn voor pull-aanvragen van een fork.
Dit kan nuttig zijn voor open source projecten die bijdragen van de community accepteren.
Dit kan echter ook een beveiligingsrisico zijn. Een kwaadwillende gebruiker kan een
pull-aanvraag van een fork maken en de geheimen in de pipeline openen. Dit kan de
kwaadwillende gebruiker in staat stellen om gevoelige informatie zoals wachtwoorden en
toegangstokens te openen.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om de toegang tot geheimen voor pull-aanvragen van een fork te beperken in de
projectinstellingen.

## LINKS

- [Azure DevOps Security best practices - Forks](https://learn.microsoft.com/nl-nl/azure/devops/pipelines/security/repos?view=azure-devops#dont-provide-secrets-to-fork-builds)
