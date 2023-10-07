---
category: Microsoft Azure DevOps Pipelines
severity: Critical
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets.md
---

# Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets

## SYNOPSIS

Variable groups zouden geen geheimen in platte tekst moeten bevatten.

## DESCRIPTION

Variable groups zouden geen geheimen in platte tekst moeten bevatten. Geheimen moeten
worden opgeslagen in Azure Key Vault en worden gerefereerd in de variabele groep. Dit
voorkomt dat het geheim wordt blootgesteld in de build logs. Als het geheim in platte
tekst wordt opgeslagen, wordt het blootgesteld in de build logs.

## RECOMMENDATION

Overweeg om geheimen op te slaan in Azure Key Vault en ze te refereren in de variabele
groep.

## LINKS

- [Azure DevOps Security best practices - Tasks](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
