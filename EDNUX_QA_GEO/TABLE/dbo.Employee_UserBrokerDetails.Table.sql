/****** Object:  Table [dbo].[Employee_UserBrokerDetails]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Employee_UserBrokerDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Employee_UserBrokerDetails](
	[EMPLOYEE_BROKER_ACC_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[EMPLOYEE_ID] [nvarchar](50) NOT NULL,
	[ACCOUNT_NAME] [nvarchar](50) NULL,
	[BROKER_DEP_TRUST_CMP_NAME] [nvarchar](50) NULL,
	[BROKER_DEP_TRUST_CMP_ID] [nvarchar](50) NULL,
	[BROKER_ELECT_ACC_NUM] [nvarchar](50) NULL,
	[IS_ACTIVE] [tinyint] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL,
	[IsValidBrokerAcc] [bit] NULL,
 CONSTRAINT [PK_Employee_UserBrokerDetails] PRIMARY KEY CLUSTERED 
(
	[EMPLOYEE_BROKER_ACC_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
