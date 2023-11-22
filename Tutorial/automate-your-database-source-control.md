# Automate your database source control

While you can manually run the `sqlpackage` command to convert your database to code, you can also automate this process to run on a schedule or based on other CI/CD triggers.

Before you work on automating, make sure you have completed the [Convert your database to code](convert-your-database-to-code.md) quickstart and have checked that code into source control.


The [GitHub Actions workflow](../.github/workflows/database-pr.yml) in this repo is an example of how to have an automated pipeline do the same steps we do locally, where the workflow steps are:

1. Checking out the repo files into the automated environment
2. Setting a timestamp variable to use as a branch name
3. Reset the database files in the environment by removing them
4. Run the `sqlpackage` command to extract the database schema to the pipeline environment
4b. (optional) Adds a .sqlproj file to the folder
5. Use `git status` to see if there are changes
6. If there are changes, create a new branch with the timestamp as the name and commit the changes to the branch
7. If there are changes, open a PR to the main branch as 'Database Status Bot'
8. Output a summary to the workflow log

## Create a GitHub Actions workflow

You can create a new workflow for GitHub Actions from the web interface or by manually adding a file to your repository in the `.github/workflows` folder.  Once this file is committed and pushed to your remote repository in GitHub, the workflow will appear in the **Actions** area of the web UI.

## GitHub Actions fundamentals

### 🚀 Workflow trigger

While the advantage of GitHub Actions is that the workflow can run automatically on one or more event types, the sample workflow [database-PR.yml](../.github/workflows/database-PR.yml) is set to run on manual interaction.  The `workflow_dispatch` keyword is used to specify that the workflow should be started by a user from either the GitHub web interface or API call.

Another popular way to trigger a workflow in a more automated fashion is on pull request (`pull_request`) or push (`push`), and both can be filtered by the branch and/or file paths impacted.  For example, in the [unit-tests.yml](../.github/workflows/database-PR.yml) sample workflow covered in another tutorial, the pipeline is run when a pull request is made that impacts the files in the `AdventureWorks/**` path.

### 🛠️ Script steps

When we converted our [database to code](convert-your-database-to-code.md), we used the SqlPackage command line tool to create the set of database code files.  In GitHub Actions and other automation environments, you can manually write workflow steps as if you were executing them locally.  We see this in the 4th step of [database-PR.yml](../github/worfklows/database-PR.yml):

```bash
- name: '4. Deconstruct database objects to files'
  run: |
    sqlpackage /Action:Extract /SourceConnectionString:"${{ secrets.SQL_CONNECTION }}" /TargetFile:"AdventureWorks" /p:ExtractTarget=ObjectType
```

By starting the "run" step with the pipe character (`|`), we can chain multiple commands together on several lines all in the same step.  Steps 4b and 6 use this capability.


### 🪄 Action steps

While the capabilities of scripted steps is nearly inifinite, it is also a lot of work to write code out to do certain things - like open a pull request via the GitHub API.  Fortunately, automation environments like GitHub Actions provide a feature to reuse packaged steps.  In our [database-PR.yml](../github/worfklows/database-PR.yml) example, we leverage `uses` to invoke packaged "actions" in steps 1 and 7.

These actions can be quite complex and modify their behavior based on inputs, which we provide to them from our workflow:

```bash
- name: '7. open a pull request'
  id: pull_request
  if: steps.get_changes.outputs.changed != 0
  uses: vsoch/pull-request-action@1.0.19
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    PULL_REQUEST_FROM_BRANCH: "db-deconstruction-${{ steps.timestamp.outputs.branchtimestamp }}"
    PULL_REQUEST_BRANCH: "main"
    PULL_REQUEST_TITLE: "Update database state"
```

### 🌳 Branching options

We can make workflow decisions on the fly through the `if` keyword, branching the behaviour of the action based on information determined when the workflow runs.  In our example [database-PR.yml](../github/worfklows/database-PR.yml), we only want to commit files and open a pull request *if* there were changes between the code checked in already and the new set of database code.

With the statement `if: steps.get_changes.outputs.changed != 0`, we can check that value and only run a particular step when the comparison is true.

## Using the `database-PR.yml` example

The example workflow [database-PR.yml](../github/worfklows/database-PR.yml) opens a pull request on a new branch in the repository, requiring elevated permissions.  These permissions are not enabled for workflows by default to ensure that their use is only coupled with triggers accessible to trusted users or protected by environments that require manual approval.

To enable the required permissions:
1. navigate to the repository settings page
2. switch actions repository permissions to "read and write" from "read"
3. enable access to the GITHUB_TOKEN

### Environment requirements

The [database-PR.yml](../github/worfklows/database-PR.yml) workflow requires the SQL connection string to be set in the repository secrets as `SQL_CONNECTION`.  This connection string is used to connect to the database and extract the schema to code.  Add the `SQL_CONNECTION` secret to your GitHub repository by following the documentation [here](https://docs.github.com/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository).

In the default GitHub Actions and Azure DevOps pipelines environments, SqlPackage is installed automatically.  If you are using a self-hosted agent, you will need to install SqlPackage manually.

## Next steps

Now that you've automated the conversion of your database to code, you can use the files in other development processes.

Optionally, follow up with:
- [Deploy your database code to a container for development](deploy-to-a-container.md)
- [Add unit tests on your database](add-unit-tests-on-your-database.md)
- [Leverage code analysis to provide automated feedback](code-analysis-automation.yml)
