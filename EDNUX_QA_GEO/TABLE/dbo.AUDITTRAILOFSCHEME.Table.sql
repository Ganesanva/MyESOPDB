/****** Object:  Table [dbo].[AUDITTRAILOFSCHEME]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUDITTRAILOFSCHEME]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AUDITTRAILOFSCHEME](
	[AuditTrailID] [int] IDENTITY(1,1) NOT NULL,
	[SchemeId] [varchar](50) NOT NULL,
	[ADDEDBY] [varchar](50) NULL,
	[CREATEDDATE] [datetime] NULL,
	[OLD_UnVestedCancelledOptions] [char](1) NULL,
	[NEW_UnVestedCancelledOptions] [char](1) NULL,
	[OLD_VestedCancelledOptions] [char](1) NULL,
	[NEW_VestedCancelledOptions] [char](1) NULL,
	[OLD_LapsedOptions] [char](1) NULL,
	[NEW_LapsedOptions] [char](1) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__AUDITTRAI__Schem__45DE573A]') AND parent_object_id = OBJECT_ID(N'[dbo].[AUDITTRAILOFSCHEME]'))
ALTER TABLE [dbo].[AUDITTRAILOFSCHEME]  WITH CHECK ADD FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
ON DELETE CASCADE
GO
