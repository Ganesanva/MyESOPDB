/****** Object:  Table [dbo].[EmployeeMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeMaster](
	[EmployeeID] [varchar](20) NOT NULL,
	[LoginID] [varchar](20) NOT NULL,
	[EmployeeName] [varchar](75) NULL,
	[EmployeeDesignation] [varchar](200) NULL,
	[EmployeeAddress] [varchar](500) NULL,
	[EmployeePhone] [varchar](20) NULL,
	[DateOfJoining] [datetime] NULL,
	[DateOfTermination] [datetime] NULL,
	[Insider] [char](1) NULL,
	[ResidentialStatus] [char](1) NULL,
	[PANNumber] [varchar](10) NULL,
	[WardNumber] [varchar](50) NULL,
	[DematAccountType] [varchar](15) NULL,
	[DepositoryIDNumber] [varchar](8) NULL,
	[DepositoryParticipantNo] [varchar](150) NULL,
	[ClientIDNumber] [varchar](16) NULL,
	[EmployeeEmail] [varchar](500) NULL,
	[Grade] [varchar](200) NULL,
	[Department] [varchar](200) NULL,
	[DepositoryName] [varchar](20) NULL,
	[BackOutTermination] [char](1) NULL,
	[IsMailSent] [char](1) NULL,
	[SBU] [varchar](200) NULL,
	[Entity] [varchar](200) NULL,
	[AccountNo] [varchar](20) NULL,
	[NewEmployeeId] [varchar](50) NULL,
	[Location] [varchar](200) NULL,
	[ConfStatus] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[ApprovalStatus] [char](1) NULL,
	[Deleted] [char](1) NULL,
	[ReasonForTermination] [numeric](18, 0) NULL,
	[Remarks] [varchar](50) NULL,
	[IsAssociated] [char](1) NULL,
	[LWD] [datetime] NULL,
	[Confirmn_Dt] [datetime] NULL,
	[payrollcountry] [varchar](100) NULL,
	[tax_slab] [numeric](18, 6) NULL,
	[Mobile] [varchar](20) NULL,
	[DPRecord] [varchar](50) NULL,
	[PerqAmt_ChequeNo] [varchar](50) NULL,
	[PerqAmt_DrownOndate] [datetime] NULL,
	[PerqAmt_WireTransfer] [varchar](50) NULL,
	[PerqAmt_BankName] [varchar](50) NULL,
	[PerqAmt_Branch] [varchar](50) NULL,
	[PerqAmt_BankAccountNumber] [varchar](50) NULL,
	[Branch] [varchar](50) NULL,
	[SecondaryEmailID] [varchar](500) NULL,
	[CountryName] [varchar](50) NULL,
	[AssociatedDate] [datetime] NULL,
	[Status] [varchar](10) NULL,
	[COST_CENTER] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_NAME] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_ID] [varchar](200) NULL,
	[BROKER_ELECT_ACC_NUM] [varchar](200) NULL,
	[FROM_DATE] [date] NULL,
	[Nationality] [varchar](100) NULL,
	[State] [varchar](100) NULL,
	[DateOfMovement] [datetime] NULL,
	[TransferDate] [smalldatetime] NULL,
	[CompanyName] [varchar](50) NULL,
	[LongLeave] [varchar](1) NULL,
	[LongLeaveFrom] [smalldatetime] NULL,
	[LongLeaveTo] [smalldatetime] NULL,
	[VestingDateExtension] [numeric](18, 2) NULL,
	[TAX_IDENTIFIER_COUNTRY] [nvarchar](50) NULL,
	[TAX_IDENTIFIER_STATE] [nvarchar](50) NULL,
	[Field1] [nvarchar](1) NULL,
	[Field2] [nvarchar](1) NULL,
	[Field3] [nvarchar](1) NULL,
	[Field4] [nvarchar](1) NULL,
	[Field5] [nvarchar](1) NULL,
	[Field6] [nvarchar](1) NULL,
	[Field7] [nvarchar](1) NULL,
	[Field8] [nvarchar](1) NULL,
	[Field9] [nvarchar](1) NULL,
	[Field10] [nvarchar](1) NULL,
	[IsValidBankAcc] [bit] NULL,
 CONSTRAINT [PK_EmployeeMaster] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_EmployeeMaster] UNIQUE NONCLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Index [IndexEmp, DOTIndex,>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') AND name = N'IndexEmp, DOTIndex,>')
CREATE NONCLUSTERED INDEX [IndexEmp, DOTIndex,>] ON [dbo].[EmployeeMaster]
(
	[DateOfTermination] ASC,
	[ReasonForTermination] ASC,
	[LWD] ASC
)
INCLUDE([LastUpdatedBy],[LastUpdatedOn]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonClusEmpM, EMpLoginIndx,>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') AND name = N'NonClusEmpM, EMpLoginIndx,>')
CREATE NONCLUSTERED INDEX [NonClusEmpM, EMpLoginIndx,>] ON [dbo].[EmployeeMaster]
(
	[LoginID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EmployeeM__Confi__7FEAFD3E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmployeeMaster] ADD  DEFAULT (NULL) FOR [Confirmn_Dt]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EmployeeM__COST___5634BA94]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmployeeMaster] ADD  DEFAULT (NULL) FOR [COST_CENTER]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EmployeeM__BROKE__5728DECD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmployeeMaster] ADD  DEFAULT (NULL) FOR [BROKER_DEP_TRUST_CMP_NAME]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EmployeeM__BROKE__581D0306]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmployeeMaster] ADD  DEFAULT (NULL) FOR [BROKER_DEP_TRUST_CMP_ID]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EmployeeM__BROKE__5911273F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmployeeMaster] ADD  DEFAULT (NULL) FOR [BROKER_ELECT_ACC_NUM]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EmployeeM__FROM___218BE82B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmployeeMaster] ADD  DEFAULT (NULL) FOR [FROM_DATE]
END
GO
/****** Object:  Trigger [dbo].[UPDATE_IN_EMP_MASTER]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[UPDATE_IN_EMP_MASTER]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[UPDATE_IN_EMP_MASTER] 
ON 
	[dbo].[EmployeeMaster]
AFTER INSERT, UPDATE

AS
BEGIN
	DECLARE 
			@DateOfTermination datetime,
			@ReasonForTermination numeric(18,0),
			@LWD datetime,
			@MESSANGER_BIT bit,
			@EmployeeID	nvarchar(20) 


	SELECT 
		@DateOfTermination=DateOfTermination ,
		@ReasonForTermination=ReasonForTermination,
		@LWD=LWD,
		@EmployeeID = EmployeeID 
	FROM 
		INSERTED 

	IF (@DATEOFTERMINATION IS NOT NULL AND @DATEOFTERMINATION <> ''1900-01-01 00:00:00.000'' AND @LWD IS NOT NULL AND  @LWD <> ''1900-01-01 00:00:00.000'' AND (@REASONFORTERMINATION IS NULL ))
		SET @MESSANGER_BIT = 1
	ELSE IF (@DATEOFTERMINATION IS NOT NULL AND @DATEOFTERMINATION <> ''1900-01-01 00:00:00.000'' AND (@LWD IS NULL OR  @LWD = ''1900-01-01 00:00:00.000'') AND (@REASONFORTERMINATION IS NULL ))
		SET @MESSANGER_BIT = 1
	ELSE IF ((@DATEOFTERMINATION IS NULL OR @DATEOFTERMINATION = ''1900-01-01 00:00:00.000'') AND (@LWD IS NOT NULL AND  @LWD <> ''1900-01-01 00:00:00.000'') AND (@REASONFORTERMINATION IS NOT NULL ))
		SET @MESSANGER_BIT = 1
	ELSE IF ((@DATEOFTERMINATION IS NULL OR @DATEOFTERMINATION = ''1900-01-01 00:00:00.000'') AND (@LWD IS NOT NULL AND  @LWD <> ''1900-01-01 00:00:00.000'') AND (@REASONFORTERMINATION IS NULL ))
		SET @MESSANGER_BIT = 1
	ELSE IF ((@DATEOFTERMINATION IS NULL OR @DATEOFTERMINATION = ''1900-01-01 00:00:00.000'') AND (@LWD IS NULL OR  @LWD = ''1900-01-01 00:00:00.000'') AND (@REASONFORTERMINATION IS NOT NULL ))
		SET @MESSANGER_BIT = 1
	ELSE 
		SET @MESSANGER_BIT = 0

	IF @MESSANGER_BIT = 1
	BEGIN
		DECLARE @MAX_MSG_ID NUMERIC(18,0)
		SELECT @MAX_MSG_ID = MAX(MESSAGEID) FROM MailerDB..MailSpool
		
		INSERT INTO MailerDB..MailSpool
				(MessageID ,[From] ,[To] ,[Subject] ,[Description], Cc ,CreatedOn)
		VALUES
				(@MAX_MSG_ID+1,''noreply@esopdirect.com'',''dev@esopdirect.com'',''Column DOT,RFT,LWD are invalid for company '' + DB_NAME(),''One of the column has a value for Employee Id '' + @EmployeeID +''. Kindly check.'',null,GETDATE())

	END
END
' 
GO
ALTER TABLE [dbo].[EmployeeMaster] ENABLE TRIGGER [UPDATE_IN_EMP_MASTER]
GO
/****** Object:  Trigger [dbo].[UpdateEmployeeDetails]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[UpdateEmployeeDetails]'))
EXEC dbo.sp_executesql @statement = N'CREATE TRIGGER [dbo].[UpdateEmployeeDetails]
   ON  [dbo].[EmployeeMaster]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
    DECLARE 
			
	@EmployeeId varchar(20),
	@PhoneNo varchar(20),	@NewPhoneNo varchar(20),
	@EmailId varchar(255),	@NewEmailId varchar(255),
	@DateofJoining datetime,	@NewDateofJoining datetime, 
	@Grade varchar(255), @NewGrade varchar(255),
	@Department varchar(255), @NewDepartment varchar(255)
			
			
	SELECT @EmployeeId= EmployeeID, @NewPhoneNo=  EmployeePhone, @NewEmailId= EmployeeEmail, @NewDateofJoining= DateOfJoining, @NewGrade= Grade,  @NewDepartment= Department FROM INSERTED	
							
	SELECT	@PhoneNo=  EmployeePhone, @EmailId= EmployeeEmail, @DateofJoining= DateOfJoining, @Grade= Grade, @Department= Department FROM DELETED
				
				
	IF (@PhoneNo != @NewPhoneNo)
		BEGIN
			UPDATE UserMaster SET PhoneNo = @NewPhoneNo WHERE  EmployeeId =  @EmployeeId
		END
				 
	IF (@EmailId != @NewEmailId)
		BEGIN
			UPDATE UserMaster SET EmailId = @NewEmailId WHERE  EmployeeId =  @EmployeeId
		END
				 
	IF (@DateofJoining != @NewDateofJoining)
		BEGIN
			UPDATE UserMaster SET DateofJoining = @NewDateofJoining WHERE  EmployeeId =  @EmployeeId
		END
				 
	IF (@Grade != @NewGrade)
		BEGIN
			UPDATE UserMaster SET Grade = @NewGrade WHERE  EmployeeId =  @EmployeeId
		END
				 
	IF (@Department != @NewDepartment)
		BEGIN
			UPDATE UserMaster SET Department = @NewDepartment WHERE  EmployeeId =  @EmployeeId
		END
				
END
' 
GO
ALTER TABLE [dbo].[EmployeeMaster] ENABLE TRIGGER [UpdateEmployeeDetails]
GO
