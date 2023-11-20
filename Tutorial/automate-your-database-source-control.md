# Automate your database source control

While you can manually run the `sqlpackage` command to convert your database to code, you can also automate this process to run on a schedule or based on other CI/CD triggers.

Before you work on automating, make sure you have completed the [Convert your database to code](convert-your-database-to-code.md) quickstart and have checked that code into source control.


The [GitHub Actions workflow](.github/workflows/database-pr.yml) in this repo is an example of how to have an automated pipeline do the same steps we do locally, where the workflow steps are:

1. Checking out the repo files into the automated environment
2. Setting a timestamp variable to use as a branch name
3. Reset the database files in the environment by removing them
4. Run the `sqlpackage` command to extract the database schema to the pipeline environment
5. Use `git status` to see if there are changes
6. If there are changes, create a new branch with the timestamp as the name and commit the changes to the branch
7. If there are changes, open a PR to the main branch as 'Database Status Bot'
8. Output a summary to the workflow log

## Create a GitHub Actions workflow

You can create a new workflow for GitHub Actions from the web interface or by manually adding a file to your repository in the `.github/workflows` folder.