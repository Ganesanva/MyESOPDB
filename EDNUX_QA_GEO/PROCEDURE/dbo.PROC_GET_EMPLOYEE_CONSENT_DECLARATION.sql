/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_CONSENT_DECLARATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMPLOYEE_CONSENT_DECLARATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_CONSENT_DECLARATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_EMPLOYEE_CONSENT_DECLARATION]
	@EmployeeID		VARCHAR(20) NULL,
	@Category		VARCHAR(20) NULL,
	@FromDate		DATETIME	NULL,
	@ToDate			DATETIME	NULL
AS
BEGIN
SET NOCOUNT ON;	
	
	BEGIN TRY
		BEGIN /*[VARIABLE DECLARATION]*/
			DECLARE @query NVARCHAR(MAX), @EmpCondition NVARCHAR(MAX), 
			@CategoryCondition NVARCHAR(MAX),@dateCondition NVARCHAR(MAX),@allCondition NVARCHAR(MAX)		
		END

		BEGIN /*[COMMON VALIDATION OR FILTER FOR PROCEDURE]*/
			SET @Category = CASE WHEN @Category ='---All Category---'THEN '' ELSE @Category END
			SET @EmployeeID = CASE WHEN @EmployeeID ='---All Employees---' THEN '' ELSE @EmployeeID END
		END

		BEGIN /*[PARAMETER FILTER /SET CONDITION IF ITS NOT BLANK AND CONVERT DATE INTO ACCEPTABLE FORMAT]*/
			IF(ISNULL(@EmployeeID,'') <> '' AND ISNULL(@EmployeeID,'') IS NOT NULL AND ISNULL(@EmployeeID,'') <> 'NULL')
				BEGIN
					SET @Empcondition ='CC.EmployeeID='''+@EmployeeID+''
				END
			IF(ISNULL(@Category,'') <> '' AND ISNULL(@Category,'') IS NOT NULL AND ISNULL(@Category,'') <> 'NULL')
				BEGIN
					IF(ISNULL(@EmployeeID,'') <> '' AND ISNULL(@EmployeeID,'') IS NOT NULL AND ISNULL(@EmployeeID,'') <> 'NULL')
					BEGIN
						SET @CategoryCondition ='CC.Category='''+@Category+''''
					END
				ELSE
					BEGIN
						SET @CategoryCondition ='CC.Category='''+@Category+''
					END
				END
			IF((ISNULL(@FromDate,'') IS NOT NULL AND @FromDate <> '')  AND (ISNULL(@ToDate,'') IS NOT NULL AND @ToDate <> ''))
				BEGIN
					SET @dateCondition ='CONVERT(char(10), CC.AcceptanceDate,126) BETWEEN CONVERT(char(10), '''+CONVERT(CHAR(10), @FromDate,126)+''',126)'+ ' AND ' + 'CONVERT(char(10), '''+CONVERT(CHAR(10), @ToDate,126)+''',126)'		
				END
			ELSE IF(ISNULL(@FromDate,'') IS NOT NULL AND @FromDate <> '') 
				BEGIN
					SET @dateCondition ='CONVERT(char(10), CC.AcceptanceDate,126) >= CONVERT(char(10), '''+CONVERT(CHAR(10), @FromDate,126)+''',126)'
				END
			ELSE IF(ISNULL(@ToDate,'') IS NOT NULL AND @ToDate <> '') 
				BEGIN	
					set @dateCondition ='CONVERT(char(10), CC.AcceptanceDate,126) <= CONVERT(char(10), '''+CONVERT(CHAR(10), @ToDate,126)+''',126)'
				END
		END
				
		BEGIN /*[COMBINE CONDITIONS IF THEY ARE NOT NULL]*/
			IF((ISNULL(@EmployeeID,'') <> '' AND ISNULL(@EmployeeID,'') IS NOT NULL AND ISNULL(@EmployeeID,'') <> 'NULL')
				AND (ISNULL(@Category,'') <> '' AND ISNULL(@Category,'') IS NOT NULL AND ISNULL(@Category,'') <> 'NULL'))
				BEGIN
					/*print 'emp,category not null'*/
					SELECT @allCondition = @EmpCondition+'''' +  ' AND ' + @CategoryCondition
				END
			ELSE IF(ISNULL(@EmployeeID,'') <> '' AND ISNULL(@EmployeeID,'') IS NOT NULL AND ISNULL(@EmployeeID,'') <> 'NULL')
				BEGIN
					/*print 'emp not null'*/
					SELECT @allCondition = @EmpCondition+''''
				END
			ELSE IF(ISNULL(@Category,'') <> '' AND ISNULL(@Category,'') IS NOT NULL AND ISNULL(@Category,'') <> 'NULL')
				BEGIN
					/*print 'category not null'*/
					SELECT @allCondition = @CategoryCondition+''''
				END
			IF((ISNULL(@FromDate,'') IS NOT NULL AND @FromDate <> '')  AND (ISNULL(@ToDate,'') IS NOT NULL AND @ToDate <> ''))
				BEGIN
					/*print 'from date, todate not null'*/
					SELECT @allCondition = @dateCondition+''
				END
			IF((ISNULL(@EmployeeID,'') IS NOT NULL AND @EmployeeID <> '')  AND (ISNULL(@dateCondition,'') IS NOT NULL AND @dateCondition <> ''))
				BEGIN
					/*print 'EmpId, from date, todate not null'*/
					 SELECT @allCondition = @EmpCondition+'''' +  ' AND ' + @dateCondition		 
				END
			ELSE IF((ISNULL(@CategoryCondition,'') IS NOT NULL AND @CategoryCondition <> '')  AND (ISNULL(@dateCondition,'') IS NOT NULL AND @dateCondition <> ''))
				BEGIN
					 /*print 'category, from date, todate not null'*/
					 SELECT @allCondition = @CategoryCondition+'''' +  ' AND ' + @dateCondition		 
				END
			ELSE IF((ISNULL(@FromDate,'') IS NOT NULL AND @FromDate <> ''))
				BEGIN
					/*print 'from date not null'*/
					SELECT @allCondition = @dateCondition+''
				END
			ELSE IF((ISNULL(@ToDate,'') IS NOT NULL AND @ToDate <> ''))
				BEGIN
					/*print 'todate not null'*/
					SELECT @allCondition = @dateCondition+''
				END
			IF((ISNULL(@EmployeeID,'') IS NOT NULL AND @EmployeeID <> '') AND (ISNULL(@CategoryCondition,'') IS NOT NULL AND @CategoryCondition <> '')  AND (ISNULL(@dateCondition,'') IS NOT NULL AND @dateCondition <> ''))
				BEGIN
					/*print 'EMP,category, from date, todate not null'*/
					 SELECT @allCondition = @EmpCondition+'''' +  ' AND ' + @CategoryCondition+'' +  ' AND ' + @dateCondition					 
				END
			
		END
		
		BEGIN /*[GET DATA AS PER CONDITION]*/
			IF(ISNULL(@EmpCondition,'') <> '' AND ISNULL(@EmpCondition,'') IS NOT NULL AND ISNULL(@EmpCondition,'') <> 'NULL')				BEGIN
					/*PRINT 'IF EMPLOYEE ID IS NOT BLANK THEN WE CAN GET DATE OF CHANGE IN CATEGORY'*/
					SET @query='SELECT 
								Row_Number() Over ( Order By EM.EmployeeID ) As [Sr.No.], EM.LoginID,EM.EmployeeID,EM.EmployeeName,
								Category, ISNULL(CC.[Date of change in category],''NA'') AS [Date of change in category],
								REPLACE(CONVERT(NVARCHAR,AcceptanceDate,106), '' '',''/'') AS AcceptanceDate
						FROM 
								CompanyConsent AS CC
								INNER JOIN EmployeeMaster AS EM ON CC.EmployeeID = EM.EmployeeID
								WHERE '+@allCondition+''								
				END
			ELSE IF
				(
					(ISNULL(@CategoryCondition,'') <> '' AND ISNULL(@CategoryCondition,'') IS NOT NULL AND ISNULL(@CategoryCondition,'NULL') <> 'NULL')
					OR 
					(ISNULL(@dateCondition,'') <> '' AND ISNULL(@dateCondition,'') IS NOT NULL AND ISNULL(@dateCondition,'') <> 'NULL')
					OR
					(ISNULL(@EmpCondition,'') <> '' AND ISNULL(@EmpCondition,'') IS NOT NULL AND ISNULL(@EmpCondition,'') <> 'NULL')
				)
				BEGIN
					/*PRINT 'IF CATEGOTY OR DATE IS NOT BLANK THEN'*/
					SET @query='
						SELECT 
								Row_Number() Over ( Order By EM.EmployeeID ) As [Sr.No.], EM.LoginID,EM.EmployeeID,EM.EmployeeName,
								Category, ISNULL(CC.[Date of change in category],''NA'') AS [Date of change in category],
								REPLACE(CONVERT(NVARCHAR,AcceptanceDate,106), '' '',''/'') AS AcceptanceDate
						FROM 
								CompanyConsent AS CC
								INNER JOIN EmployeeMaster AS EM ON CC.EmployeeID = EM.EmployeeID
								WHERE '+@allCondition+''								 
				END
			ELSE
				BEGIN
					/*PRINT 'No filter / Company Level'*/
					SET @query='SELECT 
								Row_Number() Over ( Order By EM.EmployeeID ) As [Sr.No.], EM.LoginID, EM.EmployeeID, EM.EmployeeName,
								Category, ISNULL(CC.[Date of change in category],''NA'') AS [Date of change in category],
								REPLACE(CONVERT(NVARCHAR,AcceptanceDate,106), '' '',''/'') AS AcceptanceDate
						FROM 
								CompanyConsent AS CC
								INNER JOIN EmployeeMaster AS EM ON CC.EmployeeID = EM.EmployeeID'
				END
		END
		
		BEGIN TRY/*EXECUTE DYNAMIC QUERY*/
			EXEC (@query)
		END TRY
		BEGIN CATCH
			SELECT ERROR_MESSAGE() AS ErrorMsg, @query AS Query, @allCondition AS Condition
		END CATCH

	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS ErrorMsg
	END CATCH

SET NOCOUNT OFF;
END
GO
