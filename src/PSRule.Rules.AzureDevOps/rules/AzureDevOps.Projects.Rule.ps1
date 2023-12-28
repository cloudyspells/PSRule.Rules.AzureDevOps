# PSRule rule definitions for Azure DevOps Pipelines definitions

# Synopsis: Pipelines should use YAML definitions
Rule 'Azure.DevOps.Project.Visibility' `
    -Ref 'ADO-PRJ-001' `
    -Type 'Azure.DevOps.Project' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description "Projects should not be public"
        Reason "The project is public"
        Recommend "Consider making the project private"
        # Links "https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#definitions"
        AllOf {
            $Assert.HasField($TargetObject, "visibility", $true)
            $Assert.HasFieldValue($TargetObject, "visibility", "private")
        }
}