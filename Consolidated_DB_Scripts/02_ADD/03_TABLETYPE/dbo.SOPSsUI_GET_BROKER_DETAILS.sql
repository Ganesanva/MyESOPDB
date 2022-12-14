
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'PROC_SOPsUI_VALIDATE_BROKER_DETAILS')
BEGIN
DROP PROCEDURE PROC_SOPsUI_VALIDATE_BROKER_DETAILS
END
GO

IF EXISTS(SELECT NAME FROM SYS.TYPES WHERE NAME = 'SOPSsUI_GET_BROKER_DETAILS')
BEGIN
DROP TYPE SOPSsUI_GET_BROKER_DETAILS
END
GO

/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_BROKER_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[SOPSsUI_GET_BROKER_DETAILS] AS TABLE(
	[EMPLOYEE_ID] [nvarchar](100) NULL,
	[BROKER_TRUST_COMPANY_NAME] [nvarchar](100) NULL,
	[BROKER_TRUST_COMPANY_ID] [nvarchar](100) NULL,
	[BROKER_ELECTRONIC_ACCOUNT_NUMBER] [nvarchar](100) NULL,
	[IS_ACTIVE] [nvarchar](10) NULL
)
GO
