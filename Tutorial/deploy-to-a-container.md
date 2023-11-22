# Deploy your database code to a development container

When you don't need a copy of production data in your development environment, leveraging your database code to setup a container-based development environment can be advantageous because it provides repeatability and disposability.  Depending on the SQL version you use in production, the available containers may be an exact match to the SQL engine used.  In the case where you do not have an exact container match available (SQL Server 2016, Azure SQL Database), we can rely on the SQL project build validation to ensure we haven't accidentally added functions or other syntax not available for our version of SQL.

Before you work on creating containers, make sure you have completed the [Convert your database to code](convert-your-database-to-code.md) quickstart.

## Prerequisites

For this quickstart, a few prerequisites are required that are all available for Windows, macOS, and Linux.

1. SqlPackage command line tool
2. .NET SDK
3. Docker Desktop (or other container runtime and management environment for your workstation)


## 🛠️ Building a SQL project

A SQL project is a framework around your database code that adds two foundational capabilities to that set of files with its build process.  Once we build the SQL project, we know it contains valid code that we can deploy to a new or existing database. If you're not familiar with SQL projects, there is a brief article on them in [What is a SQL project](../Resources/what-is-a-sql-project.md).

To build the SQL project, we use a single command:

```bash
dotnet build
```

It's not uncommon for the output to contain warnings, but it is important that there are no errors and that the build succeeds.

## 🛳️ Creating a new container

Creating a new container involves retreiving the desired container image and creating a new container from that image.  To make our container more easily manageable, we'll give it a specific name.  We can assign a non-standard port (61433) to the container to avoid conflicts with other containers or local SQL Server instances.  We'll also set the password for the `sa` account and note its value for future use.

From the command line:

```bash
docker pull mcr.microsoft.com/mssql/server:2022-latest
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" -p 61433:1433 --name sqlproj-dev --hostname sqlproj-dev -d mcr.microsoft.com/mssql/server:2022-latest
```

> [!NOTE]
> Consider using an alternative password for your development container.  The password used here is for demonstration purposes only.

### Do more with the container

We can check on our container from the command line with the command `docker container list`.

The output will be similar to:
```
CONTAINER ID   IMAGE                                        COMMAND                  CREATED              STATUS              PORTS                    NAMES
a248c73addf0   mcr.microsoft.com/mssql/server:2022-latest   "/opt/mssql/bin/perm…"   About a minute ago   Up About a minute   0.0.0.0:61433->1433/tcp   sqlproj-dev
```

When we're ready to stop a container to free up the computer's CPU and memory, we can do so with `docker container stop sqlproj-dev`.

When we're ready to remove (*delete*) a container, including removing the database files completely, we can do so with `docker container remove sqlproj-dev`.

There's a significant depth of container capabilities not covered here that are [recommended learning](#container-learning-resources) if this concept appeals to you.

## 📦 Deploying the database code

Now that we have a container running, we can deploy our database code to it.  We'll use the SqlPackage command line tool to do so, incorporating the values for our container's port and password.

```bash
sqlpackage /Action:Publish /SourceFile:bin/Debug/AdventureWorks.dacpac /TargetServerName:localhost,61433 /TargetUser:sa /TargetPassword:P@ssw0rd /TargetDatabaseName:AdventureWorks /TargetTrustServerCertificate:true
```

### Connect to our new database


## 🧙 All at once

Let's say we want a script that we can run each morning, or just whenever we want to refresh our local database development environment.  The following example script would be run from our local directory where we've checked our SQL project into source control.

```bash
# pull the latest database code
git pull origin main

# build the SQL project
dotnet build

# remove the old container and create a new one
docker container stop sqlproj-dev
docker container remove sqlproj-dev
docker pull mcr.microsoft.com/mssql/server:2022-latest
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" -p 61433:1433 --name sqlproj-dev --hostname sqlproj-dev -d mcr.microsoft.com/mssql/server:2022-latest

# deploy our database code
sqlpackage /Action:Publish /SourceFile:bin/Debug/AdventureWorks.dacpac /TargetServerName:localhost,61433 /TargetUser:sa /TargetPassword:P@ssw0rd /TargetDatabaseName:AdventureWorks /TargetTrustServerCertificate:true
```

## Learn more

### Container learning resources

- [Azure SQL Dev Corner blog post, SQL containers on macOS](https://devblogs.microsoft.com/azure-sql/development-with-sql-in-containers-on-macos/)
- [Docker overview documentation](https://docs.docker.com/get-started/overview/)
- [SQL Server in containers documentation](https://learn.microsoft.com/sql/linux/sql-server-linux-docker-container-deployment)

### SQL project learning resources

- [SQL projects brief overview](../Resources/what-is-a-sql-project.md)
- [SQL projects in Azure Data Studio](https://aka.ms/azuredatastudio-sqlprojects)
- [Microsoft.Build.Sql project SDK](https://github.com/microsoft/dacfx)


## Next steps


Optionally, follow up with:
- [Add unit tests on your database](add-unit-tests-on-your-database.md)
- [Leverage code analysis to provide automated feedback](code-analysis-automation.yml)
