/****** Object:  Table [dbo].[FMVForUnlisted]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FMVForUnlisted]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FMVForUnlisted](
	[FMV] [numeric](18, 2) NOT NULL,
	[FMV_FromDate] [datetime] NOT NULL,
	[FMV_Todate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[Updatedon] [datetime] NOT NULL,
	[Scheme_Id] [varchar](50) NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantRegistration_Id] [varchar](20) NULL
) ON [PRIMARY]
END
GO
