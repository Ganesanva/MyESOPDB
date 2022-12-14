/****** Object:  Table [dbo].[STATUS_TAX_UPDATION]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STATUS_TAX_UPDATION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STATUS_TAX_UPDATION](
	[STATUSID] [int] IDENTITY(1,1) NOT NULL,
	[EXERCISEID] [numeric](18, 0) NOT NULL,
	[LASTUPDATEDBY] [varchar](20) NOT NULL,
	[LASTUPDATEDON] [datetime] NOT NULL,
	[PERQSTPAYABLE] [numeric](18, 2) NULL,
	[PERQ_TAX_RATE] [numeric](18, 6) NULL,
	[UPDATEMODE] [varchar](50) NULL,
	[GrantOptionID] [varchar](100) NOT NULL,
	[StRemark] [char](1) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_UpdationMode]') AND parent_object_id = OBJECT_ID(N'[dbo].[STATUS_TAX_UPDATION]'))
ALTER TABLE [dbo].[STATUS_TAX_UPDATION]  WITH CHECK ADD  CONSTRAINT [chk_UpdationMode] CHECK  (([UPDATEMODE]='EXERCISED' OR [UPDATEMODE]='SHEXERCISED' OR [UPDATEMODE]='NO RECORD FOUND FOR THIS EXERCISE ID' OR [UPDATEMODE]='GRANT OPTION ID NOT REGISTER'))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_UpdationMode]') AND parent_object_id = OBJECT_ID(N'[dbo].[STATUS_TAX_UPDATION]'))
ALTER TABLE [dbo].[STATUS_TAX_UPDATION] CHECK CONSTRAINT [chk_UpdationMode]
GO
