/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_MOBILITY_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'PROC_SOPsUI_VALIDATE_MOBILITY_DATA')
BEGIN
DROP PROCEDURE PROC_SOPsUI_VALIDATE_MOBILITY_DATA
END
GO

IF EXISTS(SELECT NAME FROM SYS.TYPES WHERE NAME = 'SOPSsUI_GET_MOBILITY_DATA')
BEGIN
DROP TYPE SOPSsUI_GET_MOBILITY_DATA
END
GO

/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_MOBILITY_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[SOPSsUI_GET_MOBILITY_DATA] AS TABLE(
	[EMPLOYEE_ID] [nvarchar](100) NULL,
	[FIELD_MASTER] [nvarchar](50) NULL,
	[DATE_OF_MOVEMENT] [date] NULL
)
GO
