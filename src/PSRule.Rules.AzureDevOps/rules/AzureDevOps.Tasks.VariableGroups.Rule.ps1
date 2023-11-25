# PSRule rule definitions for Azure DevOps Variable Groups

# Synopsis: A Variable Group should not contain secrets when not linked to a Key Vault
Rule 'Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets' `
    -Ref 'ADO-VG-001' `
    -Type 'Azure.DevOps.Tasks.VariableGroup' `
    -If { $TargetObject.type -eq 'Vsts' } `
    -Tag @{ release = 'GA'} `
    -Level Error {
        # Description 'Variable Groups should not contain secrets when not linked to a Key Vault.'
        Reason 'The Variable Group is not linked to a Key Vault and it contains secrets.'
        Recommend 'Consider backing the Variable Group with a Key Vault.'
        # Links 'https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks'
        $Assert.NotHasField($TargetObject, "variables[*].isSecret", $true)
}

# Synopsis: Variable groups should have a description
Rule 'Azure.DevOps.Tasks.VariableGroup.Description' `
    -Ref 'ADO-VG-002' `
    -Type 'Azure.DevOps.Tasks.VariableGroup' `
    -Tag @{ release = 'GA'} `
    -Level Information {
        # Description 'Variable groups should have a description.'
        Reason 'No description is configured for the variable group.'
        Recommend 'Add a description to the variable group to make it easier to understand its purpose.'
        $Assert.HasField($TargetObject, "description", $true)
        $Assert.HasFieldValue($TargetObject, "description")
}

# Synopsis: Variable groups should not contain plain text secrets
Rule 'Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets' `
    -Ref 'ADO-VG-003' `
    -Type 'Azure.DevOps.Tasks.VariableGroup' `
    -Tag @{ release = 'GA'} `
    -Level Error {
        # Description 'Variable groups should not contain plain text secrets.'
        Reason 'The variable group contains a plain text secret.'
        Recommend 'Consider using a secret variable in a keyvault instead.'

        # None of the variable should match the following regex patterns or the value should be null
        $TargetObject.variables.psobject.Properties.GetEnumerator() | ForEach-Object {
            If($null -ne $_.Value.value) {
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
