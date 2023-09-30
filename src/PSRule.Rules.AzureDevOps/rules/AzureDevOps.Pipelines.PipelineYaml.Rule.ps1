
# Synopsis: Microsoft hosted agent pool should target a specific version
Rule 'Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest' `
    -Ref 'ADO-YAML-001' `
    -Type 'Azure.DevOps.Pipelines.PipelineYaml' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'Microsoft hosted agent pool should target a specific version'
        Reason 'Pipeline is using the latest version of the Microsoft hosted agent pool'
        Recommend 'Specify a specific version of the Microsoft hosted agent pool'
        # Links ''
        AllOf {
            AnyOf {
                $Assert.NotMatch($TargetObject, "stages.jobs[*].pool.vmImage", "latest")
                $Assert.Null($TargetObject, "stages.jobs[*].pool.vmImage")    
            }
            AnyOf {
                $Assert.NotMatch($TargetObject, "stages[*].pool.vmImage", "latest")
                $Assert.Null($TargetObject, "stages[*].pool.vmImage")    
            }
            AnyOf {
                $Assert.NotMatch($TargetObject, "pool.vmImage", "latest")
                $Assert.Null($TargetObject, "pool.vmImage")    
            }
        }
}

# Synopsis: All steps should have a display name
Rule 'Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName' `
    -Ref 'ADO-YAML-002' `
    -Type 'Azure.DevOps.Pipelines.PipelineYaml' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'All steps should have a display name'
        Reason 'Step is missing a display name'
        Recommend 'Add a display name to the step'
        # Links ''
        AllOf {
            If($TargetObject.stages) {
                $TargetObject.stages | ForEach-Object {
                    $Assert.HasField($_, "jobs", $true)
                    $_.jobs | ForEach-Object {
                        $Assert.HasField($_, "steps", $true)
                        $_.steps | ForEach-Object {
                            $Assert.HasField($_, "displayName", $true)
                            $Assert.HasFieldValue($_, "displayName")
                        }
                    }
                }
            }
            elseif ($TargetObject.jobs) {
                $Assert.HasField($TargetObject, "jobs", $true)
                $TargetObject.jobs | ForEach-Object {
                    $Assert.HasField($_, "steps", $true)
                    $_.steps | ForEach-Object {
                        $Assert.HasField($_, "displayName", $true)
                        $Assert.HasFieldValue($_, "displayName")
                    }
                }
            }
            else {
                $Assert.HasField($TargetObject, "steps", $true)
                $TargetObject.steps | ForEach-Object {
                    $Assert.HasField($_, "displayName", $true)
                    $Assert.HasFieldValue($_, "displayName")
                }
            }
        }
}
