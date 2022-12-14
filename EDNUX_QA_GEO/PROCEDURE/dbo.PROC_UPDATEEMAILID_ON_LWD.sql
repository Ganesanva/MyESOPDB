/****** Object:  StoredProcedure [dbo].[PROC_UPDATEEMAILID_ON_LWD]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATEEMAILID_ON_LWD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATEEMAILID_ON_LWD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UPDATEEMAILID_ON_LWD]

AS
BEGIN
	 SET NOCOUNT ON;

		DECLARE   @MN_VALUE INT, @MX_VALUE INT,@EmployeeID  VARCHAR(20),@SecondaryEmailID VARCHAR(50)
		CREATE TABLE #TEMP_EMPLOYEEDATA
		(  
			ID INT IDENTITY(1,1) NOT NULL, EmployeeID VARCHAR(20),EmployeeEmail VARCHAR(500),SecondaryEmailID VARCHAR(50)
		) 
		
		CREATE TABLE #TEMP_EMPLOYEEID
		(
		  ID INT IDENTITY(1,1) NOT NULL, EmployeeID VARCHAR(20)
		)
		
		INSERT INTO #TEMP_EMPLOYEEDATA
		(
		  EmployeeID, EmployeeEmail,SecondaryEmailID
		)
		SELECT EmployeeID, EmployeeEmail,SecondaryEmailID FROM EmployeeMaster WHERE  LWD=convert(datetime,convert(varchar(11),getdate(),106)) AND IsNull(SecondaryEmailID, '') != '' AND (EmployeeEmail!=SecondaryEmailID)
		
		SELECT @MN_VALUE = MIN(ID ),@MX_VALUE = MAX(ID) FROM #TEMP_EMPLOYEEDATA

		WHILE(@MN_VALUE <= @MX_VALUE)
		BEGIN

		  SELECT 
				@EmployeeID = EmployeeID,@SecondaryEmailID=SecondaryEmailID 
			FROM 
				#TEMP_EMPLOYEEDATA 
			WHERE 
				ID = @MN_VALUE

			Update EmployeeMaster SET EmployeeEmail=@SecondaryEmailID Where EmployeeID=@EmployeeID

	        INSERT INTO #TEMP_EMPLOYEEID
				(
				EmployeeID
				)
				SELECT @EmployeeID
		  SET @MN_VALUE = @MN_VALUE + 1
		END
		
		
		SELECT * FROM #TEMP_EMPLOYEEID
		DROP TABLE #TEMP_EMPLOYEEDATA	
		DROP TABLE #TEMP_EMPLOYEEID
	 SET NOCOUNT OFF;	
END
GO
