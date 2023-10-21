---
category: Microsoft Azure DevOps Pipelines
severity: Critical
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets.md
---

# Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets

## SYNOPSIS

Release pipelines zouden geen geheimen in platte tekst moeten bevatten.

## DESCRIPTION

Release pipeline-variabelen mogen geen geheimen in platte tekst bevatten. Geheimen moeten
worden opgeslagen in Azure Key Vault en worden gerefereerd in de variabele groep. Dit zal
voorkomen dat het geheim wordt blootgesteld in de build logs. Als het geheim in platte
tekst wordt opgeslagen, wordt het blootgesteld in de build logs.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om geheimen op te slaan in Azure Key Vault en ze te refereren in de variabele
groep.

## LINKS

- [Azure DevOps Security best practices - Tasks](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
