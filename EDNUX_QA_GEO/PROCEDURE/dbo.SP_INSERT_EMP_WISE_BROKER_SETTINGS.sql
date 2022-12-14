/****** Object:  StoredProcedure [dbo].[SP_INSERT_EMP_WISE_BROKER_SETTINGS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_INSERT_EMP_WISE_BROKER_SETTINGS]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_EMP_WISE_BROKER_SETTINGS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INSERT_EMP_WISE_BROKER_SETTINGS] 
(
	@EMPLOYEEID AS VARCHAR(50),
	@COMPANYID AS VARCHAR(50)
)
AS

BEGIN

SELECT	[ID],
		[BrokerCompanyName], 
		[BrokerCompanyID],
		[BrokerElectAccountNo]
			INTO #TEMP FROM             
    (SELECT * FROM ConfigurePersonalDetails	PIVOT 
		(MAX(CHECK_TOEMP) FOR EMPLOYEEFIELD IN ([BrokerCompanyName], [BrokerCompanyID],[BrokerElectAccountNo])) AS PVTVAL
		 WHERE ID IN (27,28,29)) PVTDATA 

	BEGIN TRANSACTION
	IF NOT EXISTS (SELECT EMPLOYEEID FROM BROKER_SETTINGS WHERE EMPLOYEEID=@EMPLOYEEID)
		BEGIN
		
		UPDATE #Temp SET  [BrokerCompanyName] = (select TOP 1 [BrokerCompanyName] from  #Temp WHERE [BrokerCompanyName] IS NOT NULL)
		UPDATE #Temp SET  [BrokerCompanyID] = (select TOP 1 [BrokerCompanyID] from  #Temp WHERE [BrokerCompanyID] IS NOT NULL)
		UPDATE #Temp SET  [BrokerElectAccountNo] = (select TOP 1 [BrokerElectAccountNo] from  #Temp WHERE [BrokerElectAccountNo] IS NOT NULL)
		
		INSERT INTO BROKER_SETTINGS select TOP 1 @EMPLOYEEID, [BrokerCompanyName], [BrokerCompanyID],[BrokerElectAccountNo] from #Temp
		END
		COMMIT TRANSACTION	
		
	DROP TABLE #TEMP
	
END


GO
