[CmdletBinding()]
param ()

BeforeAll {
    # Setup error handling
    $ErrorActionPreference = 'Stop';
    Set-StrictMode -Version latest;

    if ($Env:SYSTEM_DEBUG -eq 'true') {
        $VerbosePreference = 'Continue';
    }

    # Setup tests paths
    $rootPath = $PWD;
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps') -Force;
    $here = (Resolve-Path $PSScriptRoot).Path;

     # Create tempory test output folder and store path
    $outPath = New-Item -Path (Join-Path -Path $here -ChildPath 'out') -ItemType Directory -Force;
    $outPath = $outPath.FullName;

    # Export all Azure DevOps rule data for project 'psrule-fail-project' to output folder
    Export-AzDevOpsRuleData -PAT $env:ADO_PAT -Project $env:ADO_PROJECT -Organization $env:ADO_ORGANIZATION -OutputPath $outPath
    $ruleResult = Invoke-PSRule -InputPath "$($outPath)\" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en
}

Describe 'AzureDevOps ' {
    Context 'Base rules ' {
        It 'Should contain 21 rules' {
            $rules = Get-PSRule -Module PSRule.Rules.AzureDevOps;
            $rules.Count | Should -Be 21;
        }
    }

    Context 'AzureDevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets ' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

    }

    Context 'AzureDevOps.Tasks.VariableGroup.Description ' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.Description' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.Description' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Pipelines.Environments.ProductionHumanApproval' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionHumanApproval' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionHumanApproval' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Pipelines.Environments.Description' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.Description' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.Description' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Repos.HasBranchPolicy' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasBranchPolicy' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasBranchPolicy' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyIsEnabled' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyIsEnabled' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyIsEnabled' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyResetVotes' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyResetVotes' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyResetVotes' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Repos.Readme' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Repos.License' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyCommentResolution' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyCommentResolution' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyCommentResolution' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyMergeStrategy' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMergeStrategy' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMergeStrategy' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.ServiceConnections.Description' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.ServiceConnections.Scope' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 1;
        }
    }
}