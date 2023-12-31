BeforeAll {
    $rootPath = $PWD;
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force;
}

Describe "Azure.DevOps.Group" {
    Context " Get-AzDevOpsGroups without a connection" {
        It " Should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsGroups -Project $env:ADO_PROJECT
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first."
        }
    }

    Context " Get-AzDevOpsGroups" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $groups = Get-AzDevOpsGroups -Project $env:ADO_PROJECT
        }

        It " Should return a list of groups" {
            $groups | Should -Not -BeNullOrEmpty
        }

        It " Should return a list of groups with a display name" {
            $groups.displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroups with a ReadOnly PAT" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_READONLY
            $groups = Get-AzDevOpsGroups -Project $env:ADO_PROJECT
        }

        It " Should return a list of groups" {
            $groups | Should -Not -BeNullOrEmpty
        }

        It " Should return a list of groups with a display name" {
            $groups.displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroups with a FineGrained PAT" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_FINEGRAINED
            $groups = Get-AzDevOpsGroups -Project $env:ADO_PROJECT
        }

        It " Should return a list of groups" {
            $groups | Should -Not -BeNullOrEmpty
        }

        It " Should return a list of groups with a display name" {
            $groups.displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroups with wrong PAT or Organization" {
        It " Should throw an error with a wrong PAT" {
            { 
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrongPAT"
                Get-AzDevOpsGroups -Project $env:ADO_PROJECT
            } | Should -Throw
        }

        It " Should throw an error with a wrong Organization" {
            { 
                Connect-AzDevOps -Organization "wrongOrganization" -PAT $env:ADO_PAT
                Get-AzDevOpsGroups -Project $env:ADO_PROJECT
            } | Should -Throw
        }
    }

    Context " Get-AzDevOpsGroupDetails without a connection" {
        It " Should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsGroupDetails -Group "TestGroup"
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first."
        }
    }

    Context " Get-AzDevOpsGroupDetails with a connection" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $group = Get-AzDevOpsGroups -Project $env:ADO_PROJECT | Where-Object { $_.displayName -eq "Project Administrators" }
            $groupDetails = Get-AzDevOpsGroupDetails -Group $group
        }

        It " Should return a group" {
            $groupDetails | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with a display name" {
            $groupDetails.displayName | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members" {
            $groupDetails.members | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members with a display name" {
            $groupDetails.members[0].displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroupDetails with a ReadOnly PAT" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_READONLY
            $group = Get-AzDevOpsGroups -Project $env:ADO_PROJECT | Where-Object { $_.displayName -eq "Project Administrators" }
            $groupDetails = Get-AzDevOpsGroupDetails -Group $group
        }

        It " Should return a group" {
            $groupDetails | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with a display name" {
            $groupDetails.displayName | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members" {
            $groupDetails.members | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members with a display name" {
            $groupDetails.members[0].displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroupDetails with a FineGrained PAT" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_FINEGRAINED
            $group = Get-AzDevOpsGroups -Project $env:ADO_PROJECT | Where-Object { $_.displayName -eq "Project Administrators" }
            $groupDetails = Get-AzDevOpsGroupDetails -Group $group
        }

        It " Should return a group" {
            $groupDetails | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with a display name" {
            $groupDetails.displayName | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members" {
            $groupDetails.members | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members with a display name" {
            $groupDetails.members[0].displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroupDetails with wrong PAT or Organization" {
        It " Should throw an error with a wrong PAT" {
            { 
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
                $group = Get-AzDevOpsGroups -Project $env:ADO_PROJECT | Where-Object { $_.displayName -eq "Project Administrators" }
                Disconnect-AzDevOps
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrongPAT"
                Get-AzDevOpsGroupDetails -Group $group
            } | Should -Throw "Failed to get group memberOf details from Azure DevOps"
        }
    }

    Context " Get-AzDevOpsGroupDetails with a groups object containing bad links" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $group = Get-AzDevOpsGroups -Project $env:ADO_PROJECT | Where-Object { $_.displayName -eq "Project Administrators" }
        }

        It " Should throw an error with a bad link for memberships" {
            { 
                $group._links.memberships.href = "https://dev.azure.com/organization/project/_apis/graph/groups/00000000-0000-0000-0000-000000000000?api-version=6.0-preview.1"
                Get-AzDevOpsGroupDetails -Group $group
            } | Should -Throw "Failed to get group memberOf details from Azure DevOps"
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Export-AzDevOpsGroups without a connection" {
        It " Should throw an error" {
            { 
                Disconnect-AzDevOps
                Export-AzDevOpsGroups -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first."
        }
    }

    Context " Export-AzDevOpsGroups" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            Export-AzDevOpsGroups -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
        }

        It " Should export a file" {
            $file = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter "groups.ado.json"
            $file | Should -Not -BeNullOrEmpty
        }

        It " Should export a file with content" {
            $file = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter "groups.ado.json"
            $file | Select-String -Pattern "displayName" | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Export-AzDevOpsGroups with a ReadOnly PAT" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_READONLY
            Export-AzDevOpsGroups -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
        }

        It " Should export a file" {
            $file = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter "groups.ado.json"
            $file | Should -Not -BeNullOrEmpty
        }

        It " Should export a file with content" {
            $file = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter "groups.ado.json"
            $file | Select-String -Pattern "displayName" | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Export-AzDevOpsGroups with a FineGrained PAT" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_FINEGRAINED
            Export-AzDevOpsGroups -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
        }

        It " Should export a file" {
            $file = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter "groups.ado.json"
            $file | Should -Not -BeNullOrEmpty
        }

        It " Should export a file with content" {
            $file = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter "groups.ado.json"
            $file | Select-String -Pattern "displayName" | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Export-AzDevOpsGroups with wrong PAT or Organization" {
        It " Should throw an error with a wrong PAT" {
            { 
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrongPAT"
                Export-AzDevOpsGroups -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw
        }

        It " Should throw an error with a wrong Organization" {
            { 
                Connect-AzDevOps -Organization "wrongOrganization" -PAT $env:ADO_PAT
                Export-AzDevOpsGroups -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw
        }
    }

    Context " Export-AzDevOpsGroups -PassThru" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $groups = Export-AzDevOpsGroups -Project $env:ADO_PROJECT -PassThru
            $ruleResult = $groups | Invoke-PSRule -Module @('PSRule.Rules.AzureDevOps') -Culture en
        }

        It " Should return a list of groups" {
            $groups | Should -Not -BeNullOrEmpty
        }

        It " Should return a list of groups with an ObjectType property" {
            $groups[0].ObjectType | Should -Not -BeNullOrEmpty
        }

        It " Should return a list of groups with an ObjectName property" {
            $groups[0].ObjectName | Should -Not -BeNullOrEmpty
        }

        It " The output should have results with Invoke-PSRule" {
            $ruleResult | Should -Not -BeNullOrEmpty
        }

        It " The output should have results with Invoke-PSRule that are of type [PSRule.Rules.RuleRecord]" {
            $ruleResult[0] | Should -BeOfType [PSRule.Rules.RuleRecord]
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }
}

AfterAll {
    Disconnect-AzDevOps
    Remove-Module -Name PSRule.Rules.AzureDevOps -Force
}