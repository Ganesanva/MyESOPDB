/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_EMP_DETAILS_WITH_EXERCISE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_EMP_DETAILS_WITH_EXERCISE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_EMP_DETAILS_WITH_EXERCISE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_UPDATE_EMP_DETAILS_WITH_EXERCISE] 
		@ExerciseNo VARCHAR(50),	
		@LoginId varchar(20)	
AS
BEGIN

UPDATE EMPDET_With_EXERCISE   SET   EMPDET_With_EXERCISE.DateOfJoining =case when EMPDET_With_EXERCISE.DateOfJoining is NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.DateOfJoining)))=0  then EMP.DateOfJoining ELSE EMPDET_With_EXERCISE.DateOfJoining END ,
								    EMPDET_With_EXERCISE.Grade =case when EMPDET_With_EXERCISE.Grade  IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.Grade)))=0   then EMP.Grade  ELSE EMPDET_With_EXERCISE.Grade END ,
								    EMPDET_With_EXERCISE.EmployeeDesignation = case when EMPDET_With_EXERCISE.EmployeeDesignation IS NULL OR ISNULL(LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.EmployeeDesignation))),'')=0 then EMP.EmployeeDesignation  ELSE EMPDET_With_EXERCISE.EmployeeDesignation END ,
									EMPDET_With_EXERCISE.EmployeePhone = case when EMPDET_With_EXERCISE.EmployeePhone IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.EmployeePhone)))=0 then EMP.EmployeePhone  ELSE EMPDET_With_EXERCISE.EmployeePhone END ,
									EMPDET_With_EXERCISE.EmployeeEmail = case when EMPDET_With_EXERCISE.EmployeeEmail IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.EmployeeEmail)))=0 then EMP.EmployeeEmail  ELSE EMPDET_With_EXERCISE.EmployeeEmail END ,
									EMPDET_With_EXERCISE.EmployeeAddress = case when EMPDET_With_EXERCISE.EmployeeAddress IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.EmployeeAddress)))=0 then EMP.EmployeeAddress  ELSE EMPDET_With_EXERCISE.EmployeeAddress END ,
									EMPDET_With_EXERCISE.PANNumber = case when EMPDET_With_EXERCISE.PANNumber IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.PANNumber)))=0 then EMP.PANNumber  ELSE EMPDET_With_EXERCISE.PANNumber END ,
									EMPDET_With_EXERCISE.ResidentialStatus = case when EMPDET_With_EXERCISE.ResidentialStatus IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.ResidentialStatus)))=0 then EMP.ResidentialStatus  ELSE EMPDET_With_EXERCISE.ResidentialStatus END ,
									EMPDET_With_EXERCISE.Insider = case when EMPDET_With_EXERCISE.Insider IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.Insider)))=0 then EMP.Insider  ELSE EMPDET_With_EXERCISE.Insider END ,
									EMPDET_With_EXERCISE.WardNumber = case when EMPDET_With_EXERCISE.WardNumber IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.WardNumber)))=0 then EMP.WardNumber  ELSE EMPDET_With_EXERCISE.WardNumber END ,
									EMPDET_With_EXERCISE.Department = case when EMPDET_With_EXERCISE.Department IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.Department)))=0 then EMP.Department  ELSE EMPDET_With_EXERCISE.Department END ,
									EMPDET_With_EXERCISE.Location = case when EMPDET_With_EXERCISE.Location IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.Location)))=0 then EMP.Location  ELSE EMPDET_With_EXERCISE.Location END ,
									EMPDET_With_EXERCISE.SBU = case when EMPDET_With_EXERCISE.SBU IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.SBU)))=0 then EMP.SBU  ELSE EMPDET_With_EXERCISE.SBU END ,
									EMPDET_With_EXERCISE.Entity = case when EMPDET_With_EXERCISE.Entity IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.Entity)))=0 then EMP.Entity  ELSE EMPDET_With_EXERCISE.Entity END ,
									EMPDET_With_EXERCISE.DPRecord = case when EMPDET_With_EXERCISE.DPRecord IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.DPRecord)))=0 then EMP.DPRecord  ELSE EMPDET_With_EXERCISE.DPRecord END ,
									EMPDET_With_EXERCISE.DepositoryName = case when EMPDET_With_EXERCISE.DepositoryName IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.DepositoryName)))=0 then EMP.DepositoryName  ELSE EMPDET_With_EXERCISE.DepositoryName END ,
									EMPDET_With_EXERCISE.DematAccountType = case when EMPDET_With_EXERCISE.DematAccountType IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.DematAccountType)))=0 then EMP.DematAccountType  ELSE EMPDET_With_EXERCISE.DematAccountType END ,
									EMPDET_With_EXERCISE.DepositoryParticipantNo = case when EMPDET_With_EXERCISE.DepositoryParticipantNo IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.DepositoryParticipantNo)))=0 then EMP.DepositoryParticipantNo  ELSE EMPDET_With_EXERCISE.DepositoryParticipantNo END ,
									EMPDET_With_EXERCISE.DepositoryIDNumber = case when EMPDET_With_EXERCISE.DepositoryIDNumber IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.DepositoryIDNumber)))=0 then EMP.DepositoryIDNumber  ELSE EMPDET_With_EXERCISE.DepositoryIDNumber END ,
									EMPDET_With_EXERCISE.ClientIDNumber = case when EMPDET_With_EXERCISE.ClientIDNumber IS NULL OR LEN(LTRIM(RTRIM(EMPDET_With_EXERCISE.ClientIDNumber)))=0 then EMP.ClientIDNumber  ELSE EMPDET_With_EXERCISE.ClientIDNumber END 
FROM EmployeeMaster AS EMP WHERE EMP.LoginID = @LoginId AND EMPDET_With_EXERCISE.ExerciseNo = @ExerciseNo 
											
END
GO
