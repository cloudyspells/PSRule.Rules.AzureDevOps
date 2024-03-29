# PSRule rule definitions for Azure DevOps Pipelines Service Connections

# Synopsis: Production service connection should be protected by one or more checks
Rule 'Azure.DevOps.ServiceConnections.ProductionCheckProtection' `
    -Ref 'ADO-SC-001' `
    -Type 'Azure.DevOps.ServiceConnection' `
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
    -If { $TargetObject.data.scopeLevel -eq 'Subscription' -and $TargetObject.type -eq 'azurerm' } `
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
    -If { $TargetObject.data.scopeLevel -eq 'Subscription' -and $TargetObject.type -eq 'azurerm' } `
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
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'Production service connection should be limited to specific branches.'
        Reason 'The service connection is not limited to specific branches.'
        Recommend 'Limit the service connection to specific branches.'
        $Assert.HasField($TargetObject, "Checks[?@settings.displayName == 'Branch control'].settings.inputs.allowedBranches", $true)
        $Assert.HasFieldValue($TargetObject, "Checks[?@settings.displayName == 'Branch control'].settings.inputs.allowedBranches")
}

# Synopsis: Service Connection should not be of the classic azure type
Rule 'Azure.DevOps.ServiceConnections.ClassicAzure' `
    -Ref 'ADO-SC-007' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -Tag @{ release = 'GA'} `
    -If { $TargetObject.type -match 'azure' } `
    -Level Warning {
        # Description 'Service Connection should not be of the classic azure type.'
        Reason 'The service connection is of the classic azure type.'
        Recommend 'Use the Azure Resource Manager service connection type.'
        $Assert.NotIn($TargetObject, "type", "azure")
}

# Synposis: Service Connections of the GitHub type should not use a PAT
Rule 'Azure.DevOps.ServiceConnections.GitHubPAT' `
    -Ref 'ADO-SC-008' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -If { $TargetObject.type -match 'github' } `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'Service Connections of the GitHub type should not use a PAT.'
        Reason 'The service connection uses a PAT.'
        Recommend 'Use a GitHub App instead of a PAT.'
        $Assert.NotIn($TargetObject, "authorization.scheme", "Token")
}

# Synposis: Service Connections should not inherit permissions
Rule 'Azure.DevOps.ServiceConnections.InheritedPermissions' `
    -Ref 'ADO-SC-009' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'Service Connections should not inherit permissions.'
        Reason 'The service connection inherits permissions.'
        Recommend 'Do not inherit permissions for the service connection.'
        AllOf {
            $Assert.HasField($TargetObject, "Acls", $true)
            $Assert.HasField($TargetObject.Acls[0], "inheritPermissions", $true)
            $Assert.HasFieldValue($TargetObject.Acls[0], "inheritPermissions", $false)
        }
}

# Synposis: Service connections should not have direct permissions for Project Valid Users
Rule 'Azure.DevOps.ServiceConnections.ProjectValidUsers' `
    -Ref 'ADO-SC-010' `
    -Type 'Azure.DevOps.ServiceConnection' `
    -Tag @{ release = 'GA' } `
    -Level Warning {
        # Description 'Service connections should not have direct permissions for Project Valid Users.'
        Reason 'The service connection has direct permissions for Project Valid Users.'
        Recommend 'Do not grant direct permissions for Project Valid Users for the service connection.'
        AllOf {
            # Loop through all the propeties of the first ACL
            $TargetObject.Acls[0].acesDictionary.psobject.Properties.GetEnumerator() | ForEach-Object {
                # Assert the property name does not end with -0-0-0-0-3 wich is the Project Valid Users group SID
                AnyOf {
                    $Assert.NotMatch($_.Value, "descriptor", "-0-0-0-0-3")
                    $Assert.HasFieldValue($_.Value, "allow", 16)
                }
            }
        }
}
