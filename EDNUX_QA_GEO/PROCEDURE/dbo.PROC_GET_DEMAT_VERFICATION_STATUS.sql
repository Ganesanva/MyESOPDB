/****** Object:  StoredProcedure [dbo].[PROC_GET_DEMAT_VERFICATION_STATUS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_DEMAT_VERFICATION_STATUS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_DEMAT_VERFICATION_STATUS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_DEMAT_VERFICATION_STATUS]
(
	@EmployeeId VARCHAR(20) NULL,
	@DematId VARCHAR(20) NULL,
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
			SET @DematId = CASE WHEN @DematId ='---All Demat Ids---' THEN '' ELSE @DematId END
		END
		BEGIN /*[COMMON VALIDATION OR FILTER FOR PROCEDURE]*/
			SET @Status = 
			CASE 
				WHEN @Status ='V' THEN '1' WHEN @Status ='I' THEN '0'
				WHEN @Status ='---All Status---' THEN '' ELSE @Status 
			END
		END
		
		BEGIN /*[PARAMETER FILTER /SET CONDITION IF ITS NOT BLANK AND CONVERT DATE INTO ACCEPTABLE FORMAT]*/
			IF(ISNULL(@EmployeeID,'') <> '' AND ISNULL(@EmployeeID,'') IS NOT NULL AND ISNULL(@EmployeeID,'') <> 'NULL')
				BEGIN
					SET @Empcondition ='EM.EmployeeID='''+@EmployeeID+''
				END
			IF(ISNULL(@DematId,'') <> '' AND ISNULL(@DematId,'') IS NOT NULL AND ISNULL(@DematId,'') <> 'NULL')
				BEGIN
					SET @DematIdCondition ='ED.EmployeeDematId='+@DematId
				END
			IF(ISNULL(@Status,'') <> '' AND ISNULL(@Status,'') IS NOT NULL AND ISNULL(@Status,'') <> 'NULL')
				BEGIN
					SET @StatusCondition ='ED.IsValidDematAcc='+@Status
				END
		END

		BEGIN /*[COMBINE CONDITIONS IF THEY ARE NOT NULL]*/
			IF(ISNULL(@EmployeeID,'') <> '' AND ISNULL(@EmployeeID,'') IS NOT NULL AND ISNULL(@EmployeeID,'') <> 'NULL')
				BEGIN
					SELECT @allCondition = @EmpCondition+''''
				END
			IF(ISNULL(@DematId,'') <> '' AND ISNULL(@DematId,'') IS NOT NULL AND ISNULL(@DematId,'') <> 'NULL')
				BEGIN
					SELECT @allCondition = @DematIdCondition
				END
			IF(ISNULL(@Status,'') <> '' AND ISNULL(@Status,'') IS NOT NULL AND ISNULL(@Status,'') <> 'NULL')
				BEGIN
					 SELECT @allCondition = @StatusCondition
				END

			IF((ISNULL(@EmployeeID,'') IS NOT NULL AND @EmployeeID <> '')  AND (ISNULL(@DematIdCondition,0) IS NOT NULL AND @DematIdCondition <> ''))
				BEGIN
					 SELECT @allCondition = @EmpCondition+'''' +  ' AND ' + @DematIdCondition
				END
			IF((ISNULL(@EmployeeID,'') IS NOT NULL AND @EmployeeID <> '') AND (ISNULL(@StatusCondition,'') IS NOT NULL AND @StatusCondition <> ''))
				BEGIN
					 SELECT @allCondition = @EmpCondition+'''' + ' AND ' + @StatusCondition					 
				END
			IF((ISNULL(@DematId,'') IS NOT NULL AND @DematId <> '')  AND (ISNULL(@Status,0) IS NOT NULL AND @Status <> ''))
				BEGIN
					 SELECT @allCondition = @DematIdCondition+'' +  ' AND ' + @StatusCondition
				END
			IF((ISNULL(@EmployeeID,'') IS NOT NULL AND @EmployeeID <> '') AND (ISNULL(@DematIdCondition,0) IS NOT NULL AND @DematIdCondition <> '') AND (ISNULL(@StatusCondition,'') IS NOT NULL AND @StatusCondition <> ''))
				BEGIN
					 SELECT @allCondition = @EmpCondition+'''' +  ' AND ' + @DematIdCondition + ' AND ' + @StatusCondition					 
				END
		END
		IF(ISNULL(@allCondition,'') IS NOT NULL AND @allCondition <> '')
			BEGIN
			SET @query=
				'SELECT EM.EmployeeID, EM.EmployeeName, CONVERT(NVARCHAR(20),ISNULL(ED.EmployeeDematId,0)) AS [Demat Id],
					CASE 
					   WHEN ED.DepositoryName=''N'' THEN ''NSDL''
					   WHEN ED.DepositoryName=''C'' THEN ''CDSL''
					   ELSE '''' 
					END AS [Depository Name],
					CASE 
					   WHEN ED.DematAccountType=''R'' THEN ''Repatriable''
					   WHEN ED.DematAccountType=''N'' OR ED.DematAccountType=''NR'' THEN ''Non-Repatriable''
					   WHEN ED.DematAccountType=''A'' THEN ''Not Applicable''
					   ELSE ''''
					END AS [Account Type], ED.DepositoryParticipantName AS [DP Name],ED.DepositoryIDNumber AS [DP Id],
					ED.ClientIDNumber AS [Client Id], ED.DPRecord AS [Name as in DP records],	
					CASE 
						WHEN 
							ISNULL(ED.IsValidDematAcc,'''') = 1 THEN ''V'' 
						WHEN 
							ISNULL(ED.IsValidDematAcc,'''') = 0 THEN ''I''
					ELSE '''' 
					END 
						AS [Is Valid Demat Acc]
					FROM 
						EmployeeMaster EM
					LEFT JOIN Employee_UserDematDetails ED ON EM.EmployeeID=ED.EmployeeID AND ED.IsActive=1					
					WHERE EM.deleted = 0 AND ' + @allCondition +'
					ORDER BY EM.EmployeeID ASC'
				
				BEGIN TRY/*EXECUTE DYNAMIC QUERY*/
				EXEC (@query)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS ErrorMsg, @query AS Query, @allCondition AS Condition
				END CATCH

			END
		ELSE
			BEGIN
				SELECT EM.EmployeeID, EM.EmployeeName, CONVERT(NVARCHAR(50),ISNULL(ED.EmployeeDematId,0)) AS [Demat Id],
					CASE 
					   WHEN ED.DepositoryName='N' THEN 'NSDL'
					   WHEN ED.DepositoryName='C' THEN 'CDSL'
					   ELSE '' 
					END AS [Depository Name],
					CASE 
					   WHEN ED.DematAccountType='R' THEN 'Repatriable'
					   WHEN ED.DematAccountType='N' OR ED.DematAccountType='NR' THEN 'Non-Repatriable'
					   WHEN ED.DematAccountType='A' THEN 'Not Applicable'
					   ELSE '' 
					END AS [Account Type], ED.DepositoryParticipantName AS [DP Name],ED.DepositoryIDNumber AS [DP Id],
					ED.ClientIDNumber AS [Client Id], ED.DPRecord AS [Name as in DP records],	
					CASE 
						WHEN 
							ISNULL(ED.IsValidDematAcc,'') = 1 THEN 'V' 
						WHEN 
							ISNULL(ED.IsValidDematAcc,'') = 0 THEN 'I'
					ELSE '' 
					END 
						AS [Is Valid Demat Acc]
	
					FROM 
						EmployeeMaster EM
					LEFT JOIN Employee_UserDematDetails ED ON EM.EmployeeID=ED.EmployeeID AND ED.IsActive=1					
					WHERE EM.deleted =0
					ORDER BY EM.EmployeeID ASC
			END
	END TRY 
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS ErrorMsg
	END CATCH

	SET NOCOUNT OFF;
END	
GO
