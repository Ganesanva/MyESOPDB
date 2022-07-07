/****** Object:  StoredProcedure [dbo].[PROC_CheckSinglePaymentMode]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CheckSinglePaymentMode]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CheckSinglePaymentMode]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_CheckSinglePaymentMode]

		@CompanyID			VARCHAR(20),
		@TrustCompanyName	VARCHAR(20)
AS
BEGIN

	DECLARE @Query VARCHAR(80)= @TrustCompanyName +'..GetTrustResidentDetails '''+ @CompanyID +''''
	--PRINT @Query
	CREATE TABLE #TEMP(SELLALLTYPE VARCHAR(2),SELLPARTIALTYPE VARCHAR(2),RI CHAR,NRI CHAR,FN CHAR,SPRI CHAR,SPNRI CHAR,SPFN CHAR )
	INSERT INTO #TEMP EXEC (@Query)
	
	CREATE TABLE #TEMP_PAYMENT_DETAILS
    (
		 PAYMODENAME varchar(20), 
		 ISACTIVATED  char(1),
		 PaymentMode char(1)			
	)
		
	INSERT INTO #TEMP_PAYMENT_DETAILS
	SELECT * FROM (SELECT DISTINCT PM.PAYMODENAME, RPM.ISACTIVATED,PM.PaymentMode
		FROM PAYMENTMASTER AS PM
		INNER JOIN RESIDENTIALPAYMENTMODE AS RPM 
		ON PM.ID = RPM.PAYMENTMASTER_ID
	WHERE RPM.ISACTIVATED = 'Y' AND PaymentMode NOT IN ('A','P')
	UNION
	SELECT CASE WHEN SELLALLTYPE='SA' THEN 'SELL ALL' END PAYMODENAME,
		   CASE WHEN (RI='Y' OR NRI='Y' OR FN='Y') THEN 'Y' ELSE 'N' END ISACTIVATED,
		   CASE WHEN (SELLALLTYPE='SA' OR SELLALLTYPE IS NULL OR SELLALLTYPE='') THEN 'A' END PaymentMode 
		   
	FROM #TEMP
	UNION
	SELECT CASE WHEN (SELLPARTIALTYPE='SP' OR SELLPARTIALTYPE IS NULL OR SELLPARTIALTYPE ='') THEN 'SELL TO COVER' END PAYMODENAME,
		   CASE WHEN (SPRI='Y' OR SPNRI='Y' OR SPFN='Y') THEN 'Y' ELSE 'N' END ISACTIVATED,
		   CASE WHEN (SELLPARTIALTYPE='SP' OR SELLPARTIALTYPE IS NULL OR SELLPARTIALTYPE ='') THEN 'P' END PaymentMode
	FROM #TEMP) AS FINAL WHERE FINAL.isActivated='Y'

	DECLARE @rCoount INT,
			@IsSingleModeEnabled BIT
	SET @rCoount = @@ROWCOUNT

	IF @rCoount > 1
		BEGIN
			SET @IsSingleModeEnabled=0
		END
	ELSE
		BEGIN
			SET @IsSingleModeEnabled=1
		END
	
	SELECT PAYMODENAME, ISACTIVATED, PaymentMode from #TEMP_PAYMENT_DETAILS
	SELECT @IsSingleModeEnabled AS Result
	
	IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_SINGLEPAYMENTMODE_DETAILS')
		DROP TABLE TEMP_SINGLEPAYMENTMODE_DETAILS   	   
    SELECT *, @IsSingleModeEnabled as IsSingleModeEnabled INTO TEMP_SINGLEPAYMENTMODE_DETAILS FROM #TEMP_PAYMENT_DETAILS
	
	DROP TABLE #TEMP_PAYMENT_DETAILS
END
GO
