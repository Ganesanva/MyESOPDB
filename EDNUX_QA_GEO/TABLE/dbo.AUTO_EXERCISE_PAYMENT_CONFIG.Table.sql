/****** Object:  Table [dbo].[AUTO_EXERCISE_PAYMENT_CONFIG]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUTO_EXERCISE_PAYMENT_CONFIG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AUTO_EXERCISE_PAYMENT_CONFIG](
	[AEPC_ID] [int] IDENTITY(1,1) NOT NULL,
	[AEC_ID] [bigint] NOT NULL,
	[SCHEME_ID] [nvarchar](100) NOT NULL,
	[BEFORE_VESTING_DATE] [int] NULL,
	[PREVESTING_AUTOEXERCISE] [int] NULL,
	[POSTVESTING_AUTOEXERCISE] [int] NULL,
	[POSTVESTING_DAYS] [int] NULL,
	[PAYMENT_MODE_NOT_SELECTED] [nvarchar](50) NULL,
	[DEFAULT_PAYMENT_MODE] [bigint] NULL,
	[CANCELLATION_VESTED_OPTION] [nvarchar](50) NULL,
	[DAYS_FROM_VESTING_DATE] [int] NULL,
	[MAIL_MODE_PREVESTING] [int] NULL,
	[BEFORE_VESTING_DAYS] [int] NULL,
	[REMINDER_MAIL_DAYS] [int] NULL,
	[MAIL_ON_AUTO_CANCELLATION] [int] NULL,
	[IS_APPROVE] [tinyint] NULL,
	[IS_PAYMENT_MODE_SELECTED] [tinyint] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
	[IS_Applicable_validation] [bit] NULL,
	[ISDemateBrokerUpdate] [bigint] NULL,
	[PAYMENT_MODE_ForUpdate] [bigint] NULL,
	[ISDemateBrokerValidate] [bigint] NULL,
	[PAYMENT_MODE_ForValidate] [bigint] NULL,
	[ISDemateBrokerUnvalidate] [bigint] NULL,
	[PAYMENT_MODE_ForUnValidate] [bigint] NULL,
	[IS_Applicable_ForBlankPayment] [bit] NULL,
	[IS_Reverse_Exercise_For_Seperation] [bit] NULL,
	[IS_Applicable_ForModifyQty] [bit] NULL,
	[IS_ALLOW_AFTER_MODIFY] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[AEPC_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
