DROP PROCEDURE IF EXISTS [dbo].[SP_UPDATEUSERNEWDETAILS]
GO

/****** Object:  StoredProcedure [dbo].[SP_UPDATEUSERNEWDETAILS]    Script Date: 18-07-2022 16:39:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_UPDATEUSERNEWDETAILS] 
	-- Add the parameters for the stored procedure here
	(
		    @LOGINID AS VARCHAR (40),
			@DOJ AS	VARCHAR	(25),
			@GRADE	AS VARCHAR (150),
			@SecondaryEmailID AS	VARCHAR	(500),
			@COUNTRYNAME AS VARCHAR	(50),
			@PHONENO AS	VARCHAR	(40),
			@EMAILID AS	VARCHAR	(500),
			@ADDRESS AS	VARCHAR	(500),
			@EMPLOYEENAME AS VARCHAR(20),
			@DESIGNATION AS VARCHAR(20)
	)
AS
BEGIN
	
	SET NOCOUNT ON;
		SELECT @LOGINID=LoginID FROM EmployeeMaster WHERE EmployeeID=@LOGINID AND ISNULL(Deleted,0)=0
		BEGIN
			UPDATE EmployeeMaster
			SET 
				DateOfJoining= ISNULL(CASE WHEN CONVERT(date, @DOJ) = '0001-01-01' THEN '' ELSE CONVERT(datetime, @DOJ) END, ''),
				Grade=@GRADE,
				SecondaryEmailID=@SecondaryEmailID,
				CountryName=@COUNTRYNAME,
				EmployeePhone=@PHONENO,
				EmployeeEmail=@EMAILID,
				EmployeeAddress=@ADDRESS,
				LastUpdatedBy=@EMPLOYEENAME,
				EmployeeDesignation = @DESIGNATION,
				LastUpdatedOn=GETDATE()
			WHERE
				LoginID=@LOGINID 
	
			UPDATE UserMaster
			SET
				DateOfJoining= ISNULL(CASE WHEN CONVERT(date, @DOJ) = '0001-01-01' THEN '' ELSE CONVERT(datetime, @DOJ) END, ''),
				Grade=@GRADE,
				PhoneNo=@PHONENO,
				EmailId=@EMAILID,
				Address=@ADDRESS,
				LastUpdatedBy=@EMPLOYEENAME,
				LastUpdatedOn=GETDATE()
			WHERE
				UserId=@LOGINID
		END 
		IF @@ROWCOUNT > 0
		BEGIN
		    SELECT 
			   EM.DateOfJoining, EM.Grade, EM.SecondaryEmailID, EM.CountryName, EM.EmployeePhone, EM.EmployeeEmail, EM.EmployeeAddress, EM.EmployeeDesignation,
			   UM.PhoneNo, UM.EmailId, UM.Address
			FROM UserMaster UM INNER JOIN EmployeeMaster EM ON UM.UserId = EM.EmployeeID WHERE UM.UserId =@LOGINID
		END
SET NOCOUNT OFF;

END

GO


