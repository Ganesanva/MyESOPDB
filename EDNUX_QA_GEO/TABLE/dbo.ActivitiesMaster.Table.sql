/****** Object:  Table [dbo].[ActivitiesMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ActivitiesMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ActivitiesMaster](
	[ActivitiesID] [int] IDENTITY(1,1) NOT NULL,
	[ActivitiesTitle] [varchar](100) NOT NULL,
	[ActivitiesDescription] [nvarchar](max) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NULL,
	[CREATED_BY] [nvarchar](50) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](50) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Activitie__IsAct__7AD933CC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ActivitiesMaster] ADD  DEFAULT ((0)) FOR [IsActive]
END
GO
