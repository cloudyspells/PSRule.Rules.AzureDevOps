# PSRule rule definitions for Azure DevOps Pipelines Environments

# Synopsis: Production environment should be protected by one or more checks
Rule 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' `
    -Ref 'ADO-E-001' `
    -Type 'Azure.DevOps.Pipelines.Environment' `
    -With 'IsProduction' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: Production environment should be protected by one or more checks
        # Reason: No checks are configured for the environment
        # Recommendation: Add one or more check gates to the production environment
        # Links: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops#check-gates
        AllOf {
            $Assert.HasField($TargetObject, "checks", $true)
            $Assert.NotCount($TargetObject, "checks", 0)
            $Assert.NotNull($TargetObject, "checks")
        }
}

# Synopsis: Production environment should be protected by a human approval
Rule 'Azure.DevOps.Pipelines.Environments.ProductionHumanApproval' `
    -Ref 'ADO-E-002' `
    -Type 'Azure.DevOps.Pipelines.Environment' `
    -With 'IsProduction' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: Production environment should be protected by a human approval
        # Reason: No approval check is configured for the environment
        # Recommendation: Add one or more check gates to the production environment
        # Links: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops#check-gates
        $approvalCount = @($TargetObject.checks | Where-Object { $_.type.name -eq 'Approval' })
        $Assert.Greater($approvalCount, "Count", 0)
}

# Synopsis: Environments should have a description
Rule 'Azure.DevOps.Pipelines.Environments.Description' `
    -Ref 'ADO-E-003' `
    -Type 'Azure.DevOps.Pipelines.Environment' `
    -Tag @{ release = 'GA'} `
    -Level Information {
        # Description: Production environment have a description
        # Reason: No description is configured for the environment
        # Recommendation: Add a description to the environment to make it easier to understand its purpose
        # Links: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops#check-gates
        $Assert.HasField($TargetObject, "description", $true)
        $Assert.NotNull($TargetObject, "description")
}

