/****** Object:  UserDefinedTableType [dbo].[TYPE_AUTOEXERCISE_PAYMENTIDWISE_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_AUTOEXERCISE_PAYMENTIDWISE_DETAILS]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_AUTOEXERCISE_PAYMENTIDWISE_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_AUTOEXERCISE_PAYMENTIDWISE_DETAILS] AS TABLE(
	[AEPC_ID] [bigint] NULL,
	[SCHEME_ID] [nvarchar](50) NULL,
	[PaymentMode_ID] [int] NULL,
	[ISAllow_ToModify] [bit] NULL
)
GO
