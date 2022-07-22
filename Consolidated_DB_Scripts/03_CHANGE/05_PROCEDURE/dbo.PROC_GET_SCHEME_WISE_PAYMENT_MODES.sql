DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SCHEME_WISE_PAYMENT_MODES]
GO

/****** Object:  StoredProcedure [dbo].[PROC_GET_SCHEME_WISE_PAYMENT_MODES]    Script Date: 18-07-2022 18:35:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[PROC_GET_SCHEME_WISE_PAYMENT_MODES]
(
	 @LoginID			NVARCHAR(100), 
	 @MIT_ID			INT,
	 @PAYMENT_MODE_CONFIG_TYPE		NVARCHAR(100),
	 @ResidentType		NVARCHAR(10),
	 @ExerciseNo		INT = NULL 
)
AS
BEGIN
	SET NOCOUNT ON;
		SELECT   Distinct PM.PaymentMode,PM.Parentid,PM.PayModeName,
				 CASE WHEN @PAYMENT_MODE_CONFIG_TYPE ='Resident' THEN @ResidentType WHEN @PAYMENT_MODE_CONFIG_TYPE ='COUNTRY' THEN 'Country' ELSE 'Company' END AS ResidentialStatus,
				 RPM.ProcessNote, RPM.isActivated ,PM.Id,MST.DisclaimerNote,
				 MST.ActualDisclaimerText,MST.TentativeDisclaimerText,MST.Is_ShowPaymentConfirmRecipt,MST.Is_ShowTaxConfirmRecipt,RPM.DECLARATION
				 ,MCC.MCC_ID,MCC.CODE_NAME
				 ,ISNULL(RPM.IsValidatedDematAcc, 0) AS IsValidatedDematAcc, ISNULL(RPM.IsValidatedBankAcc, 0) AS IsValidatedBankAcc, RPM.MIT_ID,RPM.IsOneProcessFlow, 
				 ISNULL(RPM.IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc,Acknowledgement
				,MST.Is_ShowCMLCopy,Sc.SchemeId,Sc.TrustType     
			
				FROM GrantOptions GOP
				INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GOP.GrantOptionId 
				LEFT JOIN ShExercisedOptions SH ON SH.GrantLegSerialNumber= GrantLeg.ID
				LEFT JOIN EmployeeMaster EM ON GOP.EmployeeId = EM.EmployeeId 
				INNER JOIN Scheme SC ON GrantLeg.SchemeId = SC.SchemeId AND SC.SchemeId=GOP.schemeID
				LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = SC.MIT_ID 
				LEFT JOIN  ResidentialPaymentMode RPM ON RPM.MIT_ID=SC.MIT_ID
				LEFT JOIN PaymentMaster PM ON RPM.PaymentMaster_Id = PM.Id 
				LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER  MST ON RPM.Id=MST.RPMID
				LEFT JOIN MST_COM_CODE MCC ON MCC.MCCG_ID=ISNULL(RPM.DYNAMIC_FORM,1048)  
		
				WHERE EM.LoginID = @LoginID 
				AND convert(date,GETDATE())>= GrantLeg.FinalVestingDate and convert(date,GETDATE()) <= GrantLeg.FinalExpirayDate 
				AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity > = 0 
				--AND GrantLeg.ExercisableQuantity >  0
				AND GrantLeg.Status = 'A' 
				--AND (GrantLeg.ExercisableQuantity >0  or GrantLeg.UnapprovedExerciseQuantity >0) 
				AND SC.MIT_ID= @MIT_ID AND EM.Deleted=0
				AND isActivated='Y' and RPM.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = @PAYMENT_MODE_CONFIG_TYPE 
				AND RPM. ResidentialType_Id IN(Select Id from ResidentialType where ResidentialStatus = @ResidentType) 
				AND Sc.TrustType  IN ('TC','TCOnly','CCNonTC') AND PM.PaymentMode  NOT IN  ('A','P')
				AND ((@ExerciseNo IS NULL OR @ExerciseNo = '') OR ( LTRIM(RTRIM(SH.ExerciseNo)) IN (SELECT LTRIM(RTRIM([Param])) FROM FN_ACC_SPLITSTRING(@ExerciseNo,','))))	
			--	OR SH.ExerciseNo=ISNULL(@ExerciseNo,0)

UNION  
		SELECT   Distinct PM.PaymentMode,PM.Parentid,PM.PayModeName,
				 CASE WHEN @PAYMENT_MODE_CONFIG_TYPE ='Resident' THEN @ResidentType WHEN @PAYMENT_MODE_CONFIG_TYPE ='COUNTRY' THEN 'Country' ELSE 'Company' END AS ResidentialStatus,
				 RPM.ProcessNote, RPM.isActivated ,PM.Id,MST.DisclaimerNote,
				 MST.ActualDisclaimerText,MST.TentativeDisclaimerText,MST.Is_ShowPaymentConfirmRecipt,MST.Is_ShowTaxConfirmRecipt,RPM.DECLARATION
				 ,MCC.MCC_ID,MCC.CODE_NAME
				 ,ISNULL(RPM.IsValidatedDematAcc, 0) AS IsValidatedDematAcc, ISNULL(RPM.IsValidatedBankAcc, 0) AS IsValidatedBankAcc, RPM.MIT_ID,RPM.IsOneProcessFlow, 
				 ISNULL(RPM.IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc,Acknowledgement
				,MST.Is_ShowCMLCopy,Sc.SchemeId,Sc.TrustType     
			
				FROM GrantOptions GOP
				INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GOP.GrantOptionId 
				LEFT JOIN ShExercisedOptions SH ON SH.GrantLegSerialNumber= GrantLeg.ID
				LEFT JOIN EmployeeMaster EM ON GOP.EmployeeId = EM.EmployeeId 
				INNER JOIN Scheme SC ON GrantLeg.SchemeId = SC.SchemeId AND SC.SchemeId=GOP.schemeID
				LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = SC.MIT_ID 
				LEFT JOIN  ResidentialPaymentMode RPM ON RPM.MIT_ID=SC.MIT_ID
				LEFT JOIN PaymentMaster PM ON RPM.PaymentMaster_Id = PM.Id 
				LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER  MST ON RPM.Id=MST.RPMID
				LEFT JOIN MST_COM_CODE MCC ON MCC.MCCG_ID=ISNULL(RPM.DYNAMIC_FORM,1048)  
		
				WHERE EM.LoginID = @LoginID 
				AND convert(date,GETDATE())>= GrantLeg.FinalVestingDate and convert(date,GETDATE()) <= GrantLeg.FinalExpirayDate 
				AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity > = 0 
				--AND GrantLeg.ExercisableQuantity >  0
				AND GrantLeg.Status = 'A' 
				--AND (GrantLeg.ExercisableQuantity >0  or GrantLeg.UnapprovedExerciseQuantity >0) 
				AND SC.MIT_ID= @MIT_ID AND EM.Deleted=0
				AND isActivated='Y' and RPM.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = @PAYMENT_MODE_CONFIG_TYPE 
				AND RPM. ResidentialType_Id IN(Select Id from ResidentialType where ResidentialStatus = @ResidentType)
			  --  AND PM.PaymentMode IN (CASE WHEN  Sc.TrustType IN ('TCLSA','CCSA') THEN 'A' END) AND PM.PaymentMode NOT IN('P')
			  AND LTRIM(RTRIM(Sc.TrustType)) IN ('CCSA','TCLSA') 	AND PM.PaymentMode   IN ('A')
			  AND ((@ExerciseNo IS NULL OR @ExerciseNo = '') OR ( LTRIM(RTRIM(SH.ExerciseNo)) IN (SELECT LTRIM(RTRIM([Param])) FROM FN_ACC_SPLITSTRING(@ExerciseNo,','))))

 Union  

			 SELECT   Distinct PM.PaymentMode,PM.Parentid,PM.PayModeName,
				 CASE WHEN @PAYMENT_MODE_CONFIG_TYPE ='Resident' THEN @ResidentType WHEN @PAYMENT_MODE_CONFIG_TYPE ='COUNTRY' THEN 'Country' ELSE 'Company' END AS ResidentialStatus,
				 RPM.ProcessNote, RPM.isActivated ,PM.Id,MST.DisclaimerNote,
				 MST.ActualDisclaimerText,MST.TentativeDisclaimerText,MST.Is_ShowPaymentConfirmRecipt,MST.Is_ShowTaxConfirmRecipt,RPM.DECLARATION
				 ,MCC.MCC_ID,MCC.CODE_NAME
				 ,ISNULL(RPM.IsValidatedDematAcc, 0) AS IsValidatedDematAcc, ISNULL(RPM.IsValidatedBankAcc, 0) AS IsValidatedBankAcc, RPM.MIT_ID,RPM.IsOneProcessFlow, 
				 ISNULL(RPM.IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc,Acknowledgement
				,MST.Is_ShowCMLCopy,Sc.SchemeId,Sc.TrustType     
			
				FROM GrantOptions GOP
				INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GOP.GrantOptionId 
				LEFT JOIN ShExercisedOptions SH ON SH.GrantLegSerialNumber= GrantLeg.ID
				LEFT JOIN EmployeeMaster EM ON GOP.EmployeeId = EM.EmployeeId 
				INNER JOIN Scheme SC ON GrantLeg.SchemeId = SC.SchemeId AND SC.SchemeId=GOP.schemeID
				LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = SC.MIT_ID 
				LEFT JOIN  ResidentialPaymentMode RPM ON RPM.MIT_ID=SC.MIT_ID
				LEFT JOIN PaymentMaster PM ON RPM.PaymentMaster_Id = PM.Id 
				LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER  MST ON RPM.Id=MST.RPMID
				LEFT JOIN MST_COM_CODE MCC ON MCC.MCCG_ID=ISNULL(RPM.DYNAMIC_FORM,1048)  
		
				WHERE EM.LoginID = @LoginID 
				AND convert(date,GETDATE())>= GrantLeg.FinalVestingDate and convert(date,GETDATE()) <= GrantLeg.FinalExpirayDate 
				AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity > = 0 
				--AND GrantLeg.ExercisableQuantity >  0
				AND GrantLeg.Status = 'A' 
				--AND (GrantLeg.ExercisableQuantity >0  or GrantLeg.UnapprovedExerciseQuantity >0) 
				AND SC.MIT_ID= @MIT_ID AND EM.Deleted=0
				AND isActivated='Y' and RPM.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = @PAYMENT_MODE_CONFIG_TYPE 
				AND RPM. ResidentialType_Id IN(Select Id from ResidentialType where ResidentialStatus = @ResidentType)
			   -- AND PM.PaymentMode IN (CASE WHEN  Sc.TrustType IN ('TCLSP','CCSP') THEN 'P' END)
			    AND LTRIM(RTRIM(Sc.TrustType)) IN ('TCLSP','CCSP') 	AND PM.PaymentMode  IN ('P')
			   AND ((@ExerciseNo IS NULL OR @ExerciseNo = '') OR ( LTRIM(RTRIM(SH.ExerciseNo)) IN (SELECT LTRIM(RTRIM([Param])) FROM FN_ACC_SPLITSTRING(@ExerciseNo,','))))
Union  

		SELECT   Distinct PM.PaymentMode,PM.Parentid,PM.PayModeName,
				 CASE WHEN @PAYMENT_MODE_CONFIG_TYPE ='Resident' THEN @ResidentType WHEN @PAYMENT_MODE_CONFIG_TYPE ='COUNTRY' THEN 'Country' ELSE 'Company' END AS ResidentialStatus,
				 RPM.ProcessNote, RPM.isActivated ,PM.Id,MST.DisclaimerNote,
				 MST.ActualDisclaimerText,MST.TentativeDisclaimerText,MST.Is_ShowPaymentConfirmRecipt,MST.Is_ShowTaxConfirmRecipt,RPM.DECLARATION
				 ,MCC.MCC_ID,MCC.CODE_NAME
				 ,ISNULL(RPM.IsValidatedDematAcc, 0) AS IsValidatedDematAcc, ISNULL(RPM.IsValidatedBankAcc, 0) AS IsValidatedBankAcc, RPM.MIT_ID,RPM.IsOneProcessFlow, 
				 ISNULL(RPM.IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc,Acknowledgement
				,MST.Is_ShowCMLCopy,Sc.SchemeId,Sc.TrustType     
			
				FROM GrantOptions GOP
				INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GOP.GrantOptionId 
				LEFT JOIN ShExercisedOptions SH ON SH.GrantLegSerialNumber= GrantLeg.ID
				LEFT JOIN EmployeeMaster EM ON GOP.EmployeeId = EM.EmployeeId 
				INNER JOIN Scheme SC ON GrantLeg.SchemeId = SC.SchemeId AND SC.SchemeId=GOP.schemeID
				LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = SC.MIT_ID 
				LEFT JOIN  ResidentialPaymentMode RPM ON RPM.MIT_ID=SC.MIT_ID
				LEFT JOIN PaymentMaster PM ON RPM.PaymentMaster_Id = PM.Id 
				LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER  MST ON RPM.Id=MST.RPMID
				LEFT JOIN MST_COM_CODE MCC ON MCC.MCCG_ID=ISNULL(RPM.DYNAMIC_FORM,1048)  
		
				WHERE EM.LoginID = @LoginID 
				AND convert(date,GETDATE())>= GrantLeg.FinalVestingDate and convert(date,GETDATE()) <= GrantLeg.FinalExpirayDate 
				AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity > = 0 
				--AND GrantLeg.ExercisableQuantity >  0
				AND GrantLeg.Status = 'A' 
				--AND (GrantLeg.ExercisableQuantity >0  or GrantLeg.UnapprovedExerciseQuantity >0) 
				AND SC.MIT_ID= @MIT_ID AND EM.Deleted=0 
				AND isActivated='Y' and RPM.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = @PAYMENT_MODE_CONFIG_TYPE 
				AND RPM. ResidentialType_Id IN(Select Id from ResidentialType where ResidentialStatus = @ResidentType)   
				AND Sc.TrustType  IN ('TCandCLB','CCNonTCCB')
				AND ((@ExerciseNo IS NULL OR @ExerciseNo = '') OR ( LTRIM(RTRIM(SH.ExerciseNo)) IN (SELECT LTRIM(RTRIM([Param])) FROM FN_ACC_SPLITSTRING(@ExerciseNo,','))))
			--	AND PAYMENTMODE NOT IN (CASE WHEN Sc.TrustType IN ('TCandCLSA','CCNonTCCSA') THEN 'P' ELSE 'A' END)

Union  

		SELECT   Distinct PM.PaymentMode,PM.Parentid,PM.PayModeName,
				 CASE WHEN @PAYMENT_MODE_CONFIG_TYPE ='Resident' THEN @ResidentType WHEN @PAYMENT_MODE_CONFIG_TYPE ='COUNTRY' THEN 'Country' ELSE 'Company' END AS ResidentialStatus,
				 RPM.ProcessNote, RPM.isActivated ,PM.Id,MST.DisclaimerNote,
				 MST.ActualDisclaimerText,MST.TentativeDisclaimerText,MST.Is_ShowPaymentConfirmRecipt,MST.Is_ShowTaxConfirmRecipt,RPM.DECLARATION
				 ,MCC.MCC_ID,MCC.CODE_NAME
				 ,ISNULL(RPM.IsValidatedDematAcc, 0) AS IsValidatedDematAcc, ISNULL(RPM.IsValidatedBankAcc, 0) AS IsValidatedBankAcc, RPM.MIT_ID,RPM.IsOneProcessFlow, 
				 ISNULL(RPM.IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc,Acknowledgement
				,MST.Is_ShowCMLCopy,Sc.SchemeId,Sc.TrustType     
			
				FROM GrantOptions GOP
				INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GOP.GrantOptionId 
				LEFT JOIN ShExercisedOptions SH ON SH.GrantLegSerialNumber= GrantLeg.ID
				LEFT JOIN EmployeeMaster EM ON GOP.EmployeeId = EM.EmployeeId 
				INNER JOIN Scheme SC ON GrantLeg.SchemeId = SC.SchemeId AND SC.SchemeId=GOP.schemeID
				LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = SC.MIT_ID 
				LEFT JOIN  ResidentialPaymentMode RPM ON RPM.MIT_ID=SC.MIT_ID
				LEFT JOIN PaymentMaster PM ON RPM.PaymentMaster_Id = PM.Id 
				LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER  MST ON RPM.Id=MST.RPMID
				LEFT JOIN MST_COM_CODE MCC ON MCC.MCCG_ID=ISNULL(RPM.DYNAMIC_FORM,1048)  
		
				WHERE EM.LoginID = @LoginID 
				AND convert(date,GETDATE())>= GrantLeg.FinalVestingDate and convert(date,GETDATE()) <= GrantLeg.FinalExpirayDate 
				AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity > = 0 
				--AND GrantLeg.ExercisableQuantity >  0
				AND GrantLeg.Status = 'A' 
				--AND (GrantLeg.ExercisableQuantity >0  or GrantLeg.UnapprovedExerciseQuantity >0) 
				AND SC.MIT_ID= @MIT_ID AND EM.Deleted=0
				AND isActivated='Y' and RPM.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = @PAYMENT_MODE_CONFIG_TYPE 
				AND RPM. ResidentialType_Id IN(Select Id from ResidentialType where ResidentialStatus = @ResidentType) 
			    AND Sc.TrustType  IN ('TCLB','CCB') 
				AND PM.PaymentMode  IN  ('A','P')
				AND ((@ExerciseNo IS NULL OR @ExerciseNo = '') OR ( LTRIM(RTRIM(SH.ExerciseNo)) IN (SELECT LTRIM(RTRIM([Param])) FROM FN_ACC_SPLITSTRING(@ExerciseNo,','))))

Union  

		SELECT   Distinct PM.PaymentMode,PM.Parentid,PM.PayModeName,
				 CASE WHEN @PAYMENT_MODE_CONFIG_TYPE ='Resident' THEN @ResidentType WHEN @PAYMENT_MODE_CONFIG_TYPE ='COUNTRY' THEN 'Country' ELSE 'Company' END AS ResidentialStatus,
				 RPM.ProcessNote, RPM.isActivated ,PM.Id,MST.DisclaimerNote,
				 MST.ActualDisclaimerText,MST.TentativeDisclaimerText,MST.Is_ShowPaymentConfirmRecipt,MST.Is_ShowTaxConfirmRecipt,RPM.DECLARATION
				 ,MCC.MCC_ID,MCC.CODE_NAME
				 ,ISNULL(RPM.IsValidatedDematAcc, 0) AS IsValidatedDematAcc, ISNULL(RPM.IsValidatedBankAcc, 0) AS IsValidatedBankAcc, RPM.MIT_ID,RPM.IsOneProcessFlow, 
				 ISNULL(RPM.IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc,Acknowledgement
				,MST.Is_ShowCMLCopy,Sc.SchemeId,Sc.TrustType     
			
				FROM GrantOptions GOP
				INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GOP.GrantOptionId 
				LEFT JOIN ShExercisedOptions SH ON SH.GrantLegSerialNumber= GrantLeg.ID
				LEFT JOIN EmployeeMaster EM ON GOP.EmployeeId = EM.EmployeeId 
				INNER JOIN Scheme SC ON GrantLeg.SchemeId = SC.SchemeId AND SC.SchemeId=GOP.schemeID
				LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = SC.MIT_ID 
				LEFT JOIN  ResidentialPaymentMode RPM ON RPM.MIT_ID=SC.MIT_ID
				LEFT JOIN PaymentMaster PM ON RPM.PaymentMaster_Id = PM.Id 
				LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER  MST ON RPM.Id=MST.RPMID
				LEFT JOIN MST_COM_CODE MCC ON MCC.MCCG_ID=ISNULL(RPM.DYNAMIC_FORM,1048)  
		
				WHERE EM.LoginID = @LoginID 
				AND convert(date,GETDATE())>= GrantLeg.FinalVestingDate and convert(date,GETDATE()) <= GrantLeg.FinalExpirayDate 
				AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity > = 0 
				--AND GrantLeg.ExercisableQuantity >  0
				AND GrantLeg.Status = 'A' 
				--AND (GrantLeg.ExercisableQuantity >0  or GrantLeg.UnapprovedExerciseQuantity >0) 
				AND SC.MIT_ID= @MIT_ID AND EM.Deleted=0
				AND isActivated='Y' and RPM.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = @PAYMENT_MODE_CONFIG_TYPE 
				AND RPM. ResidentialType_Id IN(Select Id from ResidentialType where ResidentialStatus = @ResidentType)   
				--AND Sc.TrustType  IN ('TCandCLSA','CCNonTCCSA')
				AND PM.PAYMENTMODE NOT IN (CASE WHEN Sc.TrustType IN ('TCandCLSA','CCNonTCCSA') THEN 'P' WHEN Sc.TrustType IN('TCandCLSP','CCNonTCCSP') THEN 'A' END)
				AND ((@ExerciseNo IS NULL OR @ExerciseNo = '') OR ( LTRIM(RTRIM(SH.ExerciseNo)) IN (SELECT LTRIM(RTRIM([Param])) FROM FN_ACC_SPLITSTRING(@ExerciseNo,','))))

Union  
				SELECT   Distinct PM.PaymentMode,PM.Parentid,PM.PayModeName,
				 CASE WHEN @PAYMENT_MODE_CONFIG_TYPE ='Resident' THEN @ResidentType WHEN @PAYMENT_MODE_CONFIG_TYPE ='COUNTRY' THEN 'Country' ELSE 'Company' END AS ResidentialStatus,
				 RPM.ProcessNote, RPM.isActivated ,PM.Id,MST.DisclaimerNote,
				 MST.ActualDisclaimerText,MST.TentativeDisclaimerText,MST.Is_ShowPaymentConfirmRecipt,MST.Is_ShowTaxConfirmRecipt,RPM.DECLARATION
				 ,MCC.MCC_ID,MCC.CODE_NAME
				 ,ISNULL(RPM.IsValidatedDematAcc, 0) AS IsValidatedDematAcc, ISNULL(RPM.IsValidatedBankAcc, 0) AS IsValidatedBankAcc, RPM.MIT_ID,RPM.IsOneProcessFlow, 
				 ISNULL(RPM.IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc,Acknowledgement
				,MST.Is_ShowCMLCopy,Sc.SchemeId,Sc.TrustType     
			
				FROM GrantOptions GOP
				INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GOP.GrantOptionId 
				LEFT JOIN ShExercisedOptions SH ON SH.GrantLegSerialNumber= GrantLeg.ID
				LEFT JOIN EmployeeMaster EM ON GOP.EmployeeId = EM.EmployeeId 
				INNER JOIN Scheme SC ON GrantLeg.SchemeId = SC.SchemeId AND SC.SchemeId=GOP.schemeID
				LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = SC.MIT_ID 
				LEFT JOIN  ResidentialPaymentMode RPM ON RPM.MIT_ID=SC.MIT_ID
				LEFT JOIN PaymentMaster PM ON RPM.PaymentMaster_Id = PM.Id 
				LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER  MST ON RPM.Id=MST.RPMID
				LEFT JOIN MST_COM_CODE MCC ON MCC.MCCG_ID=ISNULL(RPM.DYNAMIC_FORM,1048)  
		
				WHERE EM.LoginID = @LoginID 
				AND convert(date,GETDATE())>= GrantLeg.FinalVestingDate and convert(date,GETDATE()) <= GrantLeg.FinalExpirayDate 
				AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity > = 0 
				--AND GrantLeg.ExercisableQuantity >  0
				AND GrantLeg.Status = 'A' 
				--AND (GrantLeg.ExercisableQuantity >0  or GrantLeg.UnapprovedExerciseQuantity >0) 
				AND SC.MIT_ID= @MIT_ID AND EM.Deleted=0
				AND isActivated='Y' and RPM.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = @PAYMENT_MODE_CONFIG_TYPE 
				AND RPM. ResidentialType_Id IN(Select Id from ResidentialType where ResidentialStatus = @ResidentType) 
			    AND (Sc.TrustType= 'N' or Sc.TrustType = NULL ) AND PM.PaymentMode NOT IN  ('A','P')
				AND ((@ExerciseNo IS NULL OR @ExerciseNo = '') OR ( LTRIM(RTRIM(SH.ExerciseNo)) IN (SELECT LTRIM(RTRIM([Param])) FROM FN_ACC_SPLITSTRING(@ExerciseNo,','))))
END		 
GO


