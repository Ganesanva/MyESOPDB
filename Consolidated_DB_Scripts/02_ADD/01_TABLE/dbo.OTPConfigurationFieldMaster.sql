IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[OTPConfigurationFieldMaster]')
			AND type IN (N'U')
		)
BEGIN
	CREATE TABLE [dbo].[OTPConfigurationFieldMaster] (
		[FieldId] [int] IDENTITY(1, 1) NOT NULL
		,[FieldName] [varchar](50) NULL
		,[Created_By] [nvarchar](100) NULL
		,[Created_On] [datetime] NULL
		,[Updated_By] [nvarchar](100) NULL
		,[Updated_On] [datetime] NULL
		,CONSTRAINT [PK_OTPConfigurationFieldMaster] PRIMARY KEY CLUSTERED ([FieldId] ASC) WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,IGNORE_DUP_KEY = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			,FILLFACTOR = 95
			,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			) ON [PRIMARY]
		) ON [PRIMARY]
END