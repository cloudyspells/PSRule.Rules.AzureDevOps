# PSRule rule definitions for Azure DevOps Pipelines Service Connections

# Synopsis: Production service connection should be protected by one or more checks
Rule 'Azure.DevOps.ServiceConnections.ProductionCheckProtection' `
    -Ref 'ADO-SC-001' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -With 'IsProduction' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: Production service connection should be protected by one or more checks
        # Reason: No checks are configured for the service connection
        # Recommendation: Add one or more check gates to the production service connection
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
        # Description: Production service connection should be protected by a human approval
        # Reason: No approval check is configured for the service connection
        # Recommendation: Add one or more check gates to the production service connection
        $approvalCount = @($TargetObject.Checks | Where-Object { $_.type.name -eq 'Approval' })
        $Assert.Greater($approvalCount, "Count", 0)
}

# Synopsis: service connections should have a description
Rule 'Azure.DevOps.ServiceConnections.Description' `
    -Ref 'ADO-SC-003' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -Tag @{ release = 'GA'} `
    -Level Information {
        # Description: Production service connection have a description
        # Reason: No description is configured for the service connection
        # Recommendation: Add a description to the service connection to make it easier to understand its purpose
        $Assert.HasField($TargetObject, "description", $true)
        $Assert.NotNull($TargetObject, "description")
}

# Synopsis: service connections should have a scope that is not a subscription
Rule 'Azure.DevOps.ServiceConnections.Scope' `
    -Ref 'ADO-SC-004' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -Tag @{ release = 'GA'} `
    -If { $TargetObject.data.scopeLevel -eq 'Subscription' } `
    -Level Information {
        # Description: Service connection should have a scope that is not an entire subscription
        # Reason: The service connection is scoped to a subscription
        # Recommendation: Confine the scope of the service connection to a resource group or resource
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scope-service-connections
        AllOf {
            $Assert.HasField($TargetObject, "data.scopeLevel", $true)
            $Assert.HasField($TargetObject, "authorization.parameters.scope", $true)
            #$Assert.NotLike($TargetObject, "data.scopeLevel", "Subscription")
            $Assert.Contains($TargetObject, "authorization.parameters.scope", "resourcegroups")
        }
        #$Assert.HasField($TargetObject, "data.scopeLevel", $true)
        #$Assert.NotLike($TargetObject, "data.scopeLevel", "Subscription")
}
