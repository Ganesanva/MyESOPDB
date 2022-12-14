/****** Object:  Table [dbo].[ShExercisedOptions_back]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions_back]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShExercisedOptions_back](
	[ExerciseId] [numeric](18, 0) NOT NULL,
	[GrantLegSerialNumber] [numeric](18, 0) NOT NULL,
	[ExercisedQuantity] [numeric](18, 0) NOT NULL,
	[SplitExercisedQuantity] [numeric](18, 0) NOT NULL,
	[BonusSplitExercisedQuantity] [numeric](18, 0) NOT NULL,
	[ExercisePrice] [numeric](18, 2) NOT NULL,
	[ExerciseDate] [datetime] NOT NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[LockedInTill] [datetime] NULL,
	[ExercisableQuantity] [numeric](18, 0) NOT NULL,
	[ValidationStatus] [char](1) NOT NULL,
	[Action] [char](1) NOT NULL,
	[GrantLegId] [numeric](18, 0) NOT NULL,
	[ExerciseNo] [numeric](18, 0) NULL,
	[LotNumber] [varchar](20) NULL,
	[DiscrepancyInformation] [varchar](200) NULL,
	[SharesIssuedDate] [datetime] NULL,
	[PerqstValue] [numeric](18, 2) NULL,
	[PerqstPayable] [numeric](18, 2) NULL,
	[FMVPrice] [numeric](18, 2) NULL,
	[isExerciseMailSent] [char](1) NULL,
	[DrawnOn] [datetime] NULL,
	[payrollcountry] [varchar](100) NULL,
	[IsMassUpload] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Cash] [varchar](50) NULL,
	[FBTValue] [numeric](10, 2) NOT NULL,
	[FBTPayable] [numeric](10, 2) NOT NULL,
	[FBTPayBy] [varchar](20) NULL,
	[FBTDays] [int] NULL,
	[TravelDays] [int] NULL,
	[FBTTravelInfoYN] [char](1) NULL,
	[Perq_Tax_rate] [numeric](18, 2) NULL,
	[SharesArised] [numeric](18, 0) NULL,
	[FaceValue] [numeric](18, 2) NULL,
	[SARExerciseAmount] [numeric](18, 2) NULL,
	[StockApperciationAmt] [numeric](18, 2) NULL,
	[FMV_SAR] [numeric](18, 2) NULL,
	[Cheque_received_deposited] [char](1) NULL,
	[PaymentMode] [varchar](1) NULL
) ON [PRIMARY]
END
GO
