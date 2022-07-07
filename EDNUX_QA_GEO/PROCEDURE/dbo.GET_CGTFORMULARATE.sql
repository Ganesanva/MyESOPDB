/****** Object:  StoredProcedure [dbo].[GET_CGTFORMULARATE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_CGTFORMULARATE]
GO
/****** Object:  StoredProcedure [dbo].[GET_CGTFORMULARATE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GET_CGTFORMULARATE](@USERID VARCHAR(30),@EX_DATE DATE,@SELL_DATE DATE)
AS
BEGIN
DECLARE @ID INT,
	@CGT_AT CHAR,
	@RESIDETIAL_STATUS CHAR,	
	@YEAR INT,
	@DAYSINYEAR INT,
	@CGTTYPE VARCHAR(20)='LONG TERM',
	@EMPID VARCHAR(20),
	--VARIABLES USE IN QUERY	
	@CGT_RATE VARCHAR(30), --(I.E SHORT TERM OR LONG TERM)
    @CGT_RATEVALUE NUMERIC(10,2),	
	
	@PANSTATUS VARCHAR(20),
	@CGTRATEST DECIMAL(18,9),
	@CGTRATELT DECIMAL(18,9)
	
	
	CREATE TABLE #TEMP
	(
		EMPLOYEEID VARCHAR(20),
		SETTING_AT CHAR,
		CGTTYPE VARCHAR(20),
		PANSTATUS VARCHAR(20),
		CGTRATEST DECIMAL(18,9),
		CGTRATELT DECIMAL(18,9)
	)
	
	PRINT 'FETCH DATA FORM EMPLOYEE MASTER'
	
	PRINT '-----DATA PULLING START...-----'
	PRINT ''
	PRINT ''
		SELECT @RESIDETIAL_STATUS = EMPLOYEEMASTER.RESIDENTIALSTATUS, 
			   @EMPID = EmployeeMaster.EmployeeID,
			   @PANSTATUS =( CASE WHEN (EMPLOYEEMASTER.PANNUMBER IS NULL) OR (EMPLOYEEMASTER.PANNUMBER = '')
								THEN  'WITHOUT PAN'
								ELSE  'WITH PAN' 
							END )
		FROM EMPLOYEEMASTER 
		WHERE LOGINID = @USERID AND DELETED = 0
		
		SET @YEAR =(SELECT DATEPART(YY,GETDATE()))
		SET @DAYSINYEAR=(SELECT CASE WHEN (@YEAR%4)=0 THEN 366 ELSE 365 END)
			
		  --SELECT @DAYSINYEAR
		  -- DATEDIFF(DD,EXDATETIME,TRANCHECLOSEDATE) > 365   
		IF(DATEDIFF(DD,@EX_DATE,@SELL_DATE) <= 365)
		BEGIN
			 SET @CGTTYPE ='SHORT TERM' 
		END
		
		PRINT 'RESIDENTIAL STATUS :' + @RESIDETIAL_STATUS
		
		SELECT TOP 1 
				 @CGT_AT    = CGT_SETTINGS_AT,
				 @CGTRATELT = 
				 CASE WHEN @RESIDETIAL_STATUS='R' THEN RI_LTCG_RATE
					  WHEN @RESIDETIAL_STATUS='N' THEN NRI_LTCG_RATE 
					  WHEN @RESIDETIAL_STATUS='F' THEN FN_LTCG_RATE 
				 END,
				 @CGTRATEST= 
					CASE WHEN CGT_SETTINGS_AT='C' THEN -- COMPANYLEVEL
					----------------------------
					CASE WHEN @RESIDETIAL_STATUS='R' THEN  
					CASE WHEN @PANSTATUS='WITH PAN' THEN RI_STCG_RATE_WPAN 
						 WHEN @PANSTATUS='WITHOUT PAN' THEN RI_STCG_RATE_WOPAN 
					ELSE 0 END
						 WHEN @RESIDETIAL_STATUS='N' THEN
					CASE WHEN @PANSTATUS='WITH PAN' THEN NRI_STCG_RATE_WPAN 
						 WHEN @PANSTATUS='WITHOUT PAN' THEN NRI_STCG_RATE_WOPAN 
					ELSE 0 END
						 WHEN @RESIDETIAL_STATUS='F' THEN 
					CASE WHEN @PANSTATUS='WITH PAN' THEN FN_STCG_RATE_WPAN 
						 WHEN @PANSTATUS='WITHOUT PAN' THEN FN_STCG_RATE_WOPAN 
					ELSE 0 END
				 END
				 ---------------------------
				 WHEN CGT_SETTINGS_AT='E' THEN  --EMP LEVEL
				 ----------------
				 CASE
					 WHEN @PANSTATUS='WITH PAN' 
					 THEN 
						(SELECT TOP 1 CGTWITHPAN FROM CGTEMPLOYEETAX 
								WHERE EMPLOYEEID=@EMPID 
								ORDER BY CGT_ID DESC )
					 WHEN @PANSTATUS='WITHOUT PAN' 
					 THEN 
						(SELECT TOP 1 CGTWITHOUTPAN FROM CGTEMPLOYEETAX 
								WHERE EMPLOYEEID=@EMPID 
								ORDER BY CGT_ID DESC )
				 END
				 -------------------------------------------------
				 END
			 
			 FROM CGT_SETTINGS 
			 WHERE CONVERT(DATE,APPLICABLE_FROM) <= CONVERT(DATE,GETDATE())
			 ORDER BY LASTUPDATED_ON DESC
		
		
		INSERT INTO #TEMP(EMPLOYEEID,SETTING_AT,PANSTATUS,CGTRATEST,CGTRATELT,CGTTYPE)
               VALUES(@EMPID,@CGT_AT,@PANSTATUS,@CGTRATEST,@CGTRATELT,@CGTTYPE)
		
		PRINT ''
		PRINT ''
			
		PRINT '-----DATA PULLING END.-----'	
		
		SELECT * FROM #TEMP
		
		IF EXISTS        
		(        
			SELECT *        
			FROM TEMPDB.DBO.SYSOBJECTS        
			WHERE ID = OBJECT_ID(N'TEMPDB..#TEMP')        
		)        
		BEGIN        
			DROP TABLE #TEMP   
		END  		
END


GO
