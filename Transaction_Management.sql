-- =================================================
-- ICW 2 - Transaction Management
-- Jeong Eun Jang (w0451032)
-- DBAS 3035 Information Systems Design
-- George Campanis
-- February 14, 2022
-- ==================================================

--1. Add Constraints to the database

ALTER TABLE CUSTOMER 
ADD CONSTRAINT CHK_CUS_BALANCE
CHECK (CUS_BALANCE <= 1000)

ALTER TABLE PRODUCT
ADD CONSTRAINT CHK_PRODUCT_QOH
CHECK (P_QOH >= 0)

--2. Create a Stored Procedure
--3. Test the Stored Procedure
--4. Use COMMIT and ROLLBACK & test

CREATE PROC spProductSale (
	@CustomerCode int
	,@ProductCode nvarchar(10)
	,@ProductUnits int )

AS

BEGIN TRY
	BEGIN TRAN 
	
	UPDATE CUSTOMER 
	SET CUS_BALANCE = CUS_BALANCE + (SELECT (P_PRICE * @ProductUnits) FROM PRODUCT
	WHERE P_CODE = @ProductCode)
	
	COMMIT TRAN
	PRINT 'The transaction was successfully committed to the database.'
END TRY
BEGIN CATCH
	DECLARE @Customer_Name VARCHAR(50) = (SELECT CUS_FNAME + ' '  + CUS_LNAME FROM CUSTOMER WHERE CUS_CODE = @CustomerCode)
	PRINT 'Dear ' + @Customer_Name + ', unfortunately you only have a balance of $1,000 available to you. Please speak with someone from our accounts depeartment.'
	ROLLBACK TRAN
END CATCH

BEGIN TRY
	BEGIN TRAN

	UPDATE PRODUCT 
	SET P_QOH = (P_QOH - @ProductUnits) 
	WHERE P_CODE = @ProductCode

	COMMIT TRAN
END TRY
BEGIN CATCH
	DECLARE @Product_Desc VARCHAR(50) = (SELECT P_DESCRIPT FROM PRODUCT WHERE P_CODE = @ProductCode)
	PRINT 'Unfortunately the ' + @Product_Desc + ' is out of stock.'
	ROLLBACK TRAN
END CATCH

--TEST THE RESULTS
EXEC spProductSale 10010, '2232/QWE', 10
EXEC spProductSale 10016, '23114-AA' , 3
EXEC spProductSale 10017, '89-WRE-Q ', 1


SELECT * FROM CUSTOMER;
SELECT * FROM PRODUCT;


