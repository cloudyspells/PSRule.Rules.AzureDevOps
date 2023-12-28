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

    Import-Module -Name $ourModule -Force
    $here = (Resolve-Path $PSScriptRoot).Path

    # Get tempory test output folder and store path
    $outPath = Get-Item -Path (Join-Path -Path $here -ChildPath 'out')
    $outPath = $outPath.FullName
    
    # Run rules with default token type
    $ruleResult = Invoke-PSRule -InputPath "$($outPath)/" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en

    # Get temporary test output folder for tests with the ReadOnly TokenType
    $outPathReadOnly = Get-Item -Path (Join-Path -Path $here -ChildPath 'outReadOnly')
    $outPathReadOnly = $outPathReadOnly.FullName

    # Run rules with ReadOnly token type
    $ruleResultReadOnly = Invoke-PSRule -InputPath "$($outPathReadOnly)/" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en

    # Get temporary test output folder for tests with the FineGrained TokenType
    $outPathFineGrained = Get-Item -Path (Join-Path -Path $here -ChildPath 'outFineGrained')
    $outPathFineGrained = $outPathFineGrained.FullName

    # Run rules with FineGrained token type
    $ruleResultFineGrained = Invoke-PSRule -InputPath "$($outPathFineGrained)/" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en
}

Describe "Azure.DevOps.Pipelines.Releases rules" {
    Context ' Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'Fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'Success$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'Fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'Success$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'Fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' -and $_.TargetName -match 'Success$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' {
        It ' should pass for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'Fail$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'Success$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same for ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'Fail$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'Success$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same for the FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'Fail$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.SelfApproval' -and $_.TargetName -match 'Success$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Releases.Definition.SelfApproval.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' -and $_.TargetName -match 'Fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' -and $_.TargetName -match 'Success$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should not be present with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' })
            $ruleHits.Count | Should -Be 0;
        }

        It ' should be the same as default with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' -and $_.TargetName -match 'Fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions' -and $_.TargetName -match 'Success$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'Fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'Success$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'Fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'Success$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'Fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets' -and $_.TargetName -match 'Success$' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets.md');
            $fileExists | Should -Be $true;
        }
    }
}

AfterAll {
    # Remove Module
    Remove-Module -Name PSRule.Rules.AzureDevOps -Force
}
