/****** Object:  StoredProcedure [dbo].[PROC_GET_BROKER_VERFICATION_STATUS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_BROKER_VERFICATION_STATUS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_BROKER_VERFICATION_STATUS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_BROKER_VERFICATION_STATUS]
(
	@EmployeeId VARCHAR(200) NULL,
	@BrokerAccountId VARCHAR(200) NULL,
	@Status VARCHAR(20) NULL
)
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN /*[VARIABLE DECLARATION]*/
			DECLARE @query NVARCHAR(MAX), @EmpCondition NVARCHAR(MAX), 
			@BrokerAccountIdCondition NVARCHAR(MAX),@StatusCondition NVARCHAR(MAX),@allCondition NVARCHAR(MAX)		
		END

		BEGIN /*[COMMON VALIDATION OR FILTER FOR PROCEDURE]*/
			SET @EmployeeID = CASE WHEN @EmployeeID ='---All Employees---' THEN '' ELSE @EmployeeID END			
		END
		BEGIN /*[COMMON VALIDATION OR FILTER FOR PROCEDURE]*/
			SET @BrokerAccountId = CASE WHEN @BrokerAccountId ='---All Broker Account Ids---' THEN '' ELSE @BrokerAccountId END
		END
		BEGIN /*[COMMON VALIDATION OR FILTER FOR PROCEDURE]*/
			SET @Status = 
			CASE 
				WHEN @Status ='V' THEN '1' WHEN @Status ='I' THEN '0'
				WHEN @Status ='---All Status---' THEN '' ELSE @Status 
			END
			
		END
		
		BEGIN /*[PARAMETER FILTER /SET CONDITION IF ITS NOT BLANK AND CONVERT DATE INTO ACCEPTABLE FORMAT]*/
			IF(ISNULL(@EmployeeID,'') <> '' OR ISNULL(@EmployeeID,'') IS NOT NULL OR ISNULL(@EmployeeID,'') <> 'NULL')	-- WHEN EMPLOYEE ID IS NOT EMPTY		
				BEGIN
					SET @Empcondition ='ED.EMPLOYEE_ID='''+@EmployeeID 
				END			
			IF(ISNULL(@BrokerAccountId,'') <> '' AND ISNULL(@BrokerAccountId,'') IS NOT NULL AND ISNULL(@BrokerAccountId,'') <> 'NULL') -- WHEN BROKER ACCOUNT ID IS NOT EMPTY
				BEGIN
					SET @BrokerAccountIdCondition ='ED.EMPLOYEE_BROKER_ACC_ID ='+@BrokerAccountId
				END
			 IF(ISNULL(@Status,'') <> '' AND ISNULL(@Status,'') IS NOT NULL AND ISNULL(@Status,'') <> 'NULL' AND @Status = 1) -- WHEN STATUS IS NOT EMPTY
				BEGIN						
					SET @StatusCondition ='ISNULL(ED.IsValidBrokerAcc,0)= '+@Status
				END			
			--IF((ISNULL(@EmployeeID,'') <> '' AND ISNULL(@EmployeeID,'') IS NOT NULL AND ISNULL(@EmployeeID,'') <> 'NULL')
			--    OR (ISNULL(@BrokerAccountId,'') <> '' AND ISNULL(@BrokerAccountId,'') IS NOT NULL AND ISNULL(@BrokerAccountId,'') <> 'NULL')
			--	AND (@Status IS NULL OR @Status = 0 OR @Status = '')) -- WHEN STATUS IS EMPTY OR NULL OR ZERO				
			--   BEGIN			   
			--	 SET @Status = 0			
			--	 SET @StatusCondition ='ISNULL(ED.IsValidBrokerAcc,0)= '+@Status
			--   END
		END	
		
		BEGIN /*[COMBINE CONDITIONS IF THEY ARE NOT NULL]*/
			IF(ISNULL(@EmployeeID,'') <> '' AND ISNULL(@EmployeeID,'') IS NOT NULL AND ISNULL(@EmployeeID,'') <> 'NULL')
				BEGIN
					SELECT @allCondition = @EmpCondition+''''
				END				
				
			IF(ISNULL(@BrokerAccountId,'') <> '' AND ISNULL(@BrokerAccountId,'') IS NOT NULL AND ISNULL(@BrokerAccountId,'') <> 'NULL')
				BEGIN			
					SELECT @allCondition = @BrokerAccountIdCondition
				END
				
			IF(ISNULL(@Status,'') <> '' AND ISNULL(@Status,'') IS NOT NULL AND ISNULL(@Status,'') <> 'NULL')
				BEGIN
					 SELECT @allCondition = @StatusCondition
				END
				
			IF((ISNULL(@EmployeeID,'') IS NOT NULL AND @EmployeeID <> '')  AND (ISNULL(@BrokerAccountIdCondition,'')) IS NOT NULL AND (ISNULL(@Status,0) = 0))
				BEGIN				
					 SELECT @allCondition = @EmpCondition+'''' 
				END
				

			IF((ISNULL(@EmployeeID,'') IS NOT NULL AND @EmployeeID <> '')  AND (ISNULL(@BrokerAccountIdCondition,'') IS NOT NULL AND @BrokerAccountIdCondition <> ''))
				BEGIN
					 SELECT @allCondition = @EmpCondition+'''' +  ' AND ' + @BrokerAccountIdCondition 
				END				 

			
			IF((ISNULL(@EmployeeID,'') = '') AND (ISNULL(@Status,'') IS NOT NULL AND @Status <> ''))
				BEGIN
					 SELECT @allCondition = @EmpCondition+'''' + ' AND ' + @StatusCondition					 
				END
			IF((ISNULL(@EmployeeID,'') = '') AND (ISNULL(@BrokerAccountId,'') = '') AND (ISNULL(@Status,'') IS NOT NULL AND @Status <> ''))
				BEGIN
					 SELECT @allCondition =  @StatusCondition					 
				END
			IF((ISNULL(@EmployeeID,'') IS NOT NULL AND @EmployeeID <> '') AND (ISNULL(@Status,'') IS NOT NULL AND @Status <> ''))
				BEGIN
					 SELECT @allCondition = @EmpCondition+'''' + ' AND ' + @StatusCondition					 
				END	
			IF((ISNULL(@BrokerAccountId,'') IS NOT NULL AND @BrokerAccountId <> '')   AND (ISNULL(@Status,'') IS NOT NULL AND @Status <> ''))
				BEGIN
					 SELECT @allCondition = @BrokerAccountIdCondition+'' +  ' AND ' + @StatusCondition
				END
				
			IF((ISNULL(@EmployeeID,'') IS NOT NULL AND @EmployeeID <> '') AND (ISNULL(@BrokerAccountIdCondition,0) IS NOT NULL AND @BrokerAccountIdCondition <> '') AND (ISNULL(@StatusCondition,'') IS NOT NULL AND @StatusCondition <> ''))
				BEGIN
					 SELECT @allCondition = @EmpCondition+'''' +  ' AND ' + @BrokerAccountIdCondition  + ' AND ' + @StatusCondition					 
				END		
			IF((ISNULL(@EmployeeID,'') IS NOT NULL AND @EmployeeID <> '') AND (ISNULL(@BrokerAccountIdCondition,0) IS NOT NULL AND @BrokerAccountIdCondition <> '') AND ((@Status IS NULL) OR @Status = NULL OR @Status = 0))
			BEGIN
					SELECT @allCondition = @EmpCondition+'''' +  ' AND ' + @BrokerAccountIdCondition  --+ ' AND ' + @StatusCondition					 
			END		

		END
	
		IF(ISNULL(@allCondition,'') IS NOT NULL AND @allCondition <> '')
			BEGIN
			SET @query=
				'SELECT EM.EmployeeID, EM.EmployeeName, CONVERT(NVARCHAR(200),ISNULL(ED.EMPLOYEE_BROKER_ACC_ID,0)) AS [BrokerAccountId],
					 ED.BROKER_DEP_TRUST_CMP_NAME AS [BROKER_TRUST_CMP_NAME],ED.BROKER_DEP_TRUST_CMP_ID AS [BROKER_TRUST_CMP_ID],
					 ED.BROKER_ELECT_ACC_NUM AS [BROKER_ELECT_ACC_NUM],		
					CASE 
						WHEN 
							ISNULL(ED.IsValidBrokerAcc,1) = 1 AND ED.IsValidBrokerAcc IS NOT NULL THEN ''V'' 
						WHEN 
							ISNULL(ED.IsValidBrokerAcc,0) = 0 OR ED.IsValidBrokerAcc IS NULL THEN ''I''
					ELSE '''' 
					END 
						  AS [BrokerStatus]						
					FROM 
						EmployeeMaster EM
					INNER JOIN Employee_UserBrokerDetails ED ON  ED.EMPLOYEE_ID=EM.EmployeeID AND ED.IS_ACTIVE= 1
					WHERE EM.deleted = 0 AND ' + @allCondition +' 
					ORDER BY ED.EMPLOYEE_ID ASC'
				
				BEGIN TRY/*EXECUTE DYNAMIC QUERY*/				
				EXEC (@query)
				END TRY
				BEGIN CATCH
					SELECT ERROR_MESSAGE() AS ErrorMsg, @query AS Query, @allCondition AS Condition
				END CATCH

			END
		ELSE
			BEGIN
				SELECT EM.EmployeeID, EM.EmployeeName, CONVERT(NVARCHAR(50),ISNULL(ED.EMPLOYEE_BROKER_ACC_ID,0)) AS [BrokerAccountId],
					 ED.BROKER_DEP_TRUST_CMP_NAME AS [BROKER_TRUST_CMP_NAME],ED.BROKER_DEP_TRUST_CMP_ID AS [BROKER_TRUST_CMP_ID],
					 ED.BROKER_ELECT_ACC_NUM AS [BROKER_ELECT_ACC_NUM],	
					CASE 
						WHEN 
							ISNULL(ED.IsValidBrokerAcc,1) = 1 AND ED.IsValidBrokerAcc IS NOT NULL THEN 'V' 
						WHEN 
							ISNULL(ED.IsValidBrokerAcc,0) = 0 OR ED.IsValidBrokerAcc IS NULL THEN 'I'
					ELSE '' 
					END 
					    AS [BrokerStatus]						
	
					FROM 
						EmployeeMaster EM
					INNER JOIN Employee_UserBrokerDetails ED ON EM.EmployeeID=ED.EMPLOYEE_ID AND ED.IS_ACTIVE=1					
					WHERE EM.DELETED =0
					ORDER BY EM.EmployeeID ASC
			END
	END TRY 
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS ErrorMsg
	END CATCH

	SET NOCOUNT OFF;
END	
GO
