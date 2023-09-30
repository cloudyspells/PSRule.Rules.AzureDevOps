# PSRule rule definitions for Azure DevOps Pipelines Service Connections

# Synopsis: Production service connection should be protected by one or more checks
Rule 'Azure.DevOps.ServiceConnections.ProductionCheckProtection' `
    -Ref 'ADO-SC-001' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -With 'IsProduction' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'Production service connection should be protected by one or more checks.'
        Reason 'No checks are configured for the service connection.'
        Recommend 'Add one or more check gates to the production service connection.'
        $Assert.HasField($TargetObject, "Checks", $true)
        $Assert.NotNull($TargetObject, "Checks")
}

# Synopsis: Production service connection should be protected by a human approval
Rule 'Azure.DevOps.ServiceConnections.ProductionHumanApproval' `
    -Ref 'ADO-SC-002' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -With 'IsProduction' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'Production service connection should be protected by a human approval.'
        Reason 'No approval check is configured for the service connection.'
        Recommend 'Add one or more check gates to the production service connection.'
        $approvalCount = @($TargetObject.Checks | Where-Object { $_.type.name -eq 'Approval' })
        $Assert.Greater($approvalCount, "Count", 0)
}

# Synopsis: service connections should have a description
Rule 'Azure.DevOps.ServiceConnections.Description' `
    -Ref 'ADO-SC-003' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -Tag @{ release = 'GA'} `
    -Level Information {
        # Description 'Production service connection have a description.'
        Reason 'No description is configured for the service connection.'
        Recommend 'Add a description to the service connection to make it easier to understand its purpose.'
        $Assert.HasField($TargetObject, "description", $true)
        $Assert.HasFieldValue($TargetObject, "description")
}

# Synopsis: service connections should have a scope that is not a subscription
Rule 'Azure.DevOps.ServiceConnections.Scope' `
    -Ref 'ADO-SC-004' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -Tag @{ release = 'GA'} `
    -If { $TargetObject.data.scopeLevel -eq 'Subscription' } `
    -Level Information {
        # Description 'Service connection should have a scope that is not an entire subscription.'
        Reason 'The service connection is scoped to a subscription.'
        Recommend 'Confine the scope of the service connection to a resource group or resource.'
        # Links 'https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scope-service-connections'
        AllOf {
            $Assert.HasField($TargetObject, "data.scopeLevel", $true)
            $Assert.HasField($TargetObject, "authorization.parameters.scope", $true)
            $Assert.Contains($TargetObject, "authorization.parameters.scope", "resourcegroups")
        }
}

# Synopsis: service connections should should use Workload Idenity Federation
Rule 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' `
    -Ref 'ADO-SC-005' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -Tag @{ release = 'GA'} `
    -If { $TargetObject.data.scopeLevel -eq 'Subscription' } `
    -Level Warning {
        # Description 'Service connection should should use Workload Idenity Federation.'
        Reason 'The service connection does not use Workload Idenity Federation.'
        Recommend 'Use Workload Idenity Federation to authenticate the service connection.'
        # Links 'https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-using-workload-identity-federation'
        AllOf {
            $Assert.HasField($TargetObject, "data.scopeLevel", $true)
            $Assert.HasField($TargetObject, "authorization.parameters.workloadIdentityFederationSubject", $true)
        }
}

# Synopsis: Production service connection should be limited to specific branches
Rule 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' `
    -Ref 'ADO-SC-006' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -With 'IsProduction' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'Production service connection should be limited to specific branches.'
        Reason 'The service connection is not limited to specific branches.'
        Recommend 'Limit the service connection to specific branches.'
        $Assert.HasField($TargetObject, "Checks[?@settings.displayName == 'Branch control'].settings.inputs.allowedBranches", $true)
        $Assert.HasFieldValue($TargetObject, "Checks[?@settings.displayName == 'Branch control'].settings.inputs.allowedBranches")
}
