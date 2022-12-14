/****** Object:  UserDefinedFunction [dbo].[FunEmployeeDematDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FunEmployeeDematDetails]
GO
/****** Object:  UserDefinedFunction [dbo].[FunEmployeeDematDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************
Modified By: Chetan Tembhre
Modified Date: 21-Jun-2013
Description: Get employee demat details as per payment mode
SELECT * FROM FunEmployeeDematDetails ('1990-01-01','2015-04-21')
*****************************************************************************/ 
CREATE FUNCTION [dbo].[FunEmployeeDematDetails]
( 
  @STARTDATE DATETIME=NULL,
  @ENDDATE DATETIME=NULL
)
RETURNS TABLE 
AS
RETURN 
(
 SELECT 
			SHEX.ExerciseID AS ExercisedID,
			EMPInner.EmployeeID AS EmployeeID,
			EMPInner.LoginID AS LoginID,
			CASE WHEN ((SHEX.paymentmode = 'D' OR SHEX.paymentmode = 'Q' OR SHEX.paymentmode = 'R' OR SHEX.paymentmode = 'W') AND (SHOFF.ResidentialStatus IS NOT NULL OR SHOFF.ResidentialStatus!='')) 
			     THEN 
			        CASE WHEN SHOFF.ResidentialStatus='R' THEN 'Indian Resident'
						 WHEN SHOFF.ResidentialStatus='N' THEN 'Non Resident Indian'			        
			             WHEN SHOFF.ResidentialStatus='F' THEN 'Foreign National'
			        ELSE SHOFF.ResidentialStatus END
				WHEN ((SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P') AND (SHCASH.ResidentialStatus IS NOT NULL OR SHCASH.ResidentialStatus!='')) 
				THEN 
				   CASE WHEN SHCASH.ResidentialStatus='R' THEN 'Indian Resident'
				    	WHEN SHCASH.ResidentialStatus='N' THEN 'Non Resident Indian'			        
			            WHEN SHCASH.ResidentialStatus='F' THEN 'Foreign National'
			       ELSE SHCASH.ResidentialStatus END 
				WHEN (SHEX.paymentmode = 'F' AND (SHFUND.ResidentialStatus IS NOT NULL OR SHFUND.ResidentialStatus!='')) 
				THEN 
				   CASE WHEN SHFUND.ResidentialStatus='R' THEN 'Indian Resident'
				    	WHEN SHFUND.ResidentialStatus='N' THEN 'Non Resident Indian'			        
			            WHEN SHFUND.ResidentialStatus='F' THEN 'Foreign National'
			       ELSE SHFUND.ResidentialStatus END 
				WHEN (SHEX.paymentmode = 'N' AND (SHON.ResidentialStatus IS NOT NULL OR SHON.ResidentialStatus!='')) 
				THEN 
				   CASE WHEN SHON.ResidentialStatus='R' THEN 'Indian Resident'
				        WHEN SHON.ResidentialStatus='N' THEN 'Non Resident Indian'			        
			            WHEN SHON.ResidentialStatus='F' THEN 'Foreign National'
			       ELSE SHON.ResidentialStatus END  
				ELSE
				   CASE WHEN EMPInner.ResidentialStatus='R' THEN 'Indian Resident'
				        WHEN EMPInner.ResidentialStatus='N' THEN 'Non Resident Indian'			        
			            WHEN EMPInner.ResidentialStatus='F' THEN 'Foreign National'
			       ELSE EMPInner.ResidentialStatus END  
			END AS ResidentialStatus,
			CASE WHEN ((SHEX.paymentmode = 'D' OR SHEX.paymentmode = 'Q' OR SHEX.paymentmode = 'R' OR SHEX.paymentmode = 'W') AND (ITCircle_WardNo IS NOT NULL OR ITCircle_WardNo!='')) THEN SHOFF.ITCircle_WardNo  
				--WHEN (SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P') THEN SHCASH.
				--WHEN (SHEX.paymentmode = 'F') THEN 
				--WHEN (SHEX.paymentmode = 'N') THEN SHON.
				 --ELSE EMPInner.
			END AS ITCircle_WardNumber,
			CASE WHEN ((SHEX.paymentmode = 'D' OR SHEX.paymentmode = 'Q' OR SHEX.paymentmode = 'R' OR SHEX.paymentmode = 'W') AND (SHOFF.DepositoryName IS NOT NULL OR SHOFF.DepositoryName!='')) 
			     THEN  
			       CASE WHEN SHOFF.DepositoryName='N' THEN 'NSDL'
			            WHEN SHOFF.DepositoryName='C' THEN 'CDSL'  
			       ELSE SHOFF.DepositoryName END     
			     WHEN ((SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P') AND (SHCASH.DepositoryName IS NOT NULL OR SHCASH.DepositoryName!='')) 
			     THEN 
			       CASE WHEN SHCASH.DepositoryName='N' THEN 'NSDL'
			            WHEN SHCASH.DepositoryName='C' THEN 'CDSL'  
			       ELSE SHCASH.DepositoryName END 
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFU
				 WHEN (SHEX.paymentmode = 'N' AND (SHON.DepositoryName IS NOT NULL OR SHON.DepositoryName!='')) 
				 THEN 
				   CASE WHEN SHON.DepositoryName='N' THEN 'NSDL'
			            WHEN SHON.DepositoryName='C' THEN 'CDSL'  
			       ELSE SHON.DepositoryName END 
				 ELSE 
				   CASE WHEN EMPInner.DepositoryName='N' THEN 'NSDL'
			            WHEN EMPInner.DepositoryName='C' THEN 'CDSL'  
			       ELSE EMPInner.DepositoryName END 
			END AS DepositoryName,
			CASE WHEN ((SHEX.paymentmode = 'D' OR SHEX.paymentmode = 'Q' OR SHEX.paymentmode = 'R' OR SHEX.paymentmode = 'W') AND (SHOFF.DepositoryParticipantName IS NOT NULL OR SHOFF.DepositoryParticipantName!='')) THEN SHOFF.DepositoryParticipantName
			     WHEN ((SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P') AND (SHCASH.DPName IS NOT NULL OR SHCASH.DPName!='')) THEN SHCASH.DPName
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFUND
				 WHEN (SHEX.paymentmode = 'N' AND (SHON.DPName IS NOT NULL OR SHON.DPName!='')) THEN SHON.DPName
				 ELSE EMPInner.DepositoryParticipantNo 
			END AS  DepositoryParticipatoryName,
		   EMPInner.Confirmn_Dt as ConfirmationDate,
		   CASE WHEN ((SHEX.paymentmode = 'D' OR SHEX.paymentmode = 'Q' OR SHEX.paymentmode = 'R' OR SHEX.paymentmode = 'W') AND (SHOFF.DPRecord IS NOT NULL OR SHOFF.DPRecord!='')) THEN SHOFF.DPRecord
			    WHEN ((SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P') AND (SHCASH.DPRecord IS NOT NULL OR SHCASH.DPRecord!='')) THEN SHCASH.DPRecord
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFUND.dpr
				WHEN (SHEX.paymentmode = 'N' AND (SHON.DPRecord IS NOT NULL OR SHON.DPRecord!='')) THEN SHON.DPRecord
				ELSE EMPInner.DPRecord
			END AS  NameAsPerDPrecord,
		   EMPInner.EmployeeAddress,
		   EMPInner.EmployeeEmail,
		   EMPInner.EmployeePhone,
		   CASE WHEN ((SHEX.paymentmode = 'D' OR SHEX.paymentmode = 'Q' OR SHEX.paymentmode = 'R' OR SHEX.paymentmode = 'W') AND (SHOFF.PANNumber IS NOT NULL OR SHOFF.PANNumber!='')) THEN SHOFF.PANNumber
			    WHEN ((SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P') AND (SHCASH.PanNumber IS NOT NULL OR SHCASH.PanNumber!='')) THEN SHCASH.PanNumber
			    WHEN (SHEX.paymentmode = 'F' AND (SHFUND.PANNumber IS NOT NULL OR SHFUND.PANNumber!='')) THEN SHFUND.PANNumber
			    WHEN (SHEX.paymentmode = 'N' AND (SHON.PanNumber IS NOT NULL OR SHON.PanNumber!='') ) THEN SHON.PanNumber
			    ELSE EMPInner.PANNumber
			END AS  PAN_GIRNumber,
			CASE WHEN ((SHEX.paymentmode = 'D' OR SHEX.paymentmode = 'Q' OR SHEX.paymentmode = 'R' OR SHEX.paymentmode = 'W') AND (SHOFF.DematACType IS NOT NULL OR SHOFF.DematACType!='')) 
				 THEN 
				   CASE WHEN SHOFF.DematACType='R' THEN 'Repatriable'
				        WHEN SHOFF.DematACType='N' THEN 'Non Repatriable'
				   ELSE SHOFF.DematACType END     
			     WHEN ((SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P') AND (SHCASH.DematAcType IS NOT NULL OR SHCASH.DematAcType!='')) 
			     THEN 
			       CASE WHEN SHCASH.DematAcType='R' THEN 'Repatriable'
				        WHEN SHCASH.DematAcType='N' THEN 'Non Repatriable'
				   ELSE SHCASH.DematAcType END   
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFUND.DE
				 WHEN (SHEX.paymentmode = 'N' AND (SHON.DematAcType IS NOT NULL OR SHON.DematAcType!='') )  
				 THEN 
				   CASE WHEN SHON.DematAcType='R' THEN 'Repatriable'
				        WHEN SHON.DematAcType='N' THEN 'Non Repatriable'
				   ELSE SHON.DematAcType END 
				 ELSE 
				   CASE WHEN EMPInner.DematAccountType='R' THEN 'Repatriable'
				        WHEN EMPInner.DematAccountType='N' THEN 'Non Repatriable'
				   ELSE EMPInner.DematAccountType END 
			END AS  DematACType,	
			CASE WHEN ((SHEX.paymentmode = 'D' OR SHEX.paymentmode = 'Q' OR SHEX.paymentmode = 'R' OR SHEX.paymentmode = 'W') AND (SHOFF.DPIDNo IS NOT NULL OR SHOFF.DPIDNo!='')) THEN SHOFF.DPIDNo
			     WHEN ((SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P') AND (SHCASH.DPId IS NOT NULL OR SHCASH.DPId!='')) THEN SHCASH.DPId
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFUND.DE
				 WHEN (SHEX.paymentmode = 'N' AND (SHON.DPId IS NOT NULL OR SHON.DPId!='')) THEN SHON.DPId
				 ELSE EMPInner.DepositoryIDNumber
			END AS  DPIDNumber,	
			CASE WHEN ((SHEX.paymentmode = 'D' OR SHEX.paymentmode = 'Q' OR SHEX.paymentmode = 'R' OR SHEX.paymentmode = 'W') AND (SHOFF.ClientNo IS NOT NULL OR SHOFF.ClientNo!='')) THEN SHOFF.ClientNo
			     WHEN ((SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P') AND (SHCASH.ClientId IS NOT NULL OR SHCASH.ClientId!='')) THEN SHCASH.ClientId
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFUND.BankName
				 WHEN (SHEX.paymentmode = 'N' AND (SHON.ClientId IS NOT NULL OR SHON.ClientId!='')) THEN SHON.ClientId
				 ELSE EMPInner.ClientIDNumber
			END AS  ClientIDNumber,
			CASE WHEN ((SHEX.paymentmode = 'D' OR SHEX.paymentmode = 'Q' OR SHEX.paymentmode = 'R' OR SHEX.paymentmode = 'W') AND (SHOFF.Location IS NOT NULL)) THEN SHOFF.Location
			     WHEN ((SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P') AND SHCASH.Location IS NOT NULL ) THEN SHCASH.Location
				 WHEN (SHEX.paymentmode = 'F' AND (SHFUND.Location IS NOT NULL OR SHFUND.Location!='')) THEN SHFUND.Location
				 WHEN (SHEX.paymentmode = 'N' AND (SHON.Location IS NOT NULL OR SHFUND.Location!='')) THEN SHON.Location
				 ELSE EMPInner.Location
			END AS  Location
		FROM   shexercisedoptions SHEX INNER JOIN employeemaster EMPInner ON SHEX.employeeid = EMPInner.employeeid  
			LEFT OUTER JOIN shtransactiondetails SHOFF ON SHEX.ExerciseNo = SHOFF.ExerciseNo  
			LEFT OUTER JOIN transactiondetails_funding SHFUND ON SHEX.exerciseno = SHFUND.exerciseno   
			LEFT OUTER JOIN transaction_details SHON ON SHEX.exerciseno = SHON.exerciseno   
			LEFT OUTER JOIN transactiondetails_cashless SHCASH ON SHEX.ExerciseNo = SHCASH.ExerciseNo   
        WHERE   
			CONVERT(DATE,shex.exercisedate) between CONVERT(DATE,@STARTDATE) and CONVERT(DATE,@ENDDATE)
						
UNION 

SELECT 
        EXER.ExercisedID AS ExercisedID,
        EMPInner.EmployeeID AS EmployeeID, 
        EMPInner.LoginID AS LoginID,
        CASE WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W') AND (SHOFF.ResidentialStatus IS NOT NULL OR SHOFF.ResidentialStatus!='')) 
			     THEN 
			        CASE WHEN SHOFF.ResidentialStatus='R' THEN 'Indian Resident'
						 WHEN SHOFF.ResidentialStatus='N' THEN 'Non Resident Indian'			        
			             WHEN SHOFF.ResidentialStatus='F' THEN 'Foreign National'
			        ELSE SHOFF.ResidentialStatus END
				WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.ResidentialStatus IS NOT NULL OR SHCASH.ResidentialStatus!='')) 
				THEN 
				   CASE WHEN SHCASH.ResidentialStatus='R' THEN 'Indian Resident'
				    	WHEN SHCASH.ResidentialStatus='N' THEN 'Non Resident Indian'			        
			            WHEN SHCASH.ResidentialStatus='F' THEN 'Foreign National'
			       ELSE SHCASH.ResidentialStatus END 
				WHEN (EXER.paymentmode = 'F' AND (SHFUND.ResidentialStatus IS NOT NULL OR SHFUND.ResidentialStatus!='')) 
				THEN 
				   CASE WHEN SHFUND.ResidentialStatus='R' THEN 'Indian Resident'
				    	WHEN SHFUND.ResidentialStatus='N' THEN 'Non Resident Indian'			        
			            WHEN SHFUND.ResidentialStatus='F' THEN 'Foreign National'
			       ELSE SHFUND.ResidentialStatus END 
				WHEN (EXER.paymentmode = 'N' AND (SHON.ResidentialStatus IS NOT NULL OR SHON.ResidentialStatus!='')) 
				THEN 
				   CASE WHEN SHON.ResidentialStatus='R' THEN 'Indian Resident'
				        WHEN SHON.ResidentialStatus='N' THEN 'Non Resident Indian'			        
			            WHEN SHON.ResidentialStatus='F' THEN 'Foreign National'
			       ELSE SHON.ResidentialStatus END  
				ELSE
				   CASE WHEN EMPInner.ResidentialStatus='R' THEN 'Indian Resident'
				        WHEN EMPInner.ResidentialStatus='N' THEN 'Non Resident Indian'			        
			            WHEN EMPInner.ResidentialStatus='F' THEN 'Foreign National'
			       ELSE EMPInner.ResidentialStatus END  
			END AS ResidentialStatus,
			CASE WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W') AND (ITCircle_WardNo IS NOT NULL OR ITCircle_WardNo!='')) THEN SHOFF.ITCircle_WardNo  
				--WHEN (SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P') THEN SHCASH.
				--WHEN (SHEX.paymentmode = 'F') THEN 
				--WHEN (SHEX.paymentmode = 'N') THEN SHON.
				 --ELSE EMPInner.
			END AS ITCircle_WardNumber,
			CASE WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W') AND (SHOFF.DepositoryName IS NOT NULL OR SHOFF.DepositoryName!='')) 
			     THEN  
			       CASE WHEN SHOFF.DepositoryName='N' THEN 'NSDL'
			            WHEN SHOFF.DepositoryName='C' THEN 'CDSL'  
			       ELSE SHOFF.DepositoryName END     
			     WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.DepositoryName IS NOT NULL OR SHCASH.DepositoryName!='')) 
			     THEN 
			       CASE WHEN SHCASH.DepositoryName='N' THEN 'NSDL'
			            WHEN SHCASH.DepositoryName='C' THEN 'CDSL'  
			       ELSE SHCASH.DepositoryName END 
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFU
				 WHEN (EXER.paymentmode = 'N' AND (SHON.DepositoryName IS NOT NULL OR SHON.DepositoryName!='')) 
				 THEN 
				   CASE WHEN SHON.DepositoryName='N' THEN 'NSDL'
			            WHEN SHON.DepositoryName='C' THEN 'CDSL'  
			       ELSE SHON.DepositoryName END 
				 ELSE 
				   CASE WHEN EMPInner.DepositoryName='N' THEN 'NSDL'
			            WHEN EMPInner.DepositoryName='C' THEN 'CDSL'  
			       ELSE EMPInner.DepositoryName END 
			END AS DepositoryName,
			CASE WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W') AND (SHOFF.DepositoryParticipantName IS NOT NULL OR SHOFF.DepositoryParticipantName!='')) THEN SHOFF.DepositoryParticipantName
			     WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.DPName IS NOT NULL OR SHCASH.DPName!='')) THEN SHCASH.DPName
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFUND
				 WHEN (EXER.paymentmode = 'N' AND (SHON.DPName IS NOT NULL OR SHON.DPName!='')) THEN SHON.DPName
				 ELSE EMPInner.DepositoryParticipantNo 
			END AS  DepositoryParticipatoryName,
		   NULLIF(EMPInner.Confirmn_Dt,'1900-01-01 00:00:00.000') as ConfirmationDate,
		   CASE WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W') AND (SHOFF.DPRecord IS NOT NULL OR SHOFF.DPRecord!='')) THEN NULLIF(SHOFF.DPRecord,'null')
			    WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.DPRecord IS NOT NULL OR SHCASH.DPRecord!='')) THEN NULLIF(SHCASH.DPRecord,'null')
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFUND.dpr
				WHEN (EXER.paymentmode = 'N' AND (SHON.DPRecord IS NOT NULL OR SHON.DPRecord!='')) THEN NULLIF(SHON.DPRecord,'null')
				ELSE NULLIF(EMPInner.DPRecord,'null')
			END AS  NameAsPerDPrecord,
		   EMPInner.EmployeeAddress,
		   EMPInner.EmployeeEmail,
		   EMPInner.EmployeePhone,
		   CASE WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W') AND (SHOFF.PANNumber IS NOT NULL OR SHOFF.PANNumber!='')) THEN SHOFF.PANNumber
			    WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.PanNumber IS NOT NULL OR SHCASH.PanNumber!='')) THEN SHCASH.PanNumber
			    WHEN (EXER.paymentmode = 'F' AND (SHFUND.PANNumber IS NOT NULL OR SHFUND.PANNumber!='')) THEN SHFUND.PANNumber
			    WHEN (EXER.paymentmode = 'N' AND (SHON.PanNumber IS NOT NULL OR SHON.PanNumber!='') ) THEN SHON.PanNumber
			    ELSE EMPInner.PANNumber
			END AS  PAN_GIRNumber,
			CASE WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W') AND (SHOFF.DematACType IS NOT NULL OR SHOFF.DematACType!='')) 
				 THEN 
				   CASE WHEN SHOFF.DematACType='R' THEN 'Repatriable'
				        WHEN SHOFF.DematACType='N' THEN 'Non Repatriable'
				   ELSE SHOFF.DematACType END     
			     WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.DematAcType IS NOT NULL OR SHCASH.DematAcType!='')) 
			     THEN 
			       CASE WHEN SHCASH.DematAcType='R' THEN 'Repatriable'
				        WHEN SHCASH.DematAcType='N' THEN 'Non Repatriable'
				   ELSE SHCASH.DematAcType END   
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFUND.DE
				 WHEN (EXER.paymentmode = 'N' AND (SHON.DematAcType IS NOT NULL OR SHON.DematAcType!='') )  
				 THEN 
				   CASE WHEN SHON.DematAcType='R' THEN 'Repatriable'
				        WHEN SHON.DematAcType='N' THEN 'Non Repatriable'
				   ELSE SHON.DematAcType END 
				 ELSE 
				   CASE WHEN EMPInner.DematAccountType='R' THEN 'Repatriable'
				        WHEN EMPInner.DematAccountType='N' THEN 'Non Repatriable'
				   ELSE EMPInner.DematAccountType END 
			END AS  DematACType,	
			CASE WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W') AND (SHOFF.DPIDNo IS NOT NULL OR SHOFF.DPIDNo!='')) THEN SHOFF.DPIDNo
			     WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.DPId IS NOT NULL OR SHCASH.DPId!='')) THEN SHCASH.DPId
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFUND.DE
				 WHEN (EXER.paymentmode = 'N' AND (SHON.DPId IS NOT NULL OR SHON.DPId!='')) THEN SHON.DPId
				 ELSE EMPInner.DepositoryIDNumber
			END AS  DPIDNumber,	
			CASE WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W') AND (SHOFF.ClientNo IS NOT NULL OR SHOFF.ClientNo!='')) THEN SHOFF.ClientNo
			     WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.ClientId IS NOT NULL OR SHCASH.ClientId!='')) THEN SHCASH.ClientId
				 --WHEN (SHEX.paymentmode = 'F') THEN SHFUND.BankName
				 WHEN (EXER.paymentmode = 'N' AND (SHON.ClientId IS NOT NULL OR SHON.ClientId!='')) THEN SHON.ClientId
				 ELSE EMPInner.ClientIDNumber
			END AS  ClientIDNumber,
			CASE WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W') AND (SHOFF.Location IS NOT NULL)) THEN SHOFF.Location
			     WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND SHCASH.Location IS NOT NULL ) THEN SHCASH.Location
				 WHEN (EXER.paymentmode = 'F' AND (SHFUND.Location IS NOT NULL OR SHFUND.Location!='')) THEN SHFUND.Location
				 WHEN (EXER.paymentmode = 'N' AND (SHON.Location IS NOT NULL OR SHFUND.Location!='')) THEN SHON.Location
				 ELSE EMPInner.Location
			END AS  Location   
        FROM   exercised EXER 
        INNER JOIN grantleg GL ON EXER.grantlegserialnumber = GL.id   
        INNER JOIN grantoptions GRO ON GL.grantoptionid = GRO.grantoptionid  
        INNER JOIN employeemaster EMPInner ON GRO.EmployeeId = EMPInner.employeeid
        LEFT OUTER JOIN shtransactiondetails SHOFF ON EXER.ExerciseNo = SHOFF.ExerciseNo AND EXER.PaymentMode IN ('O','Q','D','W','R','I','X') 
        LEFT OUTER JOIN transactiondetails_funding SHFUND ON EXER.exerciseno = SHFUND.exerciseno AND EXER.PaymentMode = 'F'
        LEFT OUTER JOIN transaction_details SHON ON EXER.exerciseno = SHON.exerciseno AND SHON.exerciseno IS NOT NULL AND EXER.PaymentMode = 'N'
        LEFT OUTER JOIN transactiondetails_cashless SHCASH ON EXER.ExerciseNo = SHCASH.ExerciseNo AND EXER.PaymentMode IN ('C','A','P')
        WHERE 
       CONVERT(DATE,exer.exerciseddate) between CONVERT(DATE,@STARTDATE) and CONVERT(DATE,@ENDDATE)
)
GO
