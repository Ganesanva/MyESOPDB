/****** Object:  Table [dbo].[GrantOptionIdAssociation]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrantOptionIdAssociation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GrantOptionIdAssociation](
	[GopAssociationID] [int] IDENTITY(1,1) NOT NULL,
	[BaseGrantOptionId] [varchar](250) NULL,
	[AssociatedGrantOptionId] [varchar](250) NULL,
	[AssociatedGrantOptionQty] [bigint] NULL,
	[AssociationToVestId] [int] NULL,
	[SharePriceAsOnDateOfGrant] [numeric](18, 9) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[GopAssociationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
