---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.ServiceConnections.ClassicAzure.md
---

# Azure.DevOps.ServiceConnections.ClassicAzure

## SYNOPSIS

Een serviceverbinding mag niet het klassieke Azure-serviceverbindingstype gebruiken.

## DESCRIPTION

Een serviceverbinding is een veilig opgeslagen object dat informatie bevat over hoe u
verbinding kunt maken met een service. Serviceverbindingen worden tijdens de build- of
release-pijplijn gebruikt om verbinding te maken met externe en externe bronnen. Het
klassieke Azure-serviceverbindingstype kan niet worden geschaald naar een specifieke
resourcegroep of abonnement. Dit betekent dat elke gebruiker met toegang tot de
serviceverbinding kan implementeren naar elke resourcegroep of elk abonnement. Ook het
klassieke Azure-serviceverbindingstype ondersteunt geen moderne manieren van authenticatie.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Overweeg om een serviceverbindingstype te gebruiken dat kan worden geschaald naar een
specifieke resourcegroep met moderne authenticatie.

## LINKS

- [Azure DevOps security best practices](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#scope-service-accounts)
- [Create a service connection](https://learn.microsoft.com/nl-nl/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-using-workload-identity-federation)
