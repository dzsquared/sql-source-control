# SQL Source Control

## Prerequisites

1. [SqlPackage](https://aka.ms/sqlpackage-ref)
    ```bash
    dotnet tool install -g microsoft.sqlpackage
    ```

## Convert your database to code

```bash
sqlpackage /a:extract /ssn:localhost /sdn:AdventureWorks /su:sa /sp:Passw0rd /stsc:true /tf:dbobjects /p:ExtractTarget=ObjectType
```

- `/a:extract` specifies the action to perform a schema extraction with `/p:ExtractTarget=ObjectType` organizing the files into folders by object type
- `/tf:dbobjects` sets the output location to the [dbobjects](dbobjects) folder

### Setup an automated process to check the database into source control

