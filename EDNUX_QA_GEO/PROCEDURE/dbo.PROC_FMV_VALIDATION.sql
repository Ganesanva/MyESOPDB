/****** Object:  StoredProcedure [dbo].[PROC_FMV_VALIDATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_FMV_VALIDATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_FMV_VALIDATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_FMV_VALIDATION] (@CompanyId VARCHAR(100) = NULL)
	-- Add the parameters for the stored procedure here	
AS
BEGIN
SET NOCOUNT ON;

	-------------------------------------
	-- GET DETAILS FROM COMPANY PARAMETER
	-------------------------------------
	
	BEGIN	
		DECLARE @RoundupPlace_FMV VARCHAR(5), @RoundingParam_FMV VARCHAR(5), @HTMLTable VARCHAR(MAX), @MailSubject VARCHAR(100), 
		@FromMailID VARCHAR(50), @ToMailID VARCHAR(50), @MailBody VARCHAR(MAX)
		
		SELECT	@RoundupPlace_FMV = RoundupPlace_FMV, @RoundingParam_FMV = RoundingParam_FMV FROM COMPANYPARAMETERS
	END

	-------------------------------------
	-- STEP 1 : CREATE TEMP TABLE FOR GET FMV DETAILS FOR SH EXERCISE NOW TABLE
	-------------------------------------
	IF ((SELECT COUNT(EXERCISENO) FROM SHEXERCISEDOPTIONS) > 0)
	BEGIN
		
		CREATE TABLE #SHEXERCISEDOPTIONS_TEMP1
		(
			EMPLOYEEID NVARCHAR(50), EXERCISEID NVARCHAR(10), EXERCISENO NVARCHAR(10),
			EXERCISEDATE DATETIME, FMVPRICE NUMERIC(18,6)
		)
		
		INSERT INTO #SHEXERCISEDOPTIONS_TEMP1
		(
			EMPLOYEEID, EXERCISEID, EXERCISENO, EXERCISEDATE,
			FMVPRICE 
		)		
		SELECT 
			EMPLOYEEID, EXERCISEID, EXERCISENO, EXERCISEDATE, 
			dbo.FN_ROUND_VALUE(FMVPrice, @RoundingParam_FMV, @RoundupPlace_FMV) 
		FROM 
			SHEXERCISEDOPTIONS 
		WHERE 
			CONVERT(DATE,EXERCISEDATE) = CONVERT(DATE,(GETDATE()-1))
		
		-------------------------------------
		-- STEP 2 : RECALCULATE FMV FOR ABOVE EXERCISE ID
		-------------------------------------
		CREATE TABLE #SHEXERCISEDOPTIONS_TEMP2
		(
			EMPLOYEEID NVARCHAR(50), EXERCISEID NVARCHAR(10), EXERCISENO NVARCHAR(10),
			EXERCISEDATE DATETIME, NEWFMVPRICE NUMERIC(18,6)	
		)

		INSERT INTO #SHEXERCISEDOPTIONS_TEMP2
		(
			EMPLOYEEID, EXERCISEID, EXERCISENO, EXERCISEDATE,
			NEWFMVPRICE 
		)
		SELECT 
			EMPLOYEEID, EXERCISEID, EXERCISENO, EXERCISEDATE, 
			dbo.FN_ROUND_VALUE(DBO.FUNC_GET_SHARE_PRICE(EXERCISEDATE), @RoundingParam_FMV, @RoundupPlace_FMV) AS FMVPRICE 
		FROM 
			#SHEXERCISEDOPTIONS_TEMP1 
		
		-------------------------------------	
		---- STEP 3 :  FIND RECORDS OF DIFFERENT FMV PRICE
		-------------------------------------
		IF ((SELECT COUNT(EXERCISENO) FROM #SHEXERCISEDOPTIONS_TEMP1) > 0)
		BEGIN
			CREATE TABLE #SHEXERCISEDOPTIONS_TEMP3
			(
				TblROW_ID INT IDENTITY (1,1), EMPLOYEEID NVARCHAR(50), EXERCISEID NVARCHAR(10),
				EXERCISENO NVARCHAR(10), EXERCISEDATE DATETIME, OLDFMVPRICE  NUMERIC(18,2),
				NEWFMVPRICE NUMERIC(18,2)	
			)

			INSERT INTO #SHEXERCISEDOPTIONS_TEMP3
			(				
				EMPLOYEEID, EXERCISEID, EXERCISENO, EXERCISEDATE, 
				OLDFMVPRICE, NEWFMVPRICE 
			)								
			SELECT 
				TEMP1.EMPLOYEEID, TEMP1.EXERCISEID, TEMP1.EXERCISENO, TEMP1.EXERCISEDATE,
				DBO.FN_ROUND_VALUE(FMVPRICE, @ROUNDINGPARAM_FMV, @ROUNDUPPLACE_FMV),
				DBO.FN_ROUND_VALUE(NEWFMVPRICE, @ROUNDINGPARAM_FMV, @ROUNDUPPLACE_FMV)
			FROM 
				#SHEXERCISEDOPTIONS_TEMP1 TEMP1
				INNER JOIN #SHEXERCISEDOPTIONS_TEMP2 TEMP2 ON TEMP1.EXERCISEID = TEMP2.EXERCISEID AND TEMP1.FMVPRICE <> TEMP2.NEWFMVPRICE
			
			SET @HTMLTable = '<table style="font-family: arial; font-size: 12px; line-height: 20px; border-collapse: collapse;" cellpadding="4" cellspaing="0" width : 100%>
						<thead><tr  style="background: Lightgray";>	
									<td style="border: 1px solid #000;">
									<center><b>
													EMPLOYEE ID
											<b>
									<center>												
									</td>
									<td style="border: 1px solid #000;">
									<center><b>
													EXERCISE ID
											<b>
									<center>
									</td>
									<td style="border: 1px solid #000;">
									<center><b>
													EXERCISE NO.
											<b>
									<center>
									</td>
									<td style="border: 1px solid #000;">
									<center><b>
													EXERCISE DATE
											<b>
									<center>
									 </td>
									<td style="border: 1px solid #000;">
									<center><b>
														OLD FMV
											<b>
									<center>
									 </td>
									 <td style="border: 1px solid #000;">
									<center><b>
														 NEW FMV
											<b>
									<center>
									 </td>
									 </tr></thead>									
									 <tbody>'
		
			DECLARE @MAX_ID_D INT, @MIN_ID_D INT, @Count AS INT
			SELECT @MIN_ID_D = MIN(TblROW_ID), @MAX_ID_D = MAX(TblROW_ID) FROM #SHEXERCISEDOPTIONS_TEMP3
				
			WHILE (@MIN_ID_D <= @MAX_ID_D)
			BEGIN
					SELECT 
						@HTMLTable += 
							'<tr>
								<td style="border: 1px solid #000;">												
										'+EMPLOYEEID+'															
								</td>
								<td style="border: 1px solid #000;">
										'+EXERCISEID+'
								</td>
								<td style="border: 1px solid #000;">
										'+EXERCISENO+'
								</td>
								<td style="border: 1px solid #000;">
									'+CONVERT(VARCHAR,EXERCISEDATE,103)+'
								</td>
								<td style=" border: 1px solid #000;">
									' +CONVERT(VARCHAR, OLDFMVPRICE)+ '
								</td>
								<td style="border: 1px solid #000;">
									'+CONVERT(VARCHAR, NEWFMVPRICE) +'
								</td>
							</tr>'
					FROM 
						#SHEXERCISEDOPTIONS_TEMP3 
					WHERE TblROW_ID = @MIN_ID_D
			
					SET @MIN_ID_D = @MIN_ID_D + 1
				
				CONTINUE;
				
					SET @HTMLTable+='</tbody>						
				
				</table>'
				
			END	
			
			SELECT @MailSubject = MailSubject FROM MailMessages WHERE Formats = 'FMVValidationForPriceDiff'
			SELECT @FromMailID = CompanyEmailID, @ToMailID = CompanyEmailID FROM CompanyMaster 
			SELECT @MailBody = MailBody FROM MailMessages WHERE Formats = 'FMVValidationForPriceDiff' and MailSubject = ''+@MailSubject+''
			SET @MailSubject = REPLACE(@MailSubject,'{0}', @CompanyId)
			SET @MailSubject = REPLACE(@MailSubject,'{1}', REPLACE(CONVERT(CHAR(11), GETDATE()-1, 113),' ','/'))
			SET @MailBody = REPLACE(@MailBody,'{2}', REPLACE(CONVERT(CHAR(11), GETDATE()-1, 113),' ','/'))		
			SET @MailBody = REPLACE(@MailBody,'{3}', @HTMLTable)						
			
			SELECT * FROM #SHEXERCISEDOPTIONS_TEMP3
			
			IF ((SELECT COUNT(TblROW_ID) FROM #SHEXERCISEDOPTIONS_TEMP3) >0)
			BEGIN

				INSERT INTO MailerDB..MailSpool
				(
					[MessageID],
					[From], [To], [Subject], [Description]
				)		
				VALUES
				(
					(SELECT MAX([MessageID]) + 1 FROM MailerDB..MailSpool),
					@FromMailID, @ToMailID, @MailSubject, @MailBody				
				)
						
			END
						
			DROP TABLE #SHEXERCISEDOPTIONS_TEMP1
			DROP TABLE #SHEXERCISEDOPTIONS_TEMP2
			DROP TABLE #SHEXERCISEDOPTIONS_TEMP3
		END
	END
END
GO
