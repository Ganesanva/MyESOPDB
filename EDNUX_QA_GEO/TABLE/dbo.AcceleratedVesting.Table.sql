/****** Object:  Table [dbo].[AcceleratedVesting]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AcceleratedVesting]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AcceleratedVesting](
	[AcceleratedVestingId] [numeric](18, 0) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[AcceleratedVestingDate] [datetime] NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_AcceleratedVesting] PRIMARY KEY CLUSTERED 
(
	[AcceleratedVestingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AcceleratedVesting_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[AcceleratedVesting]'))
ALTER TABLE [dbo].[AcceleratedVesting]  WITH CHECK ADD  CONSTRAINT [FK_AcceleratedVesting_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AcceleratedVesting_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[AcceleratedVesting]'))
ALTER TABLE [dbo].[AcceleratedVesting] CHECK CONSTRAINT [FK_AcceleratedVesting_Scheme]
GO
