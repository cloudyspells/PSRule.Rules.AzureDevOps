---
category: Microsoft Azure DevOps Retention Settings
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.RetentionSettings.PullRequestRunsMinimumRetentionDays.md
---

# Azure.DevOps.RetentionSettings.PullRequestRunsMinimumRetentionDays

## SYNOPSIS

Retention settings for rull request runs should be configured to meet compliance
requirements such as 30 days for production environments.

## DESCRIPTION

Retention settings for rull request runs should be configured to meet compliance
requirements such as 30 days for production environments. 


Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider setting a minimum retention period of more than 7 days for pull request runs.

## LINKS

- [Define approvals and checks](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass)

