---
category: Microsoft Azure DevOps Pipelines
severity: Critical
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets.md
---

# Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets

## SYNOPSIS

Variable groups should not contain secrets in plain text.

## DESCRIPTION

Variable groups should not contain secrets in plain text. Secrets should be stored in
Azure Key Vault and referenced in the variable group. This will prevent the secret from
being exposed in the build logs. If the secret is stored in plain text, it will be
exposed in the build logs.

## RECOMMENDATION

Consider storing secrets in Azure Key Vault and referencing them in the variable group.

## LINKS

- [Azure DevOps Security best practices - Tasks](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
