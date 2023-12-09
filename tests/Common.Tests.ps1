using module ../src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1
BeforeAll {
    # Dot source the Common.ps1 script
    . "$PSScriptRoot/../src/PSRule.Rules.AzureDevOps/Functions/Common.ps1"
}

Describe "Functions: Common.Tests" {
    Context " Connect-AzDevOps with a Personal Access Token" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        # It " The connection should be of type AzureDevOpsConnection" {
        #     $connection | Should -BeOfType [AzureDevOpsConnection]
        # }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }

        It " should run Get-AzDevOpsProjects" {
            $projects = Get-AzDevOpsProjects
            $projects | Should -Not -BeNullOrEmpty
        }
    }

    Context " Connect-AzDevOps with a Service Principal" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -ClientId $env:ADO_CLIENT_ID -ClientSecret $env:ADO_CLIENT_SECRET -TenantId $env:ADO_TENANT_ID -AuthType ServicePrincipal
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        # It " The connection should be of type AzureDevOpsConnection" {
        #     $connection | Should -BeOfType [AzureDevOpsConnection]
        # }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }

        It " should run Get-AzDevOpsProjects" {
            $projects = Get-AzDevOpsProjects
            $projects | Should -Not -BeNullOrEmpty
        }
    }

    Context " Connect-AzDevOps with a Service Principal and an expired token" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -ClientId $env:ADO_CLIENT_ID -ClientSecret $env:ADO_CLIENT_SECRET -TenantId $env:ADO_TENANT_ID -AuthType ServicePrincipal
            $script:connection.TokenExpires = [System.DateTime]::MinValue
            $projects = Get-AzDevOpsProjects
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }

        It " should run Get-AzDevOpsProjects" {
            $projects | Should -Not -BeNullOrEmpty
        }
    }

    Context " Connect-AzDevOps with a Service Principal and a wrong secret" {
        It " The operation should fail with a wrong secret" {
            { 
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -ClientId $env:ADO_CLIENT_ID -ClientSecret 'wrong' -TenantId $env:ADO_TENANT_ID -AuthType ServicePrincipal
            } | Should -Throw 
        }
    }

    Context " Connect-AzDevOps with a User Assigned Managed Identity" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -AuthType ManagedIdentity
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }

        It " should run Get-AzDevOpsProjects" {
            $projects = Get-AzDevOpsProjects
            $projects | Should -Not -BeNullOrEmpty
        }
    }

    Context " Connect-AzDevOps with a User Assigned Managed Identity and an expired token" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -AuthType ManagedIdentity
            $script:connection.TokenExpires = [System.DateTime]::MinValue
            $projects = Get-AzDevOpsProjects
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }

        It " should run Get-AzDevOpsProjects" {
            $projects | Should -Not -BeNullOrEmpty
        }
    }

    Context " Connect-AzDevOps with a System Assigned Managed Identity" {
        BeforeAll {
            Remove-Item Env:\ADO_MSI_CLIENT_ID
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -AuthType ManagedIdentity
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }
    }
    
    Context " Disconnect-AzDevOps" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            Disconnect-AzDevOps
            $connection = $script:connection
        }

        It " The connection should be null" {
            $connection | Should -BeNullOrEmpty
        }
    }

    Context " Get-AzDevOpsProjects without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsProjects
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsProjects" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $projects = Get-AzDevOpsProjects
        }

        It " The projects should not be null" {
            $projects | Should -Not -BeNullOrEmpty
        }

        It " The projects should be of type [PSCustomObject]" {
            $projects | Should -BeOfType [PSCustomObject]
        }

        It " The projects should have at least one project" {
            $projects.Count | Should -BeGreaterThan 0
        }

        It " The projects should have a project named $env:ADO_PROJECT" {
            $projects | Select -ExpandProperty name | Should -Contain $env:ADO_PROJECT
        }

        It " The operation should fail with a wrong Organization" {
            { 
                Connect-AzDevOps -Organization 'wrong' -PAT $env:ADO_PAT
                Get-AzDevOpsProjects -ErrorAction Stop
            } | Should -Throw 
        }

        It " The operation should fail with a wrong PAT" {
            { 
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT 'wrong'
                Get-AzDevOpsProjects -ErrorAction Stop
            } | Should -Throw 
        }
    }
}

AfterAll {
    
}
