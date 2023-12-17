---
category: Repository
severity: Important
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest.md
---

# Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest

## SYNOPSIS

Microsoft Hosted agent pools zouden vastgepind moeten worden op een versie.

## DESCRIPTION

Microsoft Hosted agent pools zouden vastgepind moeten worden op een versie. Dit
zorgt ervoor dat de pipeline niet beïnvloed wordt door wijzigingen aan de agent
pool en het besturingssysteem.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om de agent pool vast te pinnen op een specifieke versie.

## LINKS

- [Azure Pipelines YAML schema reference](https://docs.microsoft.com/nl-nl/azure/devops/pipelines/yaml-schema)
