/****** Object:  Table [dbo].[NominationConfigurations]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NominationConfigurations]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NominationConfigurations](
	[IsNominationEnabledForEmp] [bit] NOT NULL,
	[IsEditableForEmp] [bit] NOT NULL,
	[IsAlertEnabledToEmp] [bit] NOT NULL,
	[CompanyAddress] [nvarchar](500) NOT NULL,
	[TextPart1] [nvarchar](500) NOT NULL,
	[TextPart2] [nvarchar](500) NOT NULL,
	[LastUpdatedBy] [nvarchar](50) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
