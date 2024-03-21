# Check your database into source control

Once your [database has been converted to code](convert-your-database-to-code.md), you can check the files into source control using the same tools and workflows as you would for application code.  If you already have a preferred method, this article probably isn't for you.

Checking the database code into source control provides a number of benefits, but primarily it allows you to track changes to the database over time and collaborate with others on the database code without providing access to the actual database.

## VS Code or Azure Data Studio

### 1. Open the folder

The explorer view in either [VS Code](https://code.visualstudio.com/) or [Azure Data Studio](https://learn.microsoft.com/azure-data-studio/download-azure-data-studio) can be used to open a folder in the application.  Once the folder is open, the files within can be easily viewed and edited.


### 2. Initialize a Git repository

*You may need to [install git](https://code.visualstudio.com/docs/sourcecontrol/intro-to-git) on your computer to setup git in VS Code or Azure Data Studio.*

Once the folder is open, in the Source Control view, select the Initialize Repository button. This creates a new Git repository in the current folder, allowing you to start tracking code changes.

### 3. Stage and commit the database code

In the Source Control view, use the plus icons to **stage** the changes.  You can stage all of the changes at once, or split the changes across multiple commits.

**Commit** the staged changes by typing a brief summary of the changes in the message text box and clicking the checkmark icon or the commit button.

### 4. Push the changes to a remote repository

Everything you have done so far to track the changes to your database code has been local to your computer.  To share the code with others or have access to the code without these local files, you will need to push the changes to a remote repository such as GitHub or Azure DevOps.  The first push of a branch to a remote repository is often referred to as a "publish".

In the process of pushing code to a remote repository, you are adding the address of that other location as a **remote** to the local repository.  This allows you to push and pull changes between the two locations from your local folder without needing to re-enter where the remote is.

When you create a new empty/blank repository on GitHub, the page provides directions for adding it as a remote from the command line.  It would look something like this:

```bash
git remote add origin https://github.com/dzsquared/fdsjklfdsjl.git
git branch -M main
git push -u origin main
```

You can leverage these instructions right from VS Code or Azure Data Studio by opening the terminal from the **View** menu.

Once the remote is added and the initial commit is pushed, you can push the future changes to the remote by clicking the ellipsis button in the Source Control view and selecting **Push**.


## Command line (git)

### 1. Navigate to the folder

If you haven't already, change directory `cd` to the folder where your database code is stored locally.

Based on the example in [convert-your-database-to-code.md](convert-your-database-to-code.md), the command would look something like this:

```bash
cd AdventureWorks
```

### 2. Initialize a Git repository

*You may need to [install git](https://git-scm.com/downloads) on your computer.*

The `init` command in git will initialize a repository in the current folder.  This allows you to start tracking code changes.

```bash
git init
```

### 3. Stage and commit the database code

To **stage** the changes, use the `add` command.  You can stage all of the changes at once with a wildcard (`*`), or split the changes across multiple commits.

Our commit command comes with an option for the commit message `-m` to specify a brief summary of the changes.


```bash
git add *
git commit -m "Initial commit DB code"
```

### 4. Push the changes to a remote repository

Everything you have done so far to track the changes to your database code has been local to your computer.  To share the code with others or have access to the code without these local files, you will need to push the changes to a remote repository such as GitHub or Azure DevOps.  The first push of a branch to a remote repository is often referred to as a "publish".

In the process of pushing code to a remote repository, you are adding the address of that other location as a **remote** to the local repository.  This allows you to push and pull changes between the two locations from your local folder without needing to re-enter where the remote is.

When you create a new empty/blank repository on GitHub, the page provides directions for adding it as a remote from the command line.  It would look something like this:

```bash
git remote add origin https://github.com/dzsquared/fdsjklfdsjl.git
git branch -M main
git push -u origin main
```


Once the remote is added and the initial commit is pushed, you can push the future changes to the remote by using the `push` command with the remote name and branch name.

```bash
git push origin main
```

## Next steps

Optionally, follow up with:
- [Setup a pipeline to automatically check your database into source control](automate-your-database-source-control.md)
- [Deploy your database code to a container for development](deploy-to-a-container.md)
- [Add unit tests on your database](add-unit-tests-on-your-database.md)
