Example Azure DevOps Pipeline
=============================

This folder contains an example Azure DevOps Pipeline that can be used to
validate the rules in this module against your own Azure DevOps project.

Copy the contents of this folder to your own Azure DevOps repository and
update the `azure-pipelines.yml` file to point to your own repository using
the variables for `devops_organization` and `devops_project`. The variable
group `my-group` is used to store the PAT for the Azure DevOps project.
The variable should be named `ADO_PAT`.

```yaml
variables:
  - group: my-group
  - name: devops_organization
    value: "MyOrg"
  - name: devops_project
    value: "MyProject"
```

The pipeline will run the `Export-AzDevOpsRuleData` command to export the
data from the Azure DevOps project and then run the `Assert-PSRule` command
to validate the rules in this module against the exported data.

The pipeline will fail if any of the rules fail. The output of the
`Assert-PSRule` command will be stored as an artifact in the pipeline
run. The results can be viewer with the Sarif Viewer extension in Azure
DevOps. 

![Sarif Viewer](../assets/media/sarif-0.0.11.png)
