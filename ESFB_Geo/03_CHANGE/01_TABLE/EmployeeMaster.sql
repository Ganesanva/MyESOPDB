IF not exists (
				SELECT 'X'
				FROM sys.indexes 
				WHERE object_id = OBJECT_ID('EmployeeMaster')
				AND name='IndexEmp, DOTIndex,>'
		      )
BEGIN

CREATE NONCLUSTERED INDEX [IndexEmp, DOTIndex,>] ON [dbo].[EmployeeMaster]
(
	[DateOfTermination] ASC,
	[ReasonForTermination] ASC,
	[LWD] ASC
)
INCLUDE([LastUpdatedBy],[LastUpdatedOn]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

END

IF not exists (
				SELECT 'X'
				FROM sys.indexes 
				WHERE object_id = OBJECT_ID('EmployeeMaster')
				AND name='NonClusEmpM, EMpLoginIndx,>'
		      )
BEGIN

CREATE NONCLUSTERED INDEX [NonClusEmpM, EMpLoginIndx,>] ON [dbo].[EmployeeMaster]
(
	[LoginID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

END
