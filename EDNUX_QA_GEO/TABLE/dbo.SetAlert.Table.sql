/****** Object:  Table [dbo].[SetAlert]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetAlert]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SetAlert](
	[EmployeeID] [varchar](20) NOT NULL,
	[TriggerSharePrice] [numeric](18, 2) NOT NULL,
	[DaysBeforeVestingStart] [numeric](18, 0) NOT NULL,
	[DaysBeforeVestingExpiry] [numeric](18, 0) NOT NULL,
	[IsMailSentForPrice] [char](1) NOT NULL,
	[IsMailSentForVesting] [char](1) NOT NULL,
	[IsMailSentForExpiry] [char](1) NOT NULL,
 CONSTRAINT [PK_SetAlert] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
