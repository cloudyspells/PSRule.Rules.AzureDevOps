---
category: Microsoft Azure DevOps Distributed Task
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets.md
---

# Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets

## SYNOPSIS

A variable group should not contain any secrets when it is not linked to a key vault.

## DESCRIPTION

A variable group should not contain any secrets when it is not linked to a key vault. This is because the secrets will be stored in plain text in the variable group and can be viewed by anyone with access to the variable group.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider removing any secrets from the variable group or replacing them with variables that are linked to a key vault.

## LINKS

- [Create a variable group with key vault](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml#link-secrets-from-an-azure-key-vault)
