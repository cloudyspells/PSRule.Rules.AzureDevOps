---
category: Microsoft Azure DevOps Retention Settings
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.RetentionSettings.ArtifactMinimumRetentionDays.md
---

# Azure.DevOps.RetentionSettings.ArtifactMinimumRetentionDays

## SYNOPSIS

Retention settings for artifacts should be configured to meet compliance
requirements. For example, a retention policy of 30 days may be required for
production environments.

## DESCRIPTION

Retention settings for artifacts should be configured to meet compliance
requirements. For example, a retention policy of 30 days may be required for
production environments.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider setting a minimum retention period of more than 7 days for artifacts.

## LINKS

- [Define approvals and checks](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass)

