/****** Object:  Table [dbo].[tempPerqstTaxExceptionRule]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tempPerqstTaxExceptionRule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tempPerqstTaxExceptionRule](
	[perqid] [int] IDENTITY(1,1) NOT NULL,
	[Action] [char](1) NULL,
	[Employeeid] [varchar](20) NULL,
	[Grantoptionid] [varchar](100) NOT NULL,
	[PerqValue] [char](1) NULL,
	[Perqtax] [char](1) NULL,
	[Perq_tax_rate] [numeric](18, 6) NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[StatusType] [varchar](1) NULL,
	[Remark] [varchar](500) NULL,
	[QueryExecutionON] [datetime] NULL,
	[TaxHeading] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[perqid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tempPerqs__Emplo__1A69E950]') AND parent_object_id = OBJECT_ID(N'[dbo].[tempPerqstTaxExceptionRule]'))
ALTER TABLE [dbo].[tempPerqstTaxExceptionRule]  WITH CHECK ADD  CONSTRAINT [FK__tempPerqs__Emplo__1A69E950] FOREIGN KEY([Employeeid])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tempPerqs__Emplo__1A69E950]') AND parent_object_id = OBJECT_ID(N'[dbo].[tempPerqstTaxExceptionRule]'))
ALTER TABLE [dbo].[tempPerqstTaxExceptionRule] CHECK CONSTRAINT [FK__tempPerqs__Emplo__1A69E950]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tempPerqs__Emplo__231F2AE2]') AND parent_object_id = OBJECT_ID(N'[dbo].[tempPerqstTaxExceptionRule]'))
ALTER TABLE [dbo].[tempPerqstTaxExceptionRule]  WITH CHECK ADD FOREIGN KEY([Employeeid])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tempPerqs__Emplo__56B3DD81]') AND parent_object_id = OBJECT_ID(N'[dbo].[tempPerqstTaxExceptionRule]'))
ALTER TABLE [dbo].[tempPerqstTaxExceptionRule]  WITH CHECK ADD  CONSTRAINT [FK__tempPerqs__Emplo__56B3DD81] FOREIGN KEY([Employeeid])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tempPerqs__Emplo__56B3DD81]') AND parent_object_id = OBJECT_ID(N'[dbo].[tempPerqstTaxExceptionRule]'))
ALTER TABLE [dbo].[tempPerqstTaxExceptionRule] CHECK CONSTRAINT [FK__tempPerqs__Emplo__56B3DD81]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tempPerqs__Emplo__65E11278]') AND parent_object_id = OBJECT_ID(N'[dbo].[tempPerqstTaxExceptionRule]'))
ALTER TABLE [dbo].[tempPerqstTaxExceptionRule]  WITH CHECK ADD FOREIGN KEY([Employeeid])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__tempPerqs__Grant__66D536B1]') AND parent_object_id = OBJECT_ID(N'[dbo].[tempPerqstTaxExceptionRule]'))
ALTER TABLE [dbo].[tempPerqstTaxExceptionRule]  WITH CHECK ADD FOREIGN KEY([Grantoptionid])
REFERENCES [dbo].[GrantOptions] ([GrantOptionId])
GO
