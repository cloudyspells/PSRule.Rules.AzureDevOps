---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments.md
---

# Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments

## SYNOPSIS

De projectinstellingen moeten het instellen van variabelen bij het wachtrijen beperken.

## DESCRIPTION

Shell-taken kunnen worden gebruikt om willekeurige opdrachten op de agent uit te voeren.
Als de argumenten niet worden gesaneerd, is het mogelijk dat een kwaadwillende extra
opdrachten in de argumenten injecteert. Dit kan leiden tot de uitvoering van kwaadaardige
code op de agent.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om het instellen van variabelen bij het wachtrijen uit te schakelen in de
projectinstellingen.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
