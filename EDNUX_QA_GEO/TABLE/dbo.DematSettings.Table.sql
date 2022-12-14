/****** Object:  Table [dbo].[DematSettings]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DematSettings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DematSettings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [varchar](20) NULL,
	[Name_as_in_DPRecord] [varchar](1) NULL,
	[Name_Of_Depository] [varchar](1) NULL,
	[Demat_AC_Type] [varchar](1) NULL,
	[Name_of_Depository_Participant] [varchar](1) NULL,
	[Deppository_Participant_Id] [varchar](1) NULL,
	[ClientID_Demat_AC_No] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__DematSett__Emplo__703EA55A]') AND parent_object_id = OBJECT_ID(N'[dbo].[DematSettings]'))
ALTER TABLE [dbo].[DematSettings]  WITH CHECK ADD  CONSTRAINT [FK__DematSett__Emplo__703EA55A] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__DematSett__Emplo__703EA55A]') AND parent_object_id = OBJECT_ID(N'[dbo].[DematSettings]'))
ALTER TABLE [dbo].[DematSettings] CHECK CONSTRAINT [FK__DematSett__Emplo__703EA55A]
GO
