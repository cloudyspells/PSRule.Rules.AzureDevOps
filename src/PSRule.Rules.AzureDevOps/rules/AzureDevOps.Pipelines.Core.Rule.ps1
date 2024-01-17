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
    -If { "Acls" -in $TargetObject.psobject.Properties.Name } `
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

# Synopsis: GUI Designer pipelines should not have secrets as plain text variables
Rule 'Azure.DevOps.Pipelines.Core.NoPlainTextSecrets' `
    -Ref 'ADO-PL-003' `
    -Type 'Azure.DevOps.Pipeline' `
    -If { $TargetObject.configuration.type -eq 'designerJson' } `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description "GUI Designer pipelines should not have secrets as plain text variables"
        Reason "The pipeline is using a secret as a plain text variable"
        Recommend "Consider using a secret variable for your pipeline"
        # Links "https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch#secret-variables"
        AllOf {
            # Iterate over all properties of the variables object
            $TargetObject.configuration.designerJson.variables.psobject.Properties | ForEach-Object {
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
}

# Synposis: Pipelines should not have direct permissions for Project Valid Users
Rule 'Azure.DevOps.Pipelines.Core.ProjectValidUsers' `
    -Ref 'ADO-PL-004' `
    -Type 'Azure.DevOps.Pipeline' `
    -If { $null -ne $TargetObject.Acls } `
    -Tag @{ release = 'GA' } `
    -Level Warning {
        # Description 'Pipelines should not have direct permissions for Project Valid Users.'
        Reason 'The pipeline has direct permissions for Project Valid Users.'
        Recommend 'Do not grant direct permissions for Project Valid Users for the pipeline.'
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