---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.ServiceConnections.GitHubPAT.md
---

# Azure.DevOps.ServiceConnections.GitHubPAT

## SYNOPSIS

Een serviceverbinding zou geen GitHub-persoonlijke toegangstoken (PAT) moeten gebruiken.

## DESCRIPTION

Een serviceverbinding is een veilig opgeslagen object dat informatie bevat over hoe u
verbinding kunt maken met een service. Serviceverbindingen worden tijdens de build- of
release-pijplijn gebruikt om verbinding te maken met externe en externe bronnen. Het GitHub
PAT-serviceverbindingstype is gekoppeld aan een persoonlijk account en kan niet worden
getraceerd naar de specifieke verbinding vanuit Azure DevOps. Dit betekent dat elke
gebruiker met toegang tot de serviceverbinding zich kan voordoen als de gebruiker die de
serviceverbinding heeft gemaakt.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg een oauth-gebaseerde serviceverbinding te gebruiken.

## LINKS

- [Azure DevOps security best practices](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#secure-github-integrations)
- [Create a service connection](https://learn.microsoft.com/nl-nl/azure/devops/pipelines/library/connect-to-azure?view=azure-devops)
