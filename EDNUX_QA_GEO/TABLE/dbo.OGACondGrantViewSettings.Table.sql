/****** Object:  Table [dbo].[OGACondGrantViewSettings]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OGACondGrantViewSettings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OGACondGrantViewSettings](
	[OCGVSID] [int] IDENTITY(1,1) NOT NULL,
	[Is_GrantDetWithoutAccOrRej] [bit] NULL,
	[Is_GrantDetOnlyAfterAcc] [bit] NULL,
	[Is_GrantDetIfAccOrRej] [bit] NULL,
	[Is_GrantDetDisExeNowIfNotAcc] [bit] NULL,
	[Is_GrantLetterBeforeAcc] [bit] NULL,
	[Is_GenGrantLetterPostAcc] [bit] NULL,
	[Created_By] [varchar](50) NULL,
	[Created_On] [datetime] NULL,
	[Updated_By] [varchar](50) NULL,
	[Updated_On] [datetime] NULL,
 CONSTRAINT [PK_GrantViewSettings] PRIMARY KEY CLUSTERED 
(
	[OCGVSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
