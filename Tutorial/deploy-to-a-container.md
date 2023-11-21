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

Creating a new container involves retreiving the desired container image and creating a new container from that image.  To make our container more easily manageable, we'll give it a specific name.

From the command line:

```bash
docker pull
docker run
```

### Do more with the container

We can check on our container from the command line with the command `docker container list`.

When we're ready to stop a container to free up the computer's CPU and memory, we can do so with `docker stop sqlproj-dev`.

When we're ready to remove (*delete*) a container, including removing the database files completely, we can do so with `docker `.

There's a significant depth of container capabilities not covered here that are [recommended learning](#container-learning-resources) if this concept appeals to you.

## 📦 Deploying the database code

### Connect to our new database


## 🧙 All at once

Let's say we want a script that we can run each morning, or just whenever we want to refresh our local database development environment.  The following example script would be run from our local directory where we've checked our SQL project into source control.

```bash
# pull the latest database code
git pull origin main

# build the SQL project


# remove the old container and create a new one


# deploy our database code

```


## Learn more

### Container learning resources