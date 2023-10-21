---
category: Repository
severity: Important
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Core.UseYamlDefinition.md
---

# Gebruik YAML Pipeline-definities

## SYNOPSIS

Maak gebruik van YAML pipeline-definities om build- en release-pipelines te definiëren.

## DESCRIPTION

Het gebruik van YAML pipeline-definities biedt een aantal voordelen ten opzichte van de klassieke visuele editor:

- YAML pipeline-definities kunnen worden opgeslagen in een Git-repository,
  waardoor ze onder versiebeheer kunnen worden geplaatst.
- YAML pipeline-definities kunnen worden gecontroleerd op wijzigingen en
  worden goedgekeurd voordat ze worden geïmplementeerd.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om YAML pipeline-definities te gebruiken om build- en 
release-pipelines te definiëren.

## LINKS

- [Azure Pipelines YAML schema reference](https://docs.microsoft.com/nl-nl/azure/devops/pipelines/yaml-schema)
- [Azure DevOps security best practices](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#definitions)
