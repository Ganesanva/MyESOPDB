/****** Object:  StoredProcedure [dbo].[PROC_GET_PG_TRANSACTION_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_PG_TRANSACTION_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_PG_TRANSACTION_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[PROC_GET_PG_TRANSACTION_DETAILS]
	@ACTIONPARAMETER	VARCHAR(50) 
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ROWCOUNT INT 


	IF(@ACTIONPARAMETER= 'GETEXERCISED')
	BEGIN	
		SELECT 	DISTINCT TSEO.ExerciseNo FROM 
		Transaction_Details AS TD
		INNER JOIN ShExercisedOptions AS TSEO ON TD.Sh_ExerciseNo = TSEO.ExerciseNo
		INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = TSEO.EmployeeID
					
	END	
	ELSE IF(@ACTIONPARAMETER = 'GETPAYMENTBANK')
	BEGIN
	IF(@ROWCOUNT > 1)
	BEGIN
		SELECT BankID, BankName FROM
		(
			SELECT '0' AS BankID, 'Select Bank' AS BankName
			UNION 
			SELECT BankID,BankName FROM paymentbankmaster WHERE IsEnable='Y' 
		)
		#temp	
		ORDER BY BankID ASC
	END
	ELSE
	BEGIN
	SELECT BankID, BankName FROM
		(			
			SELECT BankID,BankName FROM paymentbankmaster WHERE IsEnable='Y' 
		)
		#temp	
		ORDER BY BankID ASC
	END
	END		
	SET NOCOUNT OFF;	
				
END
GO
