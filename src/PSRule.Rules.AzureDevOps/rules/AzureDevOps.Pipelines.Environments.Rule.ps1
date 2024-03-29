# PSRule rule definitions for Azure DevOps Pipelines Environments

# Synopsis: Production environment should be protected by one or more checks
Rule 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' `
    -Ref 'ADO-E-001' `
    -Type 'Azure.DevOps.Pipelines.Environment' `
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
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'Production environment should be protected by a human approval'
        Reason 'No approval check is configured for the environment'
        Recommend 'Add one or more check gates to the production environment'
        # Links 'https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops#check-gates'
        $approvalCount = @($TargetObject.checks | Where-Object { $_.type.name -eq 'Approval' })
        $Assert.Greater($approvalCount, "Count", 0)
}

# Synopsis: Environments should have a description
Rule 'Azure.DevOps.Pipelines.Environments.Description' `
    -Ref 'ADO-E-003' `
    -Type 'Azure.DevOps.Pipelines.Environment' `
    -Tag @{ release = 'GA'} `
    -Level Information {
        # Description 'Production environment have a description'
        Reason 'No description is configured for the environment'
        Recommend 'Add a description to the environment to make it easier to understand its purpose'
        # Links 'https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops#check-gates'
        $Assert.HasField($TargetObject, "description", $true)
        $Assert.HasFieldValue($TargetObject, "description")
}

# Synopsis: Production environment should be limited to specific branches
Rule 'Azure.DevOps.Pipelines.Environments.ProductionBranchLimit' `
    -Ref 'ADO-E-004' `
    -Type 'Azure.DevOps.Pipelines.Environment' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'Production environment should be limited to specific branches'
        Reason 'The environment is not limited to specific branches'
        Recommend 'Limit the environment to specific branches'
        # Links 'https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops#check-gates'
        $Assert.HasField($TargetObject, "checks[?@settings.displayName == 'Branch control'].settings.inputs.allowedBranches", $true)
        $Assert.HasFieldValue($TargetObject, "checks[?@settings.displayName == 'Branch control'].settings.inputs.allowedBranches")
}

# Synopsis: Environment should not have inherited permissions
Rule 'Azure.DevOps.Pipelines.Environments.InheritedPermissions' `
    -Ref 'ADO-E-005' `
    -Type 'Azure.DevOps.Pipelines.Environment' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'Environment should not have inherited permissions'
        Reason 'The environment has inherited permissions'
        Recommend 'Remove inherited permissions from the environment'
        # Links 'https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops#check-gates'
        AllOf {
            $Assert.HasField($TargetObject, "Acls", $true)
            $Assert.HasField($TargetObject.Acls[0], "inheritPermissions", $true)
            $Assert.HasFieldValue($TargetObject.Acls[0], "inheritPermissions", $false)
        }
}

# Synposis: Environments should not have direct permissions for Project Valid Users
Rule 'Azure.DevOps.Pipelines.Environments.ProjectValidUsers' `
    -Ref 'ADO-E-006' `
    -Type 'Azure.DevOps.Pipelines.Environment' `
    -Tag @{ release = 'GA' } `
    -Level Warning {
        # Description 'Environments should not have direct permissions for Project Valid Users.'
        Reason 'The environment has direct permissions for Project Valid Users.'
        Recommend 'Do not grant direct permissions for Project Valid Users for the environment.'        
        AllOf {
            # Loop through all the propeties of the first ACL
            $TargetObject.Acls[0].acesDictionary.psobject.Properties.GetEnumerator() | ForEach-Object {
                # Assert the property name does not end with -0-0-0-0-3 wich is the Project Valid Users group SID
                AnyOf {
                    $Assert.NotMatch($_.Value, "descriptor", "-0-0-0-0-3")
                    $Assert.HasFieldValue($_.Value, "allow", 1)
                }
            }
        }
}
