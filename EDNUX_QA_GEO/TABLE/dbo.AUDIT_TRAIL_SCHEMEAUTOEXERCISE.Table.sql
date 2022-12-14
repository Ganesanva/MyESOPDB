/****** Object:  Table [dbo].[AUDIT_TRAIL_SCHEMEAUTOEXERCISE]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUDIT_TRAIL_SCHEMEAUTOEXERCISE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AUDIT_TRAIL_SCHEMEAUTOEXERCISE](
	[ATSAE_ID] [int] IDENTITY(1,1) NOT NULL,
	[AEC_ID] [int] NOT NULL,
	[SchemeId] [nvarchar](50) NOT NULL,
	[IS_Update] [tinyint] NULL,
	[Field_Name] [nvarchar](100) NULL,
	[Old_value] [nvarchar](100) NULL,
	[New_Value] [nvarchar](100) NULL,
	[Created_By] [nvarchar](100) NOT NULL,
	[Created_On] [datetime] NOT NULL,
	[Updated_By] [nvarchar](100) NOT NULL,
	[Updated_On] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
