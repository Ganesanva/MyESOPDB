/****** Object:  Table [dbo].[ReverseCancellation]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReverseCancellation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReverseCancellation](
	[CancelledListID] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantQuantity] [numeric](18, 0) NOT NULL,
	[Action] [char](1) NOT NULL,
	[CancelledQuantity] [numeric](18, 0) NOT NULL,
	[GrantOptionID] [varchar](100) NULL,
	[Status] [char](1) NOT NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[GrantDate] [datetime] NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_SHReverseCancellation] PRIMARY KEY CLUSTERED 
(
	[CancelledListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReverseCancellation_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReverseCancellation]'))
ALTER TABLE [dbo].[ReverseCancellation]  WITH CHECK ADD  CONSTRAINT [FK_ReverseCancellation_EmployeeMaster] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReverseCancellation_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReverseCancellation]'))
ALTER TABLE [dbo].[ReverseCancellation] CHECK CONSTRAINT [FK_ReverseCancellation_EmployeeMaster]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReverseCancellation_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReverseCancellation]'))
ALTER TABLE [dbo].[ReverseCancellation]  WITH CHECK ADD  CONSTRAINT [FK_ReverseCancellation_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReverseCancellation_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReverseCancellation]'))
ALTER TABLE [dbo].[ReverseCancellation] CHECK CONSTRAINT [FK_ReverseCancellation_Scheme]
GO
