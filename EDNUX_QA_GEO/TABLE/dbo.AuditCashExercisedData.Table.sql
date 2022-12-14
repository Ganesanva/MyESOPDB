/****** Object:  Table [dbo].[AuditCashExercisedData]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditCashExercisedData]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditCashExercisedData](
	[AuditCashExercisedData_ID] [int] IDENTITY(1,1) NOT NULL,
	[Exercise_Number] [varchar](100) NULL,
	[Exercise_ID] [varchar](100) NULL,
	[Perquisite_Value] [varchar](100) NULL,
	[Perquisite_Tax] [varchar](100) NULL,
	[Capital_Gain_Value] [varchar](100) NULL,
	[Capital_Gain_Tax] [varchar](100) NULL,
	[UPDATED_BY] [varchar](100) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
