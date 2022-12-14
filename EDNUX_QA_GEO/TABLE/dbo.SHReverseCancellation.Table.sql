/****** Object:  Table [dbo].[SHReverseCancellation]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SHReverseCancellation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SHReverseCancellation](
	[ReverseCancelledID] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantQuantity] [numeric](18, 0) NOT NULL,
	[CancelledQuantity] [numeric](18, 0) NOT NULL,
	[GrantLegSerialNumber] [numeric](18, 0) NOT NULL,
	[Status] [char](1) NOT NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[GrantDate] [datetime] NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_SHCancellationList] PRIMARY KEY CLUSTERED 
(
	[ReverseCancelledID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SHReverseCancellation_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[SHReverseCancellation]'))
ALTER TABLE [dbo].[SHReverseCancellation]  WITH CHECK ADD  CONSTRAINT [FK_SHReverseCancellation_EmployeeMaster] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SHReverseCancellation_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[SHReverseCancellation]'))
ALTER TABLE [dbo].[SHReverseCancellation] CHECK CONSTRAINT [FK_SHReverseCancellation_EmployeeMaster]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SHReverseCancellation_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[SHReverseCancellation]'))
ALTER TABLE [dbo].[SHReverseCancellation]  WITH CHECK ADD  CONSTRAINT [FK_SHReverseCancellation_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SHReverseCancellation_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[SHReverseCancellation]'))
ALTER TABLE [dbo].[SHReverseCancellation] CHECK CONSTRAINT [FK_SHReverseCancellation_Scheme]
GO
