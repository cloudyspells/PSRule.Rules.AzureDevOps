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
