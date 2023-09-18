# PSRule rule definitions for Azure DevOps Pipelines definitions

# Synopsis: Pipelines should use YAML definitions
Rule 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' `
    -Ref 'ADO-PL-001' `
    -Type 'Azure.DevOps.Pipeline' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: Pipelines should use YAML definitions instead of classic editor
        # Reason: The pipeline is using a classic editor definition
        # Recommendation: Consider using YAML definitions for your pipelines
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#definitions
        AllOf {
            $Assert.HasField($TargetObject, "configuration.type", $true)
            $Assert.HasFieldValue($TargetObject, "configuration.type", "yaml")
        }
}
