# PSRule rule definitions for Azure DevOps Pipelines definitions

# Synopsis: Pipelines should use YAML definitions
Rule 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' `
    -Ref 'ADO-PL-001' `
    -Type 'Azure.DevOps.Pipeline' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description "Pipelines should use YAML definitions instead of classic editor"
        Reason "The pipeline is using a classic editor definition"
        Recommend "Consider using YAML definitions for your pipelines"
        # Links "https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#definitions"
        AllOf {
            $Assert.HasField($TargetObject, "configuration.type", $true)
            $Assert.HasFieldValue($TargetObject, "configuration.type", "yaml")
        }
}

# Synopsis: Pipelines should not have inherited permissions
Rule 'Azure.DevOps.Pipelines.Core.InheritedPermissions' `
    -Ref 'ADO-PL-002' `
    -Type 'Azure.DevOps.Pipeline' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description "Pipelines should not have inherited permissions"
        Reason "The pipeline is using inherited permissions"
        Recommend "Consider using explicit permissions for your pipelines"
        # Links "https://docs.microsoft.com/en-us/azure/devops/pipelines/policies/permissions?view=azure-devops&tabs=yaml"
        AllOf {
            $Assert.HasField($TargetObject, "Acls.inheritPermissions", $true)
            $Assert.HasFieldValue($TargetObject, "Acls.inheritPermissions", $false)
        }
}