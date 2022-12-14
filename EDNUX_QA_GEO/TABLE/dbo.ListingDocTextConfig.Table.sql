/****** Object:  Table [dbo].[ListingDocTextConfig]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListingDocTextConfig]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ListingDocTextConfig](
	[LstDocTextConfigID] [int] IDENTITY(1,1) NOT NULL,
	[Text1ApprovalDetailsNote] [nvarchar](max) NULL,
	[Text2GrantIndptDirectors] [nvarchar](max) NULL,
	[Text3StockExchange] [nvarchar](max) NULL,
	[Text4StatementReferred] [nvarchar](max) NULL,
	[Text5RegionalStockExch] [nvarchar](max) NULL,
	[Text6BoardMeetingDate] [nvarchar](max) NULL,
	[Text7ApprovalGeneralBodyDate] [nvarchar](max) NULL,
	[Text8AddressedToBSE] [nvarchar](max) NULL,
	[Text9AddressedToNSE] [nvarchar](max) NULL,
	[Text10AddresseeName] [nvarchar](max) NULL,
	[Text11CDSLAddressee] [nvarchar](max) NULL,
	[Text12AuthoCommittee] [nvarchar](max) NULL,
	[Text13AddScheduleNotes] [nvarchar](max) NULL,
	[Text14ShareTransferAgent] [nvarchar](max) NULL,
	[Text15AddNotesPartA] [nvarchar](max) NULL,
	[Text16ShareTransAgentAddress] [nvarchar](max) NULL,
	[Text17NSDLAddressee] [nvarchar](max) NULL,
	[Text18AddCorporateActionNote] [nvarchar](max) NULL,
	[CreatedBy] [varchar](100) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [varchar](100) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_ListingDocTextConfig] PRIMARY KEY CLUSTERED 
(
	[LstDocTextConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
