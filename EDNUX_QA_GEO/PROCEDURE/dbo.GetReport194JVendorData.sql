/****** Object:  StoredProcedure [dbo].[GetReport194JVendorData]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetReport194JVendorData]
GO
/****** Object:  StoredProcedure [dbo].[GetReport194JVendorData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE PROC [dbo].[GetReport194JVendorData]
	@EDCompanyID VARCHAR(200),
	@EDTrustDBName VARCHAR(100),
	@VendorName VARCHAR(100), 
	@SaleFromDate  DATETIME=NULL,
	@SaleToDate  DATETIME=NULL,
	@ExFromDate DATETIME=NULL,
	@ExToDate  DATETIME=NULL
 AS 
 BEGIN
 SET NOCOUNT ON;
 
	DECLARE @DeducteeName VARCHAR(100),
			@DeducteePAN VARCHAR(15),
			@DeducteeAddress VARCHAR(500),
			@DeducteePIN VARCHAR(10),
			@FieldName VARCHAR(50),
			@SqlString VARCHAR(400),
			@SpParameter VARCHAR(400)

	SELECT @DeducteeName=DeducteeName,@DeducteePAN=DeducteePAN,@DeducteeAddress=DeducteeAddress,@DeducteePIN=DeducteePIN,@FieldName=FieldName
	FROM  Report194J R 
		INNER JOIN VENDORLIST V ON V.VendorID = R.VendorID 
		INNER JOIN AmtPaidCreaditedDataFields A 
		ON A.ID = R.AmtPaidCreaditedID WHERE VendorName = @VendorName
   
   
   SET @SqlString=CASE WHEN UPPER(@FieldName)=UPPER('Cashless Charges') 
                         THEN @EDTrustDBName+'..GetSaleDateAndCashlessChgDetails '
                       WHEN UPPER(@FieldName)=UPPER('CA Charges')  
                         THEN  @EDTrustDBName+'..GetSaleDateAndCAChgAndCessCAChgDetails '
                  END
   SET @SpParameter =''''+ @EDCompanyID+''','''+ISNULL(CONVERT(VARCHAR(11), @SaleFromDate,110),'')+''','''+ISNULL(CONVERT(VARCHAR(11), @SaleToDate,110),'')+''','''+ISNULL(CONVERT(VARCHAR(11), @ExFromDate,110),'')+''','''+ISNULL(CONVERT(VARCHAR(11), @ExToDate,110),'')+''''
   --PRINT @SpParameter
   
   CREATE TABLE #Report194JTable(PaymentDate Date, AmtPaid DECIMAL(10,2),ServiceTaxOnCAFillingFees DECIMAL(10,2),CessCAFilling DECIMAL(10,2),DeducteeName VARCHAR(100),DeducteePAN VARCHAR(15),DeducteeAddress VARCHAR(500), DeducteePIN  VARCHAR(10))  
   INSERT INTO #Report194JTable(PaymentDate,AmtPaid,ServiceTaxOnCAFillingFees,CessCAFilling)
   EXEC(@SqlString+@SpParameter)
   --PRINT(@SqlString+@SpParameter)
   UPDATE #Report194JTable SET DeducteeName=@DeducteeName,DeducteePAN=@DeducteePAN,DeducteeAddress=@DeducteeAddress,DeducteePIN=@DeducteePIN

   SELECT * FROM #Report194JTable


   DROP TABLE #Report194JTable
  
END
GO
