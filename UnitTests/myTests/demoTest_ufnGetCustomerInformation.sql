EXEC tSQLt.NewTestClass 'testCustomerInfo';
GO

CREATE PROCEDURE testCustomerInfo.[test that ufnGetCustomerInformation returns correct information]
AS
BEGIN
    DECLARE @errorThrown bit; SET @errorThrown = 0;
    
    EXEC tSQLt.FakeTable 'SalesLT.Customer', @Identity = 1, @Defaults = 1;

    BEGIN TRY
        
        INSERT INTO SalesLT.Customer (NameStyle, Title, FirstName, MiddleName, LastName, Suffix, CompanyName, SalesPerson, EmailAddress, Phone, PasswordHash, PasswordSalt, rowguid, ModifiedDate)
        VALUES (0, 'Mr.', 'Orlando', NULL, 'Gee', NULL, 'A Bike Store', 'adventure-works\pamela0', 'orlando0@adventure-works.com', '245-555-0173', 'L/Rlwxzp4w7RWmEgXX+/A7cXaePEPcp+KwQhl2fJL7w=', '1KjXYs4=', NEWID(), GETDATE());

    END TRY
    BEGIN CATCH
        EXEC tSQLt.Fail 'Sample data failed to insert';
    END CATCH;    

    SELECT *
      INTO actual
      FROM dbo.ufnGetCustomerInformation(1);
    
    SELECT CustomerID, FirstName, LastName
        INTO expected
        FROM SalesLT.Customer
         WHERE CustomerID = 1;

    EXEC tSQLt.AssertEqualsTable 'expected', 'actual';
END;
GO
