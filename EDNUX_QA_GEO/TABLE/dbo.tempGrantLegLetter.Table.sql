/****** Object:  Table [dbo].[tempGrantLegLetter]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tempGrantLegLetter]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tempGrantLegLetter](
	[KPLblOptionID] [char](50) NOT NULL,
	[KPLablEname] [char](50) NULL,
	[KPLblAddress] [char](200) NULL,
	[KPLblCompanyName] [char](50) NULL,
	[KPLblEmpId] [char](50) NULL,
	[KPLblEmployeeID] [char](50) NULL,
	[KPLblEmployeName] [char](50) NULL,
	[KPLblEmpName] [char](50) NULL,
	[KPLblExPrice] [char](50) NULL,
	[KPLblGrantDate] [char](50) NULL,
	[KPLblGrantQty] [char](50) NULL,
	[KPLblName] [char](50) NULL,
	[KPLblNamecom1] [char](50) NULL,
	[KPLblSchemeTitle] [char](50) NULL,
	[KPLblScheTitle] [char](50) NULL,
	[KPLblSchTitle] [char](50) NULL,
	[KPLblSharesNo] [char](50) NULL,
	[KPLblTodays] [char](50) NULL
) ON [PRIMARY]
END
GO
