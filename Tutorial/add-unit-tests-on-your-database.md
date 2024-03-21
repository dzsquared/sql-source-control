# Add unit tests on your database

You may be familiar with unit tests and their importance to ensuring that once functionality is correctly implemented, it remains so. Unit tests are a great way to ensure that your database is working as expected, and that any changes you make to your database don't break expected functionality. Layering a unit test project and set of unit tests on your database code enables you to test your database code in either an ad-hoc or automated manner. 

> [!NOTE]
> Prerequisite: SQL project file on your database code

There is a very small example of utilizing the [tSQLt unit test framework](https://tsqlt.org/) in the [UnitTests](../UnitTests) folder and with the [unit-tests.yml](../.github/workflows/unit-tests.yml) GitHub Actions workflow. In this repository, the unit tests example is more of an aspirational future state than the first step.

## Introduction to tSQLt unit tests

The [tSQLt unit test framework](https://tsqlt.org/) is a great way to get started with unit tests on your database code.  It is a free, open-source framework that enables you to write unit tests in T-SQL.


