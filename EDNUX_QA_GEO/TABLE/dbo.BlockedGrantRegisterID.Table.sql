/****** Object:  Table [dbo].[BlockedGrantRegisterID]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlockedGrantRegisterID]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BlockedGrantRegisterID](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GrantRegistrationID] [nvarchar](100) NOT NULL,
	[TODATE] [datetime] NOT NULL,
	[FromDate] [datetime] NULL
) ON [PRIMARY]
END
GO
