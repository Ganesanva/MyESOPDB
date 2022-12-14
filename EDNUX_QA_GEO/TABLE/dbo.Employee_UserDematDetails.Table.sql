/****** Object:  Table [dbo].[Employee_UserDematDetails]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Employee_UserDematDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Employee_UserDematDetails](
	[EmployeeDematId] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [nvarchar](20) NOT NULL,
	[DepositoryName] [varchar](20) NULL,
	[DepositoryParticipantName] [varchar](150) NULL,
	[ClientIDNumber] [nvarchar](16) NULL,
	[DematAccountType] [varchar](15) NULL,
	[DepositoryIDNumber] [nvarchar](8) NULL,
	[DPRecord] [varchar](50) NULL,
	[AccountName] [varchar](256) NULL,
	[IsActive] [bit] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
	[IsValidDematAcc] [bit] NULL,
	[CMLCopy] [varchar](500) NULL,
	[CMLUploadStatus] [varchar](10) NULL,
	[CMLUploadDate] [datetime] NULL,
	[CMLCopyDisplayName] [varchar](500) NULL,
	[ApproveStatus] [varchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeDematId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
