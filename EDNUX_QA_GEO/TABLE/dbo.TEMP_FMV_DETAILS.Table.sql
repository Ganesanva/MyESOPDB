/****** Object:  Table [dbo].[TEMP_FMV_DETAILS]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TEMP_FMV_DETAILS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TEMP_FMV_DETAILS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[GRANTOPTIONID] [varchar](50) NULL,
	[GRANTDATE] [varchar](200) NULL,
	[VESTINGDATE] [varchar](200) NULL,
	[EXERCISE_DATE] [datetime] NULL,
	[FMV_VALUE] [float] NULL,
	[TAXFLAG] [char](1) NULL,
	[TAXFLAG_HEADER] [char](1) NULL
) ON [PRIMARY]
END
GO
