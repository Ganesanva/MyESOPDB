/****** Object:  Table [dbo].[UploadDetails]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UploadDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UploadDetails](
	[FileID] [numeric](18, 0) NOT NULL,
	[CategoryID] [numeric](18, 0) NOT NULL,
	[FilePath] [varchar](200) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[LastUpdatedBy] [varchar](50) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[IsDeleted] [char](1) NOT NULL,
	[SCHEMENAME] [varchar](500) NULL,
 CONSTRAINT [PK_UploadDetails] PRIMARY KEY CLUSTERED 
(
	[FileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UploadDetails_CategoryMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[UploadDetails]'))
ALTER TABLE [dbo].[UploadDetails]  WITH CHECK ADD  CONSTRAINT [FK_UploadDetails_CategoryMaster] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[CategoryMaster] ([CategoryID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UploadDetails_CategoryMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[UploadDetails]'))
ALTER TABLE [dbo].[UploadDetails] CHECK CONSTRAINT [FK_UploadDetails_CategoryMaster]
GO
