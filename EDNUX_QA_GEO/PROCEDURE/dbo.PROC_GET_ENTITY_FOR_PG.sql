/****** Object:  StoredProcedure [dbo].[PROC_GET_ENTITY_FOR_PG]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_ENTITY_FOR_PG]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_ENTITY_FOR_PG]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_ENTITY_FOR_PG]
( 
	@EMPLOYEE_ID	NVARCHAR(50),
	@FROM_DATE		DATETIME,
	@TO_DATE		DATETIME,
	@FIELD_NAME		NVARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY		
		
		CREATE TABLE #TEMP_ENTITY_DATA
		(
			SRNO BIGINT, FIELD NVARCHAR(100), EMPLOYEEID NVARCHAR(100), EMPLOYEENAME NVARCHAR(500), 
			EMP_STATUS NVARCHAR(50), ENTITY NVARCHAR(500), FROMDATE DATETIME, TODATE DATETIME, CREATED_ON DATE
		)
		
		INSERT INTO #TEMP_ENTITY_DATA 
		(
			SRNO, FIELD, EMPLOYEEID, EMPLOYEENAME, EMP_STATUS, ENTITY, FROMDATE, TODATE, CREATED_ON
		)	
		EXEC PROC_EMP_MOVEMENT_TRANSFER_REPORT 'Entity'
		
		SELECT 
			EMPLOYEEID AS EMPLOYEE_ID, ENTITY AS FIELD_NAME, FROMDATE AS FROM_DATE, TODATE AS TO_DATE 
		FROM 
			#TEMP_ENTITY_DATA
		WHERE 
			EMPLOYEEID = @EMPLOYEE_ID AND
			(CONVERT(DATE,@FROM_DATE) BETWEEN CONVERT(DATE,FROMDATE) AND CONVERT(DATE, ISNULL(TODATE, GETDATE())))
									
	END TRY
	BEGIN CATCH
		SELECT 'Error'
		RETURN 0
	END CATCH

	SET NOCOUNT OFF;
END
GO
