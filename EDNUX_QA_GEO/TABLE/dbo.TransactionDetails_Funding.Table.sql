/****** Object:  Table [dbo].[TransactionDetails_Funding]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionDetails_Funding]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionDetails_Funding](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ExerciseNO] [int] NULL,
	[PANNumber] [varchar](15) NULL,
	[Nationality] [varchar](100) NULL,
	[ResidentialStatus] [char](1) NULL,
	[Location] [varchar](100) NULL,
	[CountryCode] [varchar](50) NULL,
	[Mobile] [varchar](20) NULL,
	[DDNo] [varchar](20) NULL,
	[BankName] [varchar](50) NULL,
	[DDDate] [datetime] NULL,
	[DDNoPQ] [varchar](20) NULL,
	[BankNamePQ] [varchar](50) NULL,
	[DDDatePQ] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[STATUS] [char](1) NOT NULL,
	[SecondaryEmailID] [varchar](500) NULL,
	[CountryName] [varchar](50) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Transacti__STATU__00DF2177]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransactionDetails_Funding] ADD  DEFAULT ('P') FOR [STATUS]
END
GO
