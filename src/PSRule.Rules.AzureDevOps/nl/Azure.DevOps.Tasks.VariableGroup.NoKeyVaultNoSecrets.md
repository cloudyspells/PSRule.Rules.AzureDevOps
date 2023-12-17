---
category: Microsoft Azure DevOps Distributed Task
severity: Critical
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets.md
---

# Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets

## SYNOPSIS

Een variabele groep zou geen geheimen moeten bevatten wanneer deze niet is
gekoppeld aan een key vault.

## DESCRIPTION

Een variabele groep zou geen geheimen moeten bevatten wanneer deze niet is
gekoppeld aan een key vault. Dit komt omdat de geheimen in platte tekst
worden opgeslagen in de variabele groep en kunnen worden bekeken door
iedereen met toegang tot de variabele groep.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om alle geheimen uit de variabele groep te verwijderen of te
vervangen door variabelen die zijn gekoppeld aan een key vault.

## LINKS

- [Create a variable group with key vault](https://learn.microsoft.com/nl-nl/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml#link-secrets-from-an-azure-key-vault)
