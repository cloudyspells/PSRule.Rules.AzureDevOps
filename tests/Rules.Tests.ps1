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
    # $rootPath = $PWD;
    $rootPath = $env:GITHUB_WORKSPACE
    $ourModule = (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps')

    Import-Module -Name $ourModule -Force;
    $here = (Resolve-Path $PSScriptRoot).Path;

     # Create tempory test output folder and store path
    $outPath = New-Item -Path (Join-Path -Path $here -ChildPath 'out') -ItemType Directory -Force;
    $outPath = $outPath.FullName;

    # Export all Azure DevOps rule data for project 'psrule-fail-project' to output folder
    Export-AzDevOpsRuleData -PAT $env:ADO_PAT -Project $env:ADO_PROJECT -Organization $env:ADO_ORGANIZATION -OutputPath $outPath
    $ruleResult = Invoke-PSRule -InputPath "$($outPath)/" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en
    $noExtraLicenseBaselineResult = Invoke-PSRule -InputPath "$($outPath)/" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en -Baseline Baseline.NoExtraLicense

    # Create a temporary test output folder for tests with the ReadOnly TokenType
    $outPathReadOnly = New-Item -Path (Join-Path -Path $here -ChildPath 'outReadOnly') -ItemType Directory -Force;
    $outPathReadOnly = $outPathReadOnly.FullName;

    # Export all Azure DevOps rule data for project 'psrule-fail-project' to ReadOnly output folder
    Export-AzDevOpsRuleData -PAT $env:ADO_PAT_READONLY -TokenType ReadOnly -Project $env:ADO_PROJECT -Organization $env:ADO_ORGANIZATION -OutputPath $outPathReadOnly
    $ruleResultReadOnly = Invoke-PSRule -InputPath "$($outPathReadOnly)/" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en

    # Create a temporary test output folder for tests with the FineGrained TokenType
    $outPathFineGrained = New-Item -Path (Join-Path -Path $here -ChildPath 'outFineGrained') -ItemType Directory -Force;
    $outPathFineGrained = $outPathFineGrained.FullName;

    # Export all Azure DevOps rule data for project 'psrule-fail-project' to FineGrained output folder
    Export-AzDevOpsRuleData -PAT $env:ADO_PAT_FINEGRAINED -TokenType FineGrained -Project $env:ADO_PROJECT -Organization $env:ADO_ORGANIZATION -OutputPath $outPathFineGrained
    $ruleResultFineGrained = Invoke-PSRule -InputPath "$($outPathFineGrained)/" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en
}

Describe 'AzureDevOps ' {
    Context 'Base rules ' {
        It 'Should contain 45 rules' {
            $rules = Get-PSRule -Module PSRule.Rules.AzureDevOps;
            $rules.Count | Should -Be 45;
        }
    }

    Context 'AzureDevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets ' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'AzureDevOps.Tasks.VariableGroup.Description ' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.Description' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.Description' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have the same results with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.Description' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.Description' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have the same results with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.Description' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.Description' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Tasks.VariableGroup.Description.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have the same results with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have the same results with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest' -and $_.Outcome -eq 'Fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest' -and $_.Outcome -eq 'Pass' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have the same results with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest' -and $_.Outcome -eq 'Fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest' -and $_.Outcome -eq 'Pass' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have the same results with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest' -and $_.Outcome -eq 'Fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest' -and $_.Outcome -eq 'Pass' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName' -and $_.Outcome -eq 'Fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName' -and $_.Outcome -eq 'Pass' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have the same results with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName' -and $_.Outcome -eq 'Fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName' -and $_.Outcome -eq 'Pass' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have the same results with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName' -and $_.Outcome -eq 'Fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName' -and $_.Outcome -eq 'Pass' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should not be in the output for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 0;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should have the same result as default for FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionCheckProtection' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Environments.ProductionCheckProtection.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Environments.ProductionHumanApproval' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionHumanApproval' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionHumanApproval' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should not be in the output for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionHumanApproval' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 0;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionHumanApproval' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should have the same result as default for FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionHumanApproval' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionHumanApproval' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Environments.ProductionHumanApproval.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Environments.Description' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.Description' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.Description' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should not be in the output for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.Description' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 0;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.Description' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should have the same result as default for FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.Description' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.Description' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Environments.Description.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Environments.ProductionBranchLimit' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionBranchLimit' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionBranchLimit' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should not be in the output for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionBranchLimit' -and $_.TargetName -match 'fail' })
            $ruleHits.Count | Should -Be 0;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionBranchLimit' -and $_.TargetName -match 'success' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should have the same result as default for FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionBranchLimit' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Environments.ProductionBranchLimit' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Environments.ProductionBranchLimit.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' -and $_.TargetName -match 'fail-project-CI-gui' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' -and $_.TargetName -match 'fail-project-CI-gui' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' -and $_.TargetName -match 'fail-project-CI-gui' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.UseYamlDefinition' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Core.UseYamlDefinition.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Core.InheritedPermissions' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.InheritedPermissions' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 2;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.InheritedPermissions' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should not be present for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.InheritedPermissions' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.InheritedPermissions' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 2;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.InheritedPermissions' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Core.InheritedPermissions.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Core.NoPlainTextSecrets' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.NoPlainTextSecrets' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.NoPlainTextSecrets' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Core.NoPlainTextSecrets' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Core.NoPlainTextSecrets.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime' {
        It 'Should Pass' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope' {
        It 'Should Pass' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines' {
        It 'Should Pass' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines' {
        It 'Should Pass' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork' {
        It 'Should Pass' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork' {
        It 'Should Pass' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments' {
        It 'Should Pass' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'Success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'Success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'Success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' {
        It 'Should pass for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Releases.Definition.SelfApproval.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should not be present with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should be the same as default with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'fail' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.HasBranchPolicy' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasBranchPolicy' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasBranchPolicy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasBranchPolicy' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasBranchPolicy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasBranchPolicy' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasBranchPolicy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.HasBranchPolicy.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyIsEnabled' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyIsEnabled' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyIsEnabled' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyIsEnabled' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyIsEnabled' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyIsEnabled' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyIsEnabled' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.BranchPolicyIsEnabled.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.BranchPolicyMinimumReviewers.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.BranchPolicyAllowSelfApproval.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyResetVotes' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyResetVotes' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyResetVotes' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyResetVotes' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyResetVotes' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyResetVotes' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyResetVotes' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.BranchPolicyResetVotes.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.Readme' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.Readme.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.License' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.License.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyCommentResolution' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyCommentResolution' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyCommentResolution' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyCommentResolution' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyCommentResolution' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyCommentResolution' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyCommentResolution' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.BranchPolicyCommentResolution.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyMergeStrategy' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMergeStrategy' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMergeStrategy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMergeStrategy' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMergeStrategy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMergeStrategy' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyMergeStrategy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.BranchPolicyMergeStrategy.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass none' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should not be run in the Baseline.NoExtraLicense baseline' {
            $ruleHits = @($noExtraLicenseBaselineResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should not be present with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should not be present with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass none' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should not be run in the Baseline.NoExtraLicense baseline' {
            $ruleHits = @($noExtraLicenseBaselineResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should not be present with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should not be present with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.InheritedPermissions' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.InheritedPermissions' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.InheritedPermissions' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should not be present with the ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.InheritedPermissions' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should be the same as default with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.InheritedPermissions' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.InheritedPermissions' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.InheritedPermissions.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.Repos.BranchPolicyRequireBuild' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyRequireBuild' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyRequireBuild' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyRequireBuild' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyRequireBuild' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyRequireBuild' -and $_.TargetName -match 'fail-project' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.BranchPolicyRequireBuild' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.BranchPolicyRequireBuild.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.ServiceConnections.Description' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -like '*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 3;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -like '*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 3;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -like '*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 3;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.Description.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.ServiceConnections.Scope' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -like '*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -like '*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -like '*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.Scope.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -like '*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -like '*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -like '*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.WorkloadIdentityFederation.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' {
        It 'Should not touch non-production service connections' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' -and $_.TargetName -like '*fail*' })
            $ruleHits.Count | Should -Be 0;
        }

        It 'Should pass for production targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' -and $_.TargetName -like '*fail*' })
            $ruleHits.Count | Should -Be 0;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' -and $_.TargetName -like '*fail*' })
            $ruleHits.Count | Should -Be 0;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.ProductionBranchLimit.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.ServiceConnections.ClassicAzure' {
        It 'Should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -like '*Classic*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should pass for all other service connections' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -notlike '*Classic*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 2;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -like '*Classic*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -notlike '*Classic*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 2;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -like '*Classic*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -notlike '*Classic*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 2;
        }

        It 'Should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.ClassicAzure.md');
            $fileExists | Should -Be $true;
        }
    }

    Context 'Azure.DevOps.ServiceConnections.GitHubPAT' {
        It 'Should fail for connections named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.GitHubPAT' -and $_.TargetName -like '*GitHub*PAT*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.GitHubPAT' -and $_.TargetName -like '*GitHub*PAT*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.GitHubPAT' -and $_.TargetName -like '*GitHub*PAT*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It 'Should have an english markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.GitHubPAT.md');
            $fileExists | Should -Be $true;
        }
    }
}
