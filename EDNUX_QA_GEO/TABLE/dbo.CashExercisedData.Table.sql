/****** Object:  Table [dbo].[CashExercisedData]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CashExercisedData]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CashExercisedData](
	[Employee_ID] [varchar](100) NULL,
	[Employee_Name] [varchar](200) NULL,
	[Residential_Status_of_employee] [varchar](100) NULL,
	[Country] [varchar](100) NULL,
	[FORM10_Status] [varchar](30) NULL,
	[TRC_Status] [varchar](30) NULL,
	[PAN_Details] [varchar](50) NULL,
	[Date_of_Exercise] [datetime] NULL,
	[Date_of_Grant] [datetime] NULL,
	[Options_Exercised] [varchar](100) NULL,
	[Exercise_Price] [varchar](100) NULL,
	[FMV] [varchar](100) NULL,
	[Exercise_Amount_Payable] [varchar](100) NULL,
	[Perquisite_Value] [varchar](100) NULL,
	[Perquisite_Tax] [varchar](100) NULL,
	[Capital_Gain_Value] [varchar](100) NULL,
	[Capital_Gain_Tax] [varchar](100) NULL,
	[Total_Amount_Payable] [varchar](100) NULL,
	[Mode_of_payment] [varchar](100) NULL,
	[Date_of_transfer_of_Shares] [datetime] NULL,
	[UPDATED_BY] [varchar](100) NULL,
	[UPDATED_ON] [datetime] NULL,
	[Exercise_Number] [varchar](100) NULL,
	[Exercise_ID] [varchar](100) NULL,
	[Perq_Tax_rate] [numeric](18, 2) NULL,
	[SharesIssuedDate] [datetime] NULL,
 CONSTRAINT [ExNoID] UNIQUE NONCLUSTERED 
(
	[Exercise_Number] ASC,
	[Exercise_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CashExerc__Date___5649C92D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CashExercisedData] ADD  DEFAULT (getdate()) FOR [Date_of_transfer_of_Shares]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CashExerc__UPDAT__573DED66]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CashExercisedData] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
END
GO
/****** Object:  Trigger [dbo].[TRIG_CashExercisedData]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIG_CashExercisedData]'))
EXEC dbo.sp_executesql @statement = N'

CREATE   TRIGGER [dbo].[TRIG_CashExercisedData] 
   ON  [dbo].[CashExercisedData] 
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	
	--Check if old record is available in the AuditCashExercisedData table. If not then only insert the same.
	IF NOT EXISTS(SELECT ACED.AuditCashExercisedData_ID FROM AuditCashExercisedData ACED INNER JOIN DELETED DEL ON ACED.Perquisite_Value = DEL.Perquisite_Value AND ACED.Perquisite_Tax = DEL.Perquisite_Tax AND ACED.Capital_Gain_Value = DEL.Capital_Gain_Value AND ACED.Capital_Gain_Tax = DEL.Capital_Gain_Tax AND DEL.Exercise_ID = ACED.Exercise_ID AND DEL.Exercise_Number = ACED.Exercise_Number)
	BEGIN
		INSERT INTO AuditCashExercisedData SELECT Exercise_Number, Exercise_ID, Perquisite_Value, Perquisite_Tax, Capital_Gain_Value, Capital_Gain_Tax, UPDATED_BY, GETDATE() FROM DELETED
	END
	
	---Insert the new record in AuditCashExercisedData table
	INSERT INTO AuditCashExercisedData SELECT Exercise_Number, Exercise_ID, Perquisite_Value, Perquisite_Tax, Capital_Gain_Value, Capital_Gain_Tax, UPDATED_BY, GETDATE() FROM INSERTED    

END
' 
GO
ALTER TABLE [dbo].[CashExercisedData] ENABLE TRIGGER [TRIG_CashExercisedData]
GO
