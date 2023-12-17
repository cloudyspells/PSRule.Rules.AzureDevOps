---
category: Repository
severity: Important
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest.md
---

# Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest

## SYNOPSIS

Microsoft Hosted agent pools should be pinned to a version.

## DESCRIPTION

Microsoft Hosted agent pools should be pinned to a version. This ensures that
the pipeline will not be impacted by changes to the agent pool and its
operating system.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider pinning the agent pool to a specific version.

## LINKS

- [Azure Pipelines YAML schema reference](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema)
