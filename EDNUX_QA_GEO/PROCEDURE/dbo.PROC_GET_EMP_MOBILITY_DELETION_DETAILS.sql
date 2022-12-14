/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_MOBILITY_DELETION_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMP_MOBILITY_DELETION_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_MOBILITY_DELETION_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[PROC_GET_EMP_MOBILITY_DELETION_DETAILS] @FIELD nvarchar(130) 	
AS
	
BEGIN
	
	BEGIN TRY		
			
				CREATE TABLE #TempMobility
		(
			SRNO         INT IDENTITY(1,1),
			Field        nvarchar(100) NOT NULL,				
			EmployeeId   varchar(50) NULL,
			EmployeeName varchar(500) NULL,
			[Status]     nvarchar(50) NULL,
			EntityName   varchar(100) NULL,
			FromDate     date NULL,							
			CREATEDON    datetime NULL,			
		)
			
        INSERT INTO #TempMobility
		(
			Field, EmployeeId, EmployeeName, [Status], EntityName, FromDate, CREATEDON
		)
		SELECT 
			FIELD, EMPLOYEEID, EMPLOYEENAME, [STATUS], [Moved To], [FROM DATE OF MOVEMENT], GETDATE() 
		FROM
			AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD 
		WHERE 
			FIELD = @FIELD
		ORDER BY 
			EMPLOYEEID, CREATED_ON

		IF NOT EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME) = '#TempMobility'  AND UPPER(COLUMN_NAME) = 'TODELETE') 
		BEGIN 
			ALTER TABLE #TempMobility  ADD  TODELETE varchar(50)	
		END

		IF NOT EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME) = '#TempMobility'  AND UPPER(COLUMN_NAME) = 'REASON') 
		BEGIN 
			ALTER TABLE #TempMobility  ADD  REASON nvarchar(500)	
		END

		IF NOT EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME) = '#TempMobility'  AND UPPER(COLUMN_NAME) = 'NoId') 
		BEGIN 
			ALTER TABLE #TempMobility  ADD  RecordID bigint
		END
		
		SELECT 
			SRNO, Field, ROW_NUMBER() OVER (PARTITION BY EmployeeID ORDER BY EmployeeID) 'RecordID', EmployeeId, 
			EmployeeName, [Status], EntityName, FromDate, ToDelete, Reason 
		FROM 
			#TempMobility
			
		DROP TABLE #TempMobility

	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE()
	END CATCH
	
	SET NOCOUNT OFF;
END
GO
