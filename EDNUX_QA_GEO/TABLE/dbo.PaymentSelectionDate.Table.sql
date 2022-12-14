/****** Object:  Table [dbo].[PaymentSelectionDate]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentSelectionDate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaymentSelectionDate](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ExerciseId] [int] NULL,
	[ExerciseNo] [int] NULL,
	[PaymentMode] [varchar](500) NULL,
	[Paymentdate] [datetime] NULL,
	[UpdateBy] [nvarchar](100) NULL,
	[UpdatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
