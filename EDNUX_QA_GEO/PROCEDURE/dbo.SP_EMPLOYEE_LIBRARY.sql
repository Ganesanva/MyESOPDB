/****** Object:  StoredProcedure [dbo].[SP_EMPLOYEE_LIBRARY]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_EMPLOYEE_LIBRARY]
GO
/****** Object:  StoredProcedure [dbo].[SP_EMPLOYEE_LIBRARY]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_EMPLOYEE_LIBRARY] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- Insert statements for procedure here
	CREATE TABLE #TEMP_DATA 
	(			
		OptionsGranted numeric(18,0), OptionsVested  numeric(18,0), OptionsExercised numeric(18,0),OptionsCancelled numeric(18,0), 
		OptionsLapsed numeric(18,0), OptionsUnVested numeric(18,0), PendingForApproval numeric(18,0), GrantOptionId NVARCHAR(100),
		GrantLegId numeric(18,0),SchemeId NVARCHAR(150),GrantRegistrationId NVARCHAR(150),  
		Employeeid NVARCHAR(150),employeename NVARCHAR(250), SBU NVARCHAR(100) NULL,AccountNo NVARCHAR(100) NULL,PANNumber NVARCHAR(50) NULL,
		Entity NVARCHAR(100) NULL, [Status] NVARCHAR(100),GrantDate DATETIME,VestingType NVARCHAR(100), ExercisePrice numeric(10,2),VestingDate DATETIME,
		ExpiryDate DATETIME, Parent_Note NVARCHAR(10), LOGINID VARCHAR(50), Designation VARCHAR(150), [Address] VARCHAR(500), ContactNumber VARCHAR(50),
		DateOfJoining DATETIME, DateOfTermination DATETIME, ReasonForTermination VARCHAR(150), ResidentialStatus VARCHAR(150),
		EMail VARCHAR(150), [Grade] VARCHAR(150), [Department] VARCHAR(150), TaxSlab VARCHAR(50), CountryName VARCHAR(50), SummarizedData NVARCHAR(MAX)			
	)
            
	---Insert data into Temp Table
	DECLARE @TO_DATE AS VARCHAR(10)
	SET @TO_DATE = CONVERT(VARCHAR(10),(SELECT CONVERT(DATE,GETDATE())))
	INSERT INTO #TEMP_DATA (OptionsGranted,	OptionsVested,	OptionsExercised,	OptionsCancelled,	OptionsLapsed,	OptionsUnVested,	PendingForApproval,	GrantOptionId,	GrantLegId,	SchemeId,	GrantRegistrationId,	Employeeid,	employeename,	SBU,	AccountNo,	PANNumber,	Entity,	[Status],	GrantDate,	VestingType,	ExercisePrice,	VestingDate,	ExpiryDate,	Parent_Note)
	Exec SP_REPORT_DATA '1900-01-01', @TO_DATE

	DECLARE @MAXLENGR AS INT, @MAXLENSC AS INT, @MAXLENGO AS INT 
	SELECT @MAXLENGR = MAX(DATALENGTH(GRANTREGISTRATIONID)), @MAXLENSC = MAX(DATALENGTH(SchemeId)) FROM GRANTREGISTRATION
	SELECT @MAXLENGO = MAX(DATALENGTH(GrantOptionId)) FROM GrantOptions
	  
	  
	  
	UPDATE #TEMP_DATA SET        
			LOGINID = EM.LoginID , 
			Designation = EM.EmployeeDesignation , [Address] = EM.EmployeeAddress, 
			ContactNumber = EM.EmployeePhone, DateOfJoining = EM.DateOfJoining, DateOfTermination = EM.DateOfTermination,
			ReasonForTermination = (SELECT Reason FROM ReasonForTermination WHERE ID = EM.ReasonForTermination), 
			ResidentialStatus = ISNULL((SELECT [Description] FROM ResidentialType WHERE ResidentialStatus = EM.ResidentialStatus),'Residential Status Not Updated'), EMail = EM.EmployeeEmail, [Grade] = EM.Grade, [Department] = EM.Department, 
			TaxSlab = EM.Tax_slab, CountryName = ''
	FROM #TEMP_DATA TD INNER JOIN EMPLOYEEMASTER EM ON EM.EmployeeID = TD.Employeeid AND EM.EmployeeName = TD.employeename

	SELECT	DISTINCT 
			OptionsGranted, OptionsVested,OptionsExercised,OptionsCancelled, OptionsLapsed, OptionsUnVested,PendingForApproval,GrantLegId,	
			VestingDate,ExpiryDate,GrantOptionId,SchemeId,GrantRegistrationId,GrantDate,VestingType,ExercisePrice,
			OUTER_#TEMP_DATA.Employeeid,	OUTER_#TEMP_DATA.employeename,	OUTER_#TEMP_DATA.SBU,	OUTER_#TEMP_DATA.AccountNo,	
			OUTER_#TEMP_DATA.PANNumber,	OUTER_#TEMP_DATA.Entity,	OUTER_#TEMP_DATA.[Status],	OUTER_#TEMP_DATA.Parent_Note,
			OUTER_#TEMP_DATA.LOGINID, OUTER_#TEMP_DATA.Designation , OUTER_#TEMP_DATA.[Address] , OUTER_#TEMP_DATA.ContactNumber , OUTER_#TEMP_DATA.DateOfJoining, OUTER_#TEMP_DATA.DateOfTermination , OUTER_#TEMP_DATA.ReasonForTermination , 
			OUTER_#TEMP_DATA.ResidentialStatus , OUTER_#TEMP_DATA.PANNumber , OUTER_#TEMP_DATA.EMail , OUTER_#TEMP_DATA.[Grade] , OUTER_#TEMP_DATA.[Department] , OUTER_#TEMP_DATA.TaxSlab , OUTER_#TEMP_DATA.CountryName
			
	 FROM #TEMP_DATA OUTER_#TEMP_DATA  
	 ORDER BY OUTER_#TEMP_DATA.Employeeid

	 DROP TABLE #TEMP_DATA
	 
END
GO
