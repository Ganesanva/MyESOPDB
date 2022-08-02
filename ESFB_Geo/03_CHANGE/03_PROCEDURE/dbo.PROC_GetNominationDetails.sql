DROP PROCEDURE IF EXISTS [dbo].[PROC_GetNominationDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetNominationDetails]    Script Date: 18-07-2022 15:05:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GetNominationDetails]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT EnableNominee
		,EmpEditNominee
		,SendMailToEmp
		,NominationText
		,NominationAddress
		,NominationTextNote
		,IsNomineeAutoApproval
		,AllowMaxNominee	
		,ISNULL(EnableRelationWithEmp,0) AS EnableRelationWithEmp
		,ISNULL(EnableNomineePANNo,0) AS EnableNomineePANNo
		,ISNULL(EnableGuardianRelation,0) AS EnableGuardianRelation
		,ISNULL(EnableGUardianPANNo,0) AS EnableGUardianPANNo
		,ISNULL(EnableNomineeEmailId,0) AS EnableNomineeEmailId
	    ,ISNULL(EnableNomineeContactNo,0) AS EnableNomineeContactNo
	    ,ISNULL(EnableNomineeAdharNo,0)AS EnableNomineeAdharNo
	    ,ISNULL(EnableNomineeSIDNo,0) AS EnableNomineeSIDNo
	    ,ISNULL(EnableNomineeOther1,0) AS EnableNomineeOther1
	    ,ISNULL(EnableNomineeOther2,0) AS EnableNomineeOther2
	    ,ISNULL(EnableNomineeOther3,0) AS EnableNomineeOther3
	    ,ISNULL(EnableNomineeOther4,0) AS EnableNomineeOther4
	    ,ISNULL(EnableGuardianEmailId,0) AS EnableGuardianEmailId
	    ,ISNULL(EnableGuardianContactNo,0) AS EnableGuardianContactNo
	    ,ISNULL(EnableGuardianAdharNo,0) AS EnableGuardianAdharNo
	    ,ISNULL(EnableGuardianSIDNo,0) AS EnableGuardianSIDNo
	    ,ISNULL(EnableGuardianOther1,0) AS EnableGuardianOther1
	    ,ISNULL(EnableGuardianOther2,0) AS EnableGuardianOther2
	    ,ISNULL(EnableGuardianOther3,0) AS EnableGuardianOther3
	    ,ISNULL(EnableGuardianOther4,0) AS EnableGuardianOther4
									
	FROM CompanyParameters

	SET NOCOUNT OFF;
END
GO


