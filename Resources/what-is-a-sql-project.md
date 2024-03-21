# What is a SQL project?

*This very brief article will cover the fundamentals of what a SQL project is and does not attempt to be exhaustive.*

A SQL project is a framework around your database code that adds two foundational (and *amazing*) capabilities to that set of files with its **build process**:

1. [validation](#validation) of references between objects and the syntax against a specific version of SQL
2. [deployment](#deployment) of the build artifact to new or existing databases

Before we discuss those two capabilities a little further, I want to address the proverbial 🐘 elephant in the room.  SQL projects are built on a .NET library and as a result rely on the .NET SDK. You'll see commands like `dotnet build` in the next sections, but SQL projects do *not* require knowledge of .NET or require the rest of your project to be based in .NET.  SQL projects are for everyone, not just .NET developers.

### Declarative code

SQL projects do have a requirement of your database code - it is declarative.  In your database code, you will create each object once.  If you need to change something about that object, such as add additional columns or change a data type, you modify the singular file that declares the object for the first and only time.  The database code definition provided when you run SqlPackage extract is declarative and can be used as-is for SQL projects.

## Validation

When a SQL project is built, the relationships between objects are validated.  For example, a view definition cannot contain a table or columns that don't exist in the SQL project.

Additionally, a SQL project contains a property in its *.sqlproj* file called the "target platform", or "DSP".  This information is used during the build process to validate that the functions and T-SQL syntax exists in that version of SQL.  For example, the JSON functions added in SQL Server 2022 cannot be used in a SQL project set to the Sql140 (SQL Server 2017) target platform.

To build a SQL project, we run `dotnet build` from the command line.  In graphical tools that support SQL projects (Azure Data Studio, VS Code, and Visual Studio), there's a menu item to build the SQL project.

The console output of the build process may contain errors (build failure) or warnings.  Build warnings can include inconsistent casing in object names and other best practices, but do not fail the build.

The artifact output of the build process is a *.dacpac* file, which can be found for a build with default settings in the `bin/Debug` folder.

## Deployment

The output file, the *.dacpac*, is extremely powerful. With this file we can use SqlPackage or [other tools](#other-tools-that-deploy-dacpacs) to apply our database code to a database.  The SqlPackage command to deploy a *.dacpac* is the [**publish** command]().

For example, `sqlpackage /Action:Publish /SourceFile:ourfile.dacpac /TargetConnectionString:{yourconnectionstring}`.

### New databases

When publishing a dacpac to a new database, SqlPackage is navigates the object relationships to create each object in the right order.  For example, SqlPackage creates Table_A before Table_B when Table_B has a foreign key to Table_A.

You don't want to be executing a whole folder of SQL scripts when you could be using SQL projects to manage running each T-SQL section in the right order.

### Existing databases

In addition to navigating the object heirarchy as when publishing to new databases, the *.dacpac* publish process also calculates the difference between a source *.dacpac* and a target database before determining what steps it needs to take to update that database.  For example, if Table_C is missing 2 columns in the database that it has in the SQL project and StoredProcedure_A has been changed, SqlPackage will create an `ALTER TABLE` statement and an `ALTER PROCEDURE` statement instead of blindly trying to create a bunch of objects.

The flexibility provided by the publish command to existing databases is not limited to a single database.  One *.dacpac* can be deployed multiple times, such as when upgrading a fleet of a hundred databases.

### Other tools that deploy dacpacs

- Azure Data Studio
- SQL Server Management Studio (SSMS)
- Visual Studio SQL Server Data Tools (SSDT)