# Synopsis: Release pipeline production environments should be protected by approval.
Rule 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' `
    -Ref 'ADO-RD-001' `
    -Type 'Azure.DevOps.Pipelines.Releases.Definition' `
    -If { $null -ne ($TargetObject.environments | Where-Object { $_.name -imatch "prd|prod|live|master|main"}) } `
    -Tag @{ release = 'GA'} `
    -Level Error {
        # Description 'Release pipeline production environments should be protected by approval.'
        Reason 'The release pipeline contains a production environment that is not protected by approval.'
        Recommend 'Consider adding approval to the production environment.'
        # Links 'https://docs.microsoft.com/en-us/azure/devops/pipelines/release/approvals/?view=azure-devops'
        $prodEnvironments = $TargetObject.environments | Where-Object { $_.name -imatch "prd|prod|live|master|main"}
        $prodEnvironments | ForEach-Object {
            $Assert.HasField($_, "preDeployApprovals", $true)
            $Assert.HasField($_.preDeployApprovals, "approvals[0].approver", $true)
            $Assert.HasFieldValue($_.preDeployApprovals, "approvals[0].approver.displayName")
            $Assert.GreaterOrEqual($_.preDeployApprovals.approvals, "count", $Configuration.GetValueOrDefault('releaseMinimumProductionApproverCount', 1))
        }
}

# Synopsis: Users should not be able to approve their own release.
Rule 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' `
    -Ref 'ADO-RD-002' `
    -Type 'Azure.DevOps.Pipelines.Releases.Definition' `
    -If { $null -ne ($TargetObject.environments | Where-Object { $_.name -imatch "prd|prod|live|master|main"}) } `
    -Tag @{ release = 'GA'} `
    -Level Error {
        # Description 'Users should not be able to approve their own release.'
        Reason 'The release pipeline contains a production where users can approve their own releases.'
        Recommend 'Consider not allowing user to approve their own work to the production environment.'
        # Links 'https://docs.microsoft.com/en-us/azure/devops/pipelines/release/approvals/?view=azure-devops'
        $prodEnvironments = $TargetObject.environments | Where-Object { $_.name -imatch "prd|prod|live|master|main"}
        $prodEnvironments | ForEach-Object {
            $Assert.HasField($_, "preDeployApprovals", $true)
            $Assert.HasField($_.preDeployApprovals, "approvalOptions.releaseCreatorCanBeApprover", $true)
            $Assert.HasFieldValue($_.preDeployApprovals, "approvalOptions.releaseCreatorCanBeApprover", $false)
        }
}

# Synopsis: Release pipeline should not inherit permissions from the project.
Rule 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' `
    -Ref 'ADO-RD-003' `
    -Type 'Azure.DevOps.Pipelines.Releases.Definition' `
    -Tag @{ release = 'GA'} `
    -If { "Acls" -in $TargetObject.psobject.Properties.Name } `
    -Level Error {
        # Description 'Release pipeline should not inherit permissions from the project.'
        Reason 'The release pipeline inherits permissions from the project.'
        Recommend 'Consider removing inherited permissions'
        # Links 'https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions'
        AllOf {
            $Assert.HasField($TargetObject, "Acls.inheritPermissions", $true)
            $Assert.HasFieldValue($TargetObject, "Acls.inheritPermissions", $false)
        }
}

# Synopsis: Release pipeline should not have plain text secrets in variables
Rule 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' `
    -Ref 'ADO-RD-004' `
    -Type 'Azure.DevOps.Pipelines.Releases.Definition' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'Release pipeline should not have plain text secrets in variables'
        Reason 'The release pipeline contains a variable with a secret as plain text.'
        Recommend 'Consider using a secret variable for your pipeline'
        # Links 'https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch#secret-variables'
        AllOf {
            $TargetObject.variables.psobject.Properties | ForEach-Object {
                # Check if the variable matches the regex patterns
                if ($null -ne $_.Value.value) {
                    AllOf {
                        $Assert.HasFieldValue($_, "Value.value")
                        # $Assert.NotMatch($_, "value", "^(?=\D*\d)(?=[^a-z]*[a-z])(?=[^A-Z]*[A-Z])(?=(\w*\W|\w*))[0-9\Wa-zA-Z]{7,20}$")
                        $Assert.NotMatch($_, "Value.value", "((P|p)assword|pwd)\s*=\s*\w+;?")
                        # SQL conn strings
                        $Assert.NotMatch($_, "Value.value", "(?# To match SQL/MySQL conn strings.)^Data Source=[^;]+;Initial Catalog=[^;]+;User ID=[^;]+;Password=[^;]+;$")
                        $Assert.NotMatch($_, "Value.value", "(?# To match SQL/MySQL conn strings.)((U|u)ser(Id)?|uid)\s*=\s*\w+;?")
                        # Azure storage keys, connection strings, and SAS
                        $Assert.NotMatch($_, "Value.value", "(?# To match Azure storage keys.)^[A-Za-z0-9/+]{86}==$")
                        $Assert.NotMatch($_, "Value.value", "(?# To match Azure storage connection strings.)DefaultEndpointsProtocol=https;AccountName=\w+;AccountKey=[A-Za-z0-9/+]{86}==$")
                        $Assert.NotMatch($_, "Value.value", "(?# To match storage SAS.)([^?]*\?sv=)[^&]+(&s[a-z]=[^&]+){4}")
                        # Azure AD client secrets
                        $Assert.NotMatch($_, "Value.value", "(?# To match Azure AD client secrets.)^[A-Za-z0-9-._~]{32}$")
                        # Azure DevOps PATs
                        $Assert.NotMatch($_, "Value.value", "(?# To match ADO PATs.)^[a-z2-7]{52}$")
                        # Azure Event Hub connection strings
                        $Assert.NotMatch($_, "Value.value", "(?# To match Azure Event Hub connection strings.)Endpoint=sb://[^/]+\.servicebus\.windows\.net/;SharedAccessKeyName=[^;]+;SharedAccessKey=[A-Za-z0-9+/=]{44}==$")
                        # Azure Service Bus connection strings
                        $Assert.NotMatch($_, "Value.value", "(?# To match Azure Service Bus connection strings.)Endpoint=sb://[^/]+\.servicebus\.windows\.net/;SharedAccessKeyName=[^;]+;SharedAccessKey=[A-Za-z0-9+/=]{44}==$")
                        # Azure Service Bus SAS
                        $Assert.NotMatch($_, "Value.value", "(?# To match Azure Service Bus SAS.)((S|s)hared(A|a)ccess(S|s)ignature|sas)\s*=\s*\w+;?")
                        # Azure OpenAI API keys
                        $Assert.NotMatch($_, "Value.value", "(?# To match Azure OpenAI API keys.)^sk-[a-zA-Z0-9]{32}$")
                        # Azure Cognitive Services API keys
                        $Assert.NotMatch($_, "Value.value", "(?# To match Azure Cognitive Services API keys.)^[a-zA-Z0-9]{32}$")

                        # AWS access keys
                        $Assert.NotMatch($_, "Value.value", "(?# To match AWS access keys.)^AKIA[0-9A-Z]{16}$")
                        # AWS secret keys
                        $Assert.NotMatch($_, "Value.value", "(?# To match AWS secret keys.)^[A-Za-z0-9/+=]{40}$")

                        # MongoDB connection strings
                        $Assert.NotMatch($_, "Value.value", "(?# To match MongoDB connection strings.)mongodb://[^:]+:[^@]+@[^/]+/[^?]+(\?[^&]+(&[^&]+)*)?$")
                        # MongoDB SRV connection strings
                        $Assert.NotMatch($_, "Value.value", "(?# To match MongoDB SRV connection strings.)mongodb\+srv://[^:]+:[^@]+@[^/]+/[^?]+(\?[^&]+(&[^&]+)*)?$")

                        # Redis connection strings
                        $Assert.NotMatch($_, "Value.value", "(?# To match Redis connection strings with password.)^redis://:[^@]+@[^:]+:\d+/?$")
                        # Redis SSL connection strings
                        $Assert.NotMatch($_, "Value.value", "(?# To match Redis SSL connection strings.)^rediss://[^:]+:[^@]+@[^:]+:\d+/?$")

                        # MySQL connection strings
                        $Assert.NotMatch($_, "Value.value", "(?# To match MySQL connection strings.)^Server=[^;]+;Port=\d+;Database=[^;]+;Uid=[^;]+;Pwd=[^;]+;$")

                        # PostgreSQL connection strings
                        $Assert.NotMatch($_, "Value.value", "(?# To match PostgreSQL connection strings.)^Server=[^;]+;Port=\d+;Database=[^;]+;User Id=[^;]+;Password=[^;]+;$")
                        
                        # PEM files
                        $Assert.NotMatch($_, "Value.value", "(?# To match PEM files.)^-----BEGIN [A-Z ]+-----\r?\n([A-Za-z0-9+/=]{64}\r?\n)*-----END [A-Z ]+-----\r?\n?$")
                    }
                } else {
                    $Assert.Null($_, "Value.value")
                }
            }

            # Loop through all the environments
            $TargetObject.environments | ForEach-Object {
                # Loop through all the environment variables
                $_.variables.psobject.Properties | ForEach-Object {
                    # Check if the variable matches the regex patterns
                    if ($null -ne $_.Value.value) {
                        AllOf {
                            $Assert.HasFieldValue($_, "Value.value")
                            # $Assert.NotMatch($_, "value", "^(?=\D*\d)(?=[^a-z]*[a-z])(?=[^A-Z]*[A-Z])(?=(\w*\W|\w*))[0-9\Wa-zA-Z]{7,20}$")
                            $Assert.NotMatch($_, "Value.value", "((P|p)assword|pwd)\s*=\s*\w+;?")
                            # SQL conn strings
                            $Assert.NotMatch($_, "Value.value", "(?# To match SQL/MySQL conn strings.)^Data Source=[^;]+;Initial Catalog=[^;]+;User ID=[^;]+;Password=[^;]+;$")
                            $Assert.NotMatch($_, "Value.value", "(?# To match SQL/MySQL conn strings.)((U|u)ser(Id)?|uid)\s*=\s*\w+;?")
                            # Azure storage keys, connection strings, and SAS
                            $Assert.NotMatch($_, "Value.value", "(?# To match Azure storage keys.)^[A-Za-z0-9/+]{86}==$")
                            $Assert.NotMatch($_, "Value.value", "(?# To match Azure storage connection strings.)DefaultEndpointsProtocol=https;AccountName=\w+;AccountKey=[A-Za-z0-9/+]{86}==$")
                            $Assert.NotMatch($_, "Value.value", "(?# To match storage SAS.)([^?]*\?sv=)[^&]+(&s[a-z]=[^&]+){4}")
                            # Azure AD client secrets
                            $Assert.NotMatch($_, "Value.value", "(?# To match Azure AD client secrets.)^[A-Za-z0-9-._~]{32}$")
                            # Azure DevOps PATs
                            $Assert.NotMatch($_, "Value.value", "(?# To match ADO PATs.)^[a-z2-7]{52}$")
                            # Azure Event Hub connection strings
                            $Assert.NotMatch($_, "Value.value", "(?# To match Azure Event Hub connection strings.)Endpoint=sb://[^/]+\.servicebus\.windows\.net/;SharedAccessKeyName=[^;]+;SharedAccessKey=[A-Za-z0-9+/=]{44}==$")
                            # Azure Service Bus connection strings
                            $Assert.NotMatch($_, "Value.value", "(?# To match Azure Service Bus connection strings.)Endpoint=sb://[^/]+\.servicebus\.windows\.net/;SharedAccessKeyName=[^;]+;SharedAccessKey=[A-Za-z0-9+/=]{44}==$")
                            # Azure Service Bus SAS
                            $Assert.NotMatch($_, "Value.value", "(?# To match Azure Service Bus SAS.)((S|s)hared(A|a)ccess(S|s)ignature|sas)\s*=\s*\w+;?")
                            # Azure OpenAI API keys
                            $Assert.NotMatch($_, "Value.value", "(?# To match Azure OpenAI API keys.)^sk-[a-zA-Z0-9]{32}$")
                            # Azure Cognitive Services API keys
                            $Assert.NotMatch($_, "Value.value", "(?# To match Azure Cognitive Services API keys.)^[a-zA-Z0-9]{32}$")

                            # AWS access keys
                            $Assert.NotMatch($_, "Value.value", "(?# To match AWS access keys.)^AKIA[0-9A-Z]{16}$")
                            # AWS secret keys
                            $Assert.NotMatch($_, "Value.value", "(?# To match AWS secret keys.)^[A-Za-z0-9/+=]{40}$")

                            # MongoDB connection strings
                            $Assert.NotMatch($_, "Value.value", "(?# To match MongoDB connection strings.)mongodb://[^:]+:[^@]+@[^/]+/[^?]+(\?[^&]+(&[^&]+)*)?$")
                            # MongoDB SRV connection strings
                            $Assert.NotMatch($_, "Value.value", "(?# To match MongoDB SRV connection strings.)mongodb\+srv://[^:]+:[^@]+@[^/]+/[^?]+(\?[^&]+(&[^&]+)*)?$")

                            # Redis connection strings
                            $Assert.NotMatch($_, "Value.value", "(?# To match Redis connection strings with password.)^redis://:[^@]+@[^:]+:\d+/?$")
                            # Redis SSL connection strings
                            $Assert.NotMatch($_, "Value.value", "(?# To match Redis SSL connection strings.)^rediss://[^:]+:[^@]+@[^:]+:\d+/?$")

                            # MySQL connection strings
                            $Assert.NotMatch($_, "Value.value", "(?# To match MySQL connection strings.)^Server=[^;]+;Port=\d+;Database=[^;]+;Uid=[^;]+;Pwd=[^;]+;$")

                            # PostgreSQL connection strings
                            $Assert.NotMatch($_, "Value.value", "(?# To match PostgreSQL connection strings.)^Server=[^;]+;Port=\d+;Database=[^;]+;User Id=[^;]+;Password=[^;]+;$")
                            
                            # PEM files
                            $Assert.NotMatch($_, "Value.value", "(?# To match PEM files.)^-----BEGIN [A-Z ]+-----\r?\n([A-Za-z0-9+/=]{64}\r?\n)*-----END [A-Z ]+-----\r?\n?$")
                        }
                    } else {
                        $Assert.Null($_, "Value.value")
                    }
                }
            }
            # If there were no variables, then the test passes
            $Assert.HasField($TargetObject, "variables", $true)
    }
}

# Synposis: Release definitions should not have direct permissions for Project Valid Users
Rule 'Azure.DevOps.Pipelines.Releases.Definition.ProjectValidUsers' `
    -Ref 'ADO-RD-005' `
    -Type 'Azure.DevOps.Pipelines.Releases.Definition' `
    -If { $null -ne $TargetObject.Acls } `
    -Tag @{ release = 'GA' } `
    -Level Warning {
        # Description 'Release definitions should not have direct permissions for Project Valid Users.'
        Reason 'The release definition has direct permissions for Project Valid Users.'
        Recommend 'Do not grant direct permissions for Project Valid Users for the release definition.'        
        AllOf {
            # Loop through all the propeties of the first ACL
            $TargetObject.Acls.acesDictionary.psobject.Properties.GetEnumerator() | ForEach-Object {
                # Assert the property name does not end with -0-0-0-0-3 wich is the Project Valid Users group SID
                AnyOf {
                    $Assert.NotMatch($_.Value, "descriptor", "-0-0-0-0-3")
                    $Assert.HasFieldValue($_.Value, "allow", 1)
                }
            }
        }
}
