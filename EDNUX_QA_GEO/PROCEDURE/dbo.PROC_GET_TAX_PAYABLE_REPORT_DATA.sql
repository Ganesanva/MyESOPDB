/****** Object:  StoredProcedure [dbo].[PROC_GET_TAX_PAYABLE_REPORT_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_TAX_PAYABLE_REPORT_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_TAX_PAYABLE_REPORT_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GET_TAX_PAYABLE_REPORT_DATA]
(
	@Exerciseno NVARCHAR (100)
)

AS
BEGIN
SELECT
		SHEX.ExerciseNo, GR.GrantDate, GR.GrantRegistrationId, SHEX.ExerciseId, SHEX.ExercisePrice,
		SHEX.ExercisedQuantity, ISNULL(SHEX.FMVPrice, SHEX.TentativeFMVPrice) AS FMVPrice, SHEX.ExerciseDate, ISNULL(SHEX.PerqstValue,SHEX.TentativePerqstValue) AS PerqstValue , CM.CurrencyAlias as CurrencyName,
		TRSC.TAX_HEADING,
		CASE WHEN CIM.EXCEPT_FOR_TAXRATE_VAL = 1 THEN CASE WHEN (CIM.EXCEPT_FOR_TAXRATE = 'C') THEN COM.CountryName ELSE '' END END TAX_IDENTIFIER_COUNTRY, 
		EM.TAX_IDENTIFIER_STATE,		
		CASE WHEN EM.ReasonForTermination IS NULL THEN TRSC.TAXRATE_LIVE_EMPLOYEE ELSE TRSC.TAXRATE_SEPRATED_EMPLOYEE END AS Tax_Rate,		
		CASE WHEN CIM.EXCEPT_FOR_TAXRATE_VAL = 1 THEN 'Country Level' ELSE 'Company Level' END AS BasisOfTaxation,
		CASE WHEN CIM.EXCEPT_FOR_TAXRATE_VAL = 1 THEN CASE WHEN (CIM.EXCEPT_FOR_TAXRATE = 'R') THEN RT.Description ELSE '' END ELSE 'Company Level' END AS ResidentStatus

	FROM
	
		ShExercisedOptions SHEX	
		INNER JOIN GrantLeg GL ON GL.ID = SHEX.GrantLegSerialNumber 	
		INNER JOIN GrantOptions GOP ON GOP.EmployeeId = SHEX.EmployeeID AND GL.GrantOptionId = GOP.GrantOptionId
		INNER JOIN EmployeeMaster EM ON EM.EmployeeID = SHEX.EmployeeID
		INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId = GL.GrantRegistrationId
		INNER JOIN Scheme SCH ON SCH.SchemeId = GL.SchemeId
		INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON CIM.MIT_ID = SCH.MIT_ID
		INNER JOIN CurrencyMaster CM ON CM.CurrencyID = CIM.CurrencyID
		INNER JOIN EMPDET_With_EXERCISE EWE ON EWE.ExerciseNo = SHEX.ExerciseNo
		INNER JOIN CountryMaster COM ON COM.CountryAliasName = EWE.CountryName
		LEFT OUTER JOIN TAX_RATE_SETTING_CONFIG TRSC ON TRSC.MIT_ID = SCH.MIT_ID AND IS_ACTIVE = 1 AND COM.ID = TRSC.COUNTRY_ID
		INNER JOIN ResidentialType RT ON RT.ResidentialStatus = EWE.ResidentialStatus
		
	WHERE 
		SHEX.ExerciseNo = @Exerciseno
			
	GROUP BY
		SHEX.ExerciseNo, GrantDate,GR.GrantRegistrationId, SHEX.ExerciseId, SHEX.ExercisePrice, SHEX.ExercisedQuantity,
		SHEX.FMVPrice, SHEX.ExerciseDate, EM.ResidentialStatus, SHEX.PerqstValue, CM.CurrencyAlias, TRSC.TAX_HEADING, EM.ReasonForTermination,
		TRSC.TAXRATE_LIVE_EMPLOYEE, TRSC.TAXRATE_SEPRATED_EMPLOYEE, SHEX.TentativeFMVPrice, SHEX.TentativePerqstPayable,
		EM.TAX_IDENTIFIER_COUNTRY, EM.TAX_IDENTIFIER_STATE, CIM.EXCEPT_FOR_TAXRATE_VAL, CIM.EXCEPT_FOR_TAXRATE, COM.CountryName, RT.Description, SHEX.TentativeFMVPrice, SHEX.TentativePerqstValue
		
		
END
GO
