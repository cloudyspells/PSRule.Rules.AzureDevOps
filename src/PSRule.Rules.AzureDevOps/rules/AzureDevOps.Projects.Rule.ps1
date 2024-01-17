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

# Synposis: Project level pipeline acl should not have custom permissions for Project Valid Users
Rule 'Azure.DevOps.Project.MainPipelineAcl.ProjectValidUsers' `
    -Ref 'ADO-PRJ-002' `
    -Type 'Azure.DevOps.Project' `
    -If { $null -ne $TargetObject.ProjectAcls.Pipelines[0] } `
    -Tag @{ release = 'GA' } `
    -Level Warning {
        # Description 'Project level pipeline acl should not have custom permissions for Project Valid Users.'
        Reason 'The project level pipelines access control list has custom permissions for Project Valid Users.'
        Recommend 'Do not grant custom permissions for Project Valid Users in the project main pipelines access control list.'
        AllOf {
            # Loop through all the properties of the first ACL
            $TargetObject.ProjectAcls.Pipelines[0].acesDictionary.psobject.Properties.GetEnumerator() | ForEach-Object {
                # Assert the property name does not end with -0-0-0-0-3 wich is the Project Valid Users group SID
                # or else does not have allow set to something different than 1
                AnyOf {
                    $Assert.NotMatch($_.Value, "descriptor", "-0-0-0-0-3")
                    $Assert.HasFieldValue($_.Value, "allow", 1)
                }
            }
        }
}

# Synposis: Project level service connection acl should not have custom permissions for Project Valid Users
Rule 'Azure.DevOps.Project.MainServiceConnectionAcl.ProjectValidUsers' `
    -Ref 'ADO-PRJ-003' `
    -Type 'Azure.DevOps.Project' `
    -If { $null -ne $TargetObject.ProjectAcls.ServiceConnections[0] } `
    -Tag @{ release = 'GA' } `
    -Level Warning {
        # Description 'Project level service connection acl should not have custom permissions for Project Valid Users.'
        Reason 'The project level service connection access control list has custom permissions for Project Valid Users.'
        Recommend 'Do not grant custom permissions for Project Valid Users in the project main service connection access control list.'
        AllOf {
            # Loop through all the properties of the first ACL
            $TargetObject.ProjectAcls.ServiceConnections[0].acesDictionary.psobject.Properties.GetEnumerator() | ForEach-Object {
                # Assert the property name does not end with -0-0-0-0-3 wich is the Project Valid Users group SID
                # or else does not have allow set to something different than 1
                AnyOf {
                    $Assert.NotMatch($_.Value, "descriptor", "-0-0-0-0-3")
                    $Assert.HasFieldValue($_.Value, "allow", 16)
                }
            }
        }
}

# Synposis: Project level repositories acl should not have custom permissions for Project Valid Users
Rule 'Azure.DevOps.Project.MainRepositoryAcl.ProjectValidUsers' `
    -Ref 'ADO-PRJ-004' `
    -Type 'Azure.DevOps.Project' `
    -If { $null -ne $TargetObject.ProjectAcls.Repositories[0] } `
    -Tag @{ release = 'GA' } `
    -Level Warning {
        # Description 'Project level repositories acl should not have custom permissions for Project Valid Users.'
        Reason 'The project level repositories access control list has custom permissions for Project Valid Users.'
        Recommend 'Do not grant custom permissions for Project Valid Users in the project main repositories access control list.'
        AllOf {
            # Loop through all the properties of the first ACL
            $TargetObject.ProjectAcls.Repositories[0].acesDictionary.psobject.Properties.GetEnumerator() | ForEach-Object {
                # Assert the property name does not end with -0-0-0-0-3 wich is the Project Valid Users group SID
                # or else does not have allow set to something different than 1
                AnyOf {
                    $Assert.NotMatch($_.Value, "descriptor", "-0-0-0-0-3")
                    $Assert.HasFieldValue($_.Value, "allow", 2)
                }
            }
        }
}

# Synposis: Project level environments acl should not have custom permissions for Project Valid Users
Rule 'Azure.DevOps.Project.MainEnvironmentAcl.ProjectValidUsers' `
    -Ref 'ADO-PRJ-005' `
    -Type 'Azure.DevOps.Project' `
    -If { $null -ne $TargetObject.ProjectAcls.Environments[0] } `
    -Tag @{ release = 'GA' } `
    -Level Warning {
        # Description 'Project level environments acl should not have custom permissions for Project Valid Users.'
        Reason 'The project level environments access control list has custom permissions for Project Valid Users.'
        Recommend 'Do not grant custom permissions for Project Valid Users in the project main environments access control list.'
        AllOf {
            # Loop through all the properties of the first ACL
            $TargetObject.ProjectAcls.Environments[0].acesDictionary.psobject.Properties.GetEnumerator() | ForEach-Object {
                # Assert the property name does not end with -0-0-0-0-3 wich is the Project Valid Users group SID
                # or else does not have allow set to something different than 1
                AnyOf {
                    $Assert.NotMatch($_.Value, "descriptor", "-0-0-0-0-3")
                    $Assert.HasFieldValue($_.Value, "allow", 1)
                }
            }
        }
}

# Synposis: Project level release definitions acl should not have custom permissions for Project Valid Users
Rule 'Azure.DevOps.Project.MainReleaseDefinitionAcl.ProjectValidUsers' `
    -Ref 'ADO-PRJ-006' `
    -Type 'Azure.DevOps.Project' `
    -If { $null -ne $TargetObject.ProjectAcls.ReleaseDefinitions[0] } `
    -Tag @{ release = 'GA' } `
    -Level Warning {
        # Description 'Project level release definitions acl should not have custom permissions for Project Valid Users.'
        Reason 'The project level release definitions access control list has custom permissions for Project Valid Users.'
        Recommend 'Do not grant custom permissions for Project Valid Users in the project main release definitions access control list.'
        AllOf {
            # Loop through all the properties of the first ACL
            $TargetObject.ProjectAcls.ReleaseDefinitions[0].acesDictionary.psobject.Properties.GetEnumerator() | ForEach-Object {
                # Assert the property name does not end with -0-0-0-0-3 wich is the Project Valid Users group SID
                # or else does not have allow set to something different than 1
                AnyOf {
                    $Assert.NotMatch($_.Value, "descriptor", "-0-0-0-0-3")
                    $Assert.HasFieldValue($_.Value, "allow", 1)
                }
            }
        }
}

# Synposis: Project level variable groups acl should not have custom permissions for Project Valid Users
Rule 'Azure.DevOps.Project.MainVariableGroupAcl.ProjectValidUsers' `
    -Ref 'ADO-PRJ-007' `
    -Type 'Azure.DevOps.Project' `
    -If { $null -ne $TargetObject.ProjectAcls.VariableGroups[0] } `
    -Tag @{ release = 'GA' } `
    -Level Warning {
        # Description 'Project level variable groups acl should not have custom permissions for Project Valid Users.'
        Reason 'The project level variable groups access control list has custom permissions for Project Valid Users.'
        Recommend 'Do not grant custom permissions for Project Valid Users in the project main variable groups access control list.'
        AllOf {
            # Loop through all the properties of the first ACL
            $TargetObject.ProjectAcls.VariableGroups[0].acesDictionary.psobject.Properties.GetEnumerator() | ForEach-Object {
                # Assert the property name does not end with -0-0-0-0-3 wich is the Project Valid Users group SID
                # or else does not have allow set to something different than 1
                AnyOf {
                    $Assert.NotMatch($_.Value, "descriptor", "-0-0-0-0-3")
                    $Assert.HasFieldValue($_.Value, "allow", 1)
                }
            }
        }
}