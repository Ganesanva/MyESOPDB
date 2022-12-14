/****** Object:  Table [dbo].[GrantMappingOnExNow]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrantMappingOnExNow]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GrantMappingOnExNow](
	[GroupNumber] [int] NULL,
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[GrantOptionId] [varchar](100) NOT NULL,
	[FinalVestingDate] [datetime] NULL,
	[FinalExpiryDate] [datetime] NULL,
	[PARENT] [nvarchar](5) NULL,
 CONSTRAINT [ALL_ColmnConstraint] UNIQUE NONCLUSTERED 
(
	[GroupNumber] ASC,
	[GrantRegistrationId] ASC,
	[GrantOptionId] ASC,
	[FinalVestingDate] ASC,
	[FinalExpiryDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__GrantMapp__Group__3DD3EC75]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[GrantMappingOnExNow] ADD  DEFAULT ((0)) FOR [GroupNumber]
END
GO
