/****** Object:  View [dbo].[VW_PERQUISITE_TAX_CALCULATION_SHEXERCISE]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_PERQUISITE_TAX_CALCULATION_SHEXERCISE]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[VW_PERQUISITE_TAX_CALCULATION_SHEXERCISE] 
AS	

SELECT        SEOP.ExerciseId, SEOP.ExerciseNo, SEOP.GrantLegSerialNumber, GL.SchemeId, GL.GrantOptionId, SEOP.EmployeeID, SEOP.ExercisedQuantity, SEOP.ExercisePrice, SEOP.SharesIssuedDate, SEOP.Cash, SEOP.ExerciseDate, 
                         GR.GrantDate, SEOP.FMVPrice, SEOP.IsMassUpload, ISNULL(GR.Apply_SAR, ''N'') AS Apply_SAR, EM.ResidentialStatus, (CASE WHEN ((EM.DateOfTermination IS NULL) OR
                         (EM.DateOfTermination = '''')) THEN ''L'' ELSE ''R'' END) AS Emp_Status, ISNULL(EM.tax_slab, 0) AS EMP_TAX_SLAB, (CASE WHEN ((UPPER(PTER.[Action]) = ''A'') OR
                         (UPPER(PTER.[Action]) = ''E'')) THEN ''G'' ELSE ''C'' END) AS PERQTAXRULE, (CASE WHEN ((UPPER(PTER.[Action]) = ''A'') OR
                         (UPPER(PTER.[Action]) = ''E'')) THEN PTER.PerqValue ELSE CASE WHEN ((UPPER(EM.ResidentialStatus) = ''R'') OR
                         (EM.ResidentialStatus IS NULL) OR
                         (EM.ResidentialStatus = '''')) THEN RIPerqValue WHEN UPPER(EM.ResidentialStatus) = ''N'' THEN NRIPerqValue WHEN UPPER(EM.ResidentialStatus) = ''F'' THEN FNPerqValue END END) AS CALCPERQVAL, 
                         (CASE WHEN ((UPPER(PTER.[Action]) = ''A'') OR
                         (UPPER(PTER.[Action]) = ''E'')) THEN PTER.PerqTax ELSE CASE WHEN ((UPPER(EM.ResidentialStatus) = ''R'') OR
                         (EM.ResidentialStatus IS NULL) OR
                         (EM.ResidentialStatus = '''')) THEN RIPerqTax WHEN UPPER(EM.ResidentialStatus) = ''N'' THEN NRIPerqTax WHEN UPPER(EM.ResidentialStatus) = ''F'' THEN FNPerqTax END END) AS CALCPERQTAX, 
                         (CASE WHEN ((UPPER(PTER.[Action]) = ''A'') OR
                         (UPPER(PTER.[Action]) = ''E'')) THEN PTER.Perq_tax_rate ELSE CASE WHEN ((EM.DateOfTermination IS NULL) OR
                         (EM.DateOfTermination = '''')) THEN CASE WHEN Apply_Emp_taxslab = ''Y'' THEN ISNULL(EM.Tax_slab, 0) ELSE prequisiteTax END ELSE CASE WHEN ((TaxRate_ResignedEmp > 0) AND ((UPPER(RFT.Reason) != '' '') OR
                         (UPPER(RFT.Reason) != NULL))) THEN TaxRate_ResignedEmp ELSE CASE WHEN Apply_Emp_taxslab = ''Y'' THEN ISNULL(EM.Tax_slab, 0) ELSE prequisiteTax END END END END) AS PERQTAXRATE, EM.EmployeeName, 
                         EM.EmployeeEmail, CM.Apply_Emp_taxslab, CM.FaceVaue, ISNULL(EM.ReasonForTermination, 0) AS ReasonForTermination, GL.FinalVestingDate AS VestingDate, SC.MIT_ID, SEOP.ExercisableQuantity, GL.GrantedOptions, 
                         EM.LoginID
FROM            dbo.ShExercisedOptions AS SEOP INNER JOIN
                         dbo.GrantLeg AS GL ON SEOP.GrantLegSerialNumber = GL.ID INNER JOIN
                         dbo.GrantRegistration AS GR ON GL.GrantRegistrationId = GR.GrantRegistrationId INNER JOIN
                         dbo.GrantOptions AS GOP ON GL.GrantOptionId = GOP.GrantOptionId INNER JOIN
                         dbo.EmployeeMaster AS EM ON GOP.EmployeeId = EM.EmployeeID LEFT OUTER JOIN
                         dbo.ReasonForTermination AS RFT ON EM.ReasonForTermination = RFT.ID LEFT OUTER JOIN
                         dbo.PerqstTaxExceptionRule AS PTER ON EM.EmployeeID = PTER.Employeeid AND GOP.GrantOptionId = PTER.Grantoptionid INNER JOIN
                         dbo.Scheme AS SC ON SC.SchemeId = GR.SchemeId CROSS JOIN
                         dbo.CompanyParameters AS CM
WHERE        (SEOP.FMVPrice IS NULL OR
                         SEOP.FMVPrice = 0) AND (CONVERT(DATE, SEOP.ExerciseDate) <= CONVERT(DATE, GETDATE())) AND (CONVERT(DATE, SEOP.ExerciseDate) >= CONVERT(DATE,
                             (SELECT        Calc_PerqDt_From
                               FROM            dbo.CompanyParameters))) AND (EM.Deleted = 0)
' 
GO
