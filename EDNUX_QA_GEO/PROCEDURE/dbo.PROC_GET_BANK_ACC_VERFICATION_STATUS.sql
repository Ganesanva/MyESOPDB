/****** Object:  StoredProcedure [dbo].[PROC_GET_BANK_ACC_VERFICATION_STATUS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_BANK_ACC_VERFICATION_STATUS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_BANK_ACC_VERFICATION_STATUS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_BANK_ACC_VERFICATION_STATUS]
(
	@EmployeeId VARCHAR(20) NULL,	
	@Status VARCHAR(20) NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN /*[VARIABLE DECLARATION]*/
			DECLARE @query NVARCHAR(MAX), @EmpCondition NVARCHAR(MAX), 
			@DematIdCondition NVARCHAR(MAX),@StatusCondition NVARCHAR(MAX),@allCondition NVARCHAR(MAX)		
		END

		BEGIN /*[COMMON VALIDATION OR FILTER FOR PROCEDURE]*/
			SET @EmployeeID = CASE WHEN @EmployeeID ='---All Employees---' THEN '' ELSE @EmployeeID END
		END
		BEGIN /*[COMMON VALIDATION OR FILTER FOR PROCEDURE]*/
			SET @Status = 
				CASE 
					WHEN @Status ='YES' THEN '1' WHEN @Status ='NO' THEN '0'
					WHEN @Status ='---All Status---' THEN '' ELSE @Status 
				END
		END
		
		BEGIN /*[PARAMETER FILTER /SET CONDITION IF ITS NOT BLANK AND CONVERT DATE INTO ACCEPTABLE FORMAT]*/
			IF(ISNULL(@EmployeeID,'') <> '' AND ISNULL(@EmployeeID,'') IS NOT NULL AND ISNULL(@EmployeeID,'') <> 'NULL')
				BEGIN
					SET @Empcondition ='EM.EmployeeID='''+@EmployeeID+''
				END			
			IF(ISNULL(@Status,'') <> '' AND ISNULL(@Status,'') IS NOT NULL AND ISNULL(@Status,'') <> 'NULL')
				BEGIN
					SET @StatusCondition ='EM.IsValidBankAcc='+@Status
				END
		END

		BEGIN /*[COMBINE CONDITIONS IF THEY ARE NOT NULL]*/
			IF(ISNULL(@EmployeeID,'') <> '' AND ISNULL(@EmployeeID,'') IS NOT NULL AND ISNULL(@EmployeeID,'') <> 'NULL')
				BEGIN
					SELECT @allCondition = @EmpCondition+''''
				END
			IF(ISNULL(@Status,'') <> '' AND ISNULL(@Status,'') IS NOT NULL AND ISNULL(@Status,'') <> 'NULL')
				BEGIN
					 SELECT @allCondition = @StatusCondition
				END
			IF((ISNULL(@EmployeeID,'') IS NOT NULL AND @EmployeeID <> '') AND (ISNULL(@StatusCondition,'') IS NOT NULL AND @StatusCondition <> ''))
				BEGIN
					 SELECT @allCondition = @EmpCondition+'''' + ' AND ' + @StatusCondition					 
				END
		END

		IF(ISNULL(@allCondition,'') IS NOT NULL AND @allCondition <> '')
			BEGIN
			SET @query=
				'SELECT EM.EmployeeID, EM.EmployeeName,
					CASE 
						WHEN 
							ISNULL(EM.IsValidBankAcc,'''') = 1 THEN ''YES'' 
						WHEN 
							ISNULL(EM.IsValidBankAcc,'''') = 0 THEN ''NO''
					ELSE '''' 
					END 
						AS [Is Valid Bank Acc]
					FROM 
						EmployeeMaster EM
					WHERE EM.deleted = 0 AND ' + @allCondition +''
				
				BEGIN TRY/*EXECUTE DYNAMIC QUERY*/
				EXEC (@query)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS ErrorMsg, @query AS Query, @allCondition AS Condition
				END CATCH

			END
		ELSE
			BEGIN
				SELECT EM.EmployeeID, EM.EmployeeName,
				CASE 
					WHEN 
						ISNULL(EM.IsValidBankAcc ,'') = 1 THEN 'YES' 
					WHEN 
							ISNULL(EM.IsValidBankAcc ,'') = 0 THEN 'NO'
					ELSE '' 
					END 
						AS [Is Valid Bank Acc]
				FROM 
					EmployeeMaster EM
				WHERE 
					EM.Deleted=0
			END
	END TRY 
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS ErrorMsg
	END CATCH

	SET NOCOUNT OFF;
END	
GO
