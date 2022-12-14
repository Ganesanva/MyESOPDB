/****** Object:  Table [dbo].[UserLogHits]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserLogHits]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserLogHits](
	[PageID] [int] NULL,
	[UserId] [varchar](50) NULL,
	[LastUpdatedOn] [datetime] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__UserLogHi__PageI__73A521EA]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserLogHits]'))
ALTER TABLE [dbo].[UserLogHits]  WITH CHECK ADD FOREIGN KEY([PageID])
REFERENCES [dbo].[PageLogHits] ([PageId])
GO
