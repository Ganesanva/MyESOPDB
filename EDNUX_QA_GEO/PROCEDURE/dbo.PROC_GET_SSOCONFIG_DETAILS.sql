/****** Object:  StoredProcedure [dbo].[PROC_GET_SSOCONFIG_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SSOCONFIG_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_SSOCONFIG_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_SSOCONFIG_DETAILS]

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		SSOId, GroupID, GroupName, CompanyName, InsertionType, IDP_SP_URL, DestinationURL, AssertionConsumerServiceURL, IssuerURL,
		RelayState, CertificateName, [Certificate], [Parameters], IsSSOLoginActiveForEmp, IsSSOLoginActiveForCR,[Status], [IsSSOLoginActiveForEmp], [IsSSOLoginActiveForCR],
	    CASE WHEN IsSSOLoginActiveForCR='True' And IsSSOLoginActiveForEmp='True' then 'Employee and CR' WHEN IsSSOLoginActiveForEmp = 'True' And IsSSOLoginActiveForCR='False'  then 'Employee' WHEN IsSSOLoginActiveForCR = 'True' And IsSSOLoginActiveForEmp = 'False'  then 'CR' ELSE 'Not Defined' end as IsActiveFor
	
	FROM 
		SSOConfiguration 
		
	WHERE 
		([Status]='True')

	SET NOCOUNT OFF;

END
GO
