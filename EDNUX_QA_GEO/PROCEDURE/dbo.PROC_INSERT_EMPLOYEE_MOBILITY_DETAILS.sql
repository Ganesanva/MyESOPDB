/****** Object:  StoredProcedure [dbo].[PROC_INSERT_EMPLOYEE_MOBILITY_DETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_EMPLOYEE_MOBILITY_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_EMPLOYEE_MOBILITY_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_INSERT_EMPLOYEE_MOBILITY_DETAILS]
	-- Add the parameters for the stored procedure here
	(
			@MobilityDataTable   TYPE_DELETE_MOBILITY_DATA_TABLE READONLY,
			@IsActive      AS NVARCHAR(10),
			@CREATED_BY    AS NVARCHAR(100),		
			@UPDATED_BY    AS NVARCHAR(100),
			@MESSAGE_OUT   AS VARCHAR(50) OUTPUT
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
			INSERT INTO DELETE_EMPLOYEE_MOBILITY_MASSUPLOAD
					  ( [Field],
						[RecordID],
						[EmployeeId],
						[EmployeeName],
						[Status],
						[EntityName],
						[FromDate],
						[ToDelete],
						[ReasonForDeletion],
						[IsActive],
						[CREATED_BY],
						[CREATED_ON],
						[UPDATED_BY],
						[UPDATED_ON])				
				SELECT  Field,
						RecordID,
						EmployeeId,
						EmployeeName,
						Status,
						EntityName,
						FromDate,
						ToDelete,
						ReasonForDeletion,
						CONVERT(BIT,@IsActive),
						@CREATED_BY,
						GETDATE(),
						@UPDATED_BY,
						GETDATE()
			FROM @MobilityDataTable

			SET NOCOUNT OFF;
			SET @MESSAGE_OUT = '1'
	   END  


if @@ERROR <> 0
BEGIN
SET @MESSAGE_OUT = 'Error'
END

GO
