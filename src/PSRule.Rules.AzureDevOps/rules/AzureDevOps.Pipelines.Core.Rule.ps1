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
                        # SQL/MySQL conn strings
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
                    }
                } else {
                    $Assert.Null($_, "Value.value")
                }
            }
        }
}