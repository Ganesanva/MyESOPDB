/****** Object:  StoredProcedure [dbo].[PROC_CRUDForGroupSetting]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUDForGroupSetting]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUDForGroupSetting]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUDForGroupSetting]
(
	@CompanyID			VARCHAR(80),	
	@VwMenuForGrpComp	VARCHAR(20),
	@CaseValue			CHAR 
)
AS
BEGIN
SET NOCOUNT ON;	
	DECLARE @MIN		INT=0,
			@MAX		INT=0,
			@Count		INT=0,
			@CompID		NVARCHAR(50),
			@GROUPNAME	NVARCHAR(50),
			@PARAMETER	NVARCHAR(200),
			@SQLQUERY	NVARCHAR(1000),
			@VwSetting  NVARCHAR(10)
			
	CREATE TABLE #TEMP_EMGroupCompany
	(
		TempID INT IDENTITY(1,1),
		CompanyID	VARCHAR(50),
		GroupName	VARCHAR(50),
		VwSetting	VARCHAR(10)
	)
	--===============================================================================
	-- Update ViewMenuActive setting for all company which is present into same group
	--===============================================================================
	IF (@CaseValue = 'C')
		BEGIN
			INSERT INTO 
				#TEMP_EMGroupCompany
				(
					CompanyID,GroupName,VwSetting
				)
			SELECT 
					CompanyID,GroupName,@VwMenuForGrpComp 
			FROM 
					ESOPManager..GroupCompanies 
			WHERE 
					GroupName IN (SELECT DISTINCT GroupName FROM ESOPManager..GroupCompanies WHERE CompanyID = @CompanyID)
			
			SELECT @MIN = MIN(TempID), @MAX=MAX(TempID) FROM #TEMP_EMGroupCompany
			
			WHILE(@MIN <= @MAX)
			BEGIN
				SELECT @COMPID = COMPANYID, @GROUPNAME=GroupName,@VwSetting = VwSetting FROM #TEMP_EMGROUPCOMPANY WHERE TEMPID = @MIN				
				SELECT @SQLQuery = 'UPDATE ' + @CompID +'..CompanyMaster  SET		VwMenuForGrpCompany =''' + @VwSetting +''''
				EXEC(@SQLQuery)
				IF(@@ROWCOUNT > 0)
					BEGIN
						--SELECT 'Data Updated'[Result],* FROM #TEMP_EMGroupCompany WHERE TempID = @MIN
						SELECT @SQLQuery = 'INSERT INTO '+@COMPID+'..CompanyInfoHistory
											(					
												CompanyID, CompanyName, CompanyAddress, CompanyURL, CompanyEmail, 
												AdminEmail, StockExchange, StockExchangeCode, UpdatedDate, UpdatedTime, 
												LastUpdatedBy, LastUpdatedOn, MaxLoginAttempts,IsNominationEnabled,
												IsPUPEnabled,DisplayAs,VwMenuForGrpCompany
											)
											SELECT 	CompanyID,CompanyName,CompanyAddress,CompanyURL,CompanyEmailID,AdminEmailID,
													StockExchangeType,StockExchangeCode,CONVERT(DATE,GETDATE()),GETDATE(),
													LastUpdatedBy,LastUpdatedOn,MaxLoginAttempts,IsNominationEnabled,IsPUPEnabled,
													DisplayAs,VwMenuForGrpCompany
											FROM	'+@COMPID+'..CompanyMaster'
						EXEC (@SQLQuery)
						IF(@@ROWCOUNT > 0)
							SET @COUNT = 1
						ELSE
							SET @COUNT = 0
					END
				ELSE
						SET @COUNT = 0
				SET @MIN = @MIN + 1
			END
			
			IF(@Count = 1)
				BEGIN
					SELECT 1 AS [OUTPUT], 
							CASE WHEN (@VwMenuForGrpComp='1|1|0' OR @VwMenuForGrpComp='1|0|1') 
									THEN 'Settings for the respective active group has been enabled'
								 WHEN (@VwMenuForGrpComp='1|1|1' OR @VwMenuForGrpComp='1|0|0')
									THEN 'Settings for the respective active groups have been enabled'								
							END AS [Message],
							VwMenuForGrpCompany,
							CASE WHEN VwMenuForGrpCompany='1|1|1' THEN 'ADMIN|CR|EMPLOYEE'
								 WHEN VwMenuForGrpCompany='1|1|0' THEN 'ADMIN|CR|0'
								 WHEN VwMenuForGrpCompany='1|0|1' THEN 'ADMIN|0|EMPLOYEE'
								 WHEN VwMenuForGrpCompany='1|0|0' THEN 'ADMIN|0|0'				 
							END AS [ReadVwMenuForGrpCompany]
					FROM CompanyMaster		
				END
			ELSE
				BEGIN	
					SELECT 0 AS	[OUTPUT], 
							'No changes have been made' AS [Message],
							VwMenuForGrpCompany,
							CASE WHEN VwMenuForGrpCompany = '1|1|1' THEN 'ADMIN|CR|EMPLOYEE'
								 WHEN VwMenuForGrpCompany = '1|1|0' THEN 'ADMIN|CR|0'
								 WHEN VwMenuForGrpCompany = '1|0|1' THEN 'ADMIN|0|EMPLOYEE'
								 WHEN VwMenuForGrpCompany = '1|0|0' THEN 'ADMIN|0|0'				 
							END AS [ReadVwMenuForGrpCompany]
					FROM CompanyMaster		
				END
		END
	ELSE
		BEGIN
			SELECT	
				1 AS [OUTPUT],
				'Success' [Message],
				VwMenuForGrpCompany,
				CASE WHEN VwMenuForGrpCompany='1|1|1' THEN 'ADMIN|CR|EMPLOYEE'
					 WHEN VwMenuForGrpCompany='1|1|0' THEN 'ADMIN|CR|0'
					 WHEN VwMenuForGrpCompany='1|0|1' THEN 'ADMIN|0|EMPLOYEE'
					 WHEN VwMenuForGrpCompany='1|0|0' THEN 'ADMIN|0|0'				 
				END [ReadVwMenuForGrpCompany]
			FROM	CompanyMaster
		END	
SET NOCOUNT OFF
END
GO
