/****** Object:  StoredProcedure [dbo].[GetCancellationDetails_rpt]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetCancellationDetails_rpt]
GO
/****** Object:  StoredProcedure [dbo].[GetCancellationDetails_rpt]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create   PROCEDURE [dbo].[GetCancellationDetails_rpt]
	@FromDate DATETIME = NULL,
	@ToDate DATETIME = NULL
AS

BEGIN

	SET NOCOUNT ON; 
	DECLARE @ApplyBonusTo VARCHAR(10),@ApplySplitTo VARCHAR(10),@DisplayAs VARCHAR(10),@DisplaySplit VARCHAR(10)
	DECLARE @QuantityToBeAdded VARCHAR(50) 
	SELECT @ApplyBonusTo=ApplyBonusTo,@ApplySplitTo=ApplySplitTo,@DisplayAs=DisplayAs,@DisplaySplit=DisplaySplit FROM BonusSplitPolicy
	

	DECLARE @APPLICABLE_DATE VARCHAR(100)
    DECLARE @PERF_OPTION_CANCELLATION VARCHAR(20)

    SELECT @APPLICABLE_DATE = CompanyParameters.PERF_OPT_CAN_TREAT_APP_DT, @PERF_OPTION_CANCELLATION=CompanyParameters.PERF_OPT_CAN_TREAT_ON FROM CompanyParameters
	

	IF (@ApplyBonusTo='A' AND @ApplySplitTo='A')
		BEGIN
			SET @QuantityToBeAdded='gl.BonusSplitCancelledQuantity'
		END
	ELSE IF (@ApplyBonusTo='V' AND @ApplySplitTo='A')
		BEGIN
			SET @QuantityToBeAdded='gl.SplitCancelledQuantity'
		END
	ELSE 
		BEGIN
			SET @QuantityToBeAdded='gl.CancelledQuantity'
		END
 
	IF (@DisplayAs='S' AND @DisplaySplit='C')
		BEGIN 
		
			EXEC('SELECT SUM('+@QuantityToBeAdded+') AS Expr1 ,
			    gl.GrantOptionId, GR.GrantDate, MAX(gl.VestingDate) as VestingDate, 
				gl.FinalVestingDate,MAX(gl.FinalExpirayDate) as FinalExpirayDate, 
				MAX(gl.ExpirayDate) as ExpirayDate, cancelled.CancelledDate as CancelledDate,
				Expr2 = CASE WHEN Max(emp.dateoftermination) IS NULL THEN gl.cancellationreason ELSE RFT.reason END,
				emp.EmployeeId,MAX(emp.EmployeeName) as EmployeeName,MAX(emp.DateOfTermination) as DateOfTermination, 
				MAX(sch.SchemeTitle) as SchemeTitle,go.GrantRegistrationId,MAX(sch.OptionRatioDivisor) as OptionRatioDivisor, 
				MAX(sch.OptionRatioMultiplier) as OptionRatioMultiplier,''OS'' AS Parent, Cancelled.GrantLegSerialNumber,Cancelled.CancelledQuantity AS CancelledQuantity,  
				CancellationReason =  
				CASE WHEN cancelledtrans.cancellationreason =''1'' THEN ''Death''
				WHEN  cancelledtrans.cancellationreason =''2'' THEN ''Resignation''   
				WHEN  cancelledtrans.cancellationreason =''3'' THEN ''Retirement''    
				WHEN cancelledtrans.cancellationreason =''4'' THEN ''Transfer''    
				WHEN cancelledtrans.cancellationreason =''5'' THEN ''Termination''
				WHEN cancelledtrans.cancellationreason =''6'' then ''Others''    
				WHEN cancelledtrans.cancellationreason =''Employee has been separated and there are no pending options available to him/her'' THEN rft.reason 
				ELSE  cancelledtrans.cancellationreason END,
				[Status]=CASE WHEN Max(emp.dateoftermination) IS NULL OR CONVERT(DATE,emp.LWD) < CONVERT(DATE, Max(emp.dateoftermination)) THEN ''Live'' WHEN (CONVERT(DATE,Max(emp.dateoftermination))<=CONVERT(DATE,'''+@ToDate+''')) THEN ''Separated''  ELSE ''Live''  END,
				VestedUnVested= CASE 
				  WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''UNVESTED_CANCELLED'')) 
						THEN ''UnVested''
							
				   WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''VESTED_CANCELLED''))
						THEN ''Vested''						

                   WHEN (cancelled.CancelledDate<FinalVestingDate)
						THEN ''UnVested''							
				        ELSE ''Vested''
			       END
				,OptionsCancelled=CONVERT(DECIMAL, (cancelled.cancelledquantity*(Max(sch.optionratiodivisor))/ Max(sch.optionratiomultiplier)))
				,0 AS Flag,''Original'' AS Note,
				PANnumber,
				getdate() as RowInsrtDttm,
				getdate() as RowUpdtDttm
				FROM  GrantLeg AS gl INNER JOIN  
				GrantOptions AS go ON go.GrantOptionId = gl.GrantOptionId INNER JOIN  
				EmployeeMaster AS emp ON go.EmployeeId = emp.EmployeeID INNER JOIN  
				Scheme AS sch ON go.SchemeId = sch.SchemeId INNER JOIN  
				GrantRegistration AS GR ON GR.GrantRegistrationId = go.GrantRegistrationId INNER JOIN  
				Cancelled ON gl.ID = Cancelled.GrantLegSerialNumber INNER JOIN  
				CancelledTrans ON Cancelled.CancelledTransID = CancelledTrans.CancelledTransID LEFT OUTER JOIN  
				ReasonForTermination AS RFT ON RFT.ID = emp.ReasonForTermination  
				WHERE 
				--CONVERT(DATE, cancelled.CancelledDate) >= CONVERT(DATE,'''+@FromDate+''')  
				--AND CONVERT(DATE, cancelled.CancelledDate) <= CONVERT(DATE,'''+@ToDate+''') 
				--AND 
				Cancelled.CancelledQuantity > 0 
				AND gl.parent IN (''N'',''S'') and IsOriginal=''Y''  
				GROUP BY sch.SchemeId,go.GrantRegistrationId,emp.EmployeeId, RFT.Reason, GR.GrantDate ,
				gl.GrantOptionId,gl.FinalVestingDate,gl.CancellationDate, gl.CancellationReason,gl.VestingType,gl.IsPerfBased, Cancelled.CancelledQuantity, 
				CancelledTrans.CancellationReason,Cancelled.GrantLegSerialNumber,cancelled.CancelledDate,Cancelled.CancellationType,emp.LWD,
				PANnumber
				
				UNION ALL
				 
				SELECT '+@QuantityToBeAdded+' AS Expr1 ,	
			    gl.GrantOptionId, GR.GrantDate, MAX(gl.VestingDate) as VestingDate, 
				gl.FinalVestingDate,MAX(gl.FinalExpirayDate) as FinalExpirayDate, 
				MAX(gl.ExpirayDate) as ExpirayDate, cancelled.CancelledDate as CancelledDate,
				Expr2 = CASE WHEN Max(emp.dateoftermination) IS NULL THEN gl.cancellationreason ELSE RFT.reason END,
				emp.EmployeeId,MAX(emp.EmployeeName) as EmployeeName,MAX(emp.DateOfTermination) as DateOfTermination, 
				MAX(sch.SchemeTitle) as SchemeTitle,go.GrantRegistrationId,MAX(sch.OptionRatioDivisor) as OptionRatioDivisor, 
				MAX(sch.OptionRatioMultiplier) as OptionRatioMultiplier,''BS'' as Parent, Cancelled.GrantLegSerialNumber,Cancelled.CancelledQuantity AS CancelledQuantity, 
				CancellationReason =  
				CASE WHEN cancelledtrans.cancellationreason =''1'' THEN ''Death''   
				WHEN  cancelledtrans.cancellationreason =''2'' THEN ''Resignation''   
				WHEN  cancelledtrans.cancellationreason =''3'' THEN ''Retirement''    
				WHEN cancelledtrans.cancellationreason =''4'' THEN ''Transfer''    
				WHEN cancelledtrans.cancellationreason =''5'' THEN ''Termination'' 
				WHEN cancelledtrans.cancellationreason =''6'' then ''Others''   
				ELSE ISNULL(rft.reason, cancelledtrans.cancellationreason) 
				END,   
				[Status]=CASE WHEN Max(emp.dateoftermination) IS NULL OR CONVERT(DATE,emp.LWD) < CONVERT(DATE, Max(emp.dateoftermination)) THEN ''Live'' WHEN (CONVERT(DATE,Max(emp.dateoftermination))<=CONVERT(DATE,'''+@ToDate+''')) THEN ''Separated''  ELSE ''Live'' END,
				VestedUnVested= CASE 
				  WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''UNVESTED_CANCELLED'')) 
						THEN ''UnVested''
							
				   WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''VESTED_CANCELLED''))
						THEN ''Vested''						

                   WHEN (cancelled.CancelledDate<FinalVestingDate)
						THEN ''UnVested''							
				        ELSE ''Vested''
			       END
				,OptionsCancelled=CONVERT(DECIMAL, (cancelled.cancelledquantity*(Max(sch.optionratiodivisor))/ Max(sch.optionratiomultiplier)))
				,0 AS Flag,''Bonus'' AS Note,
				PANnumber,
				getdate() as RowInsrtDttm,
				getdate() as RowUpdtDttm
				FROM GrantLeg gl 
				INNER JOIN GrantOptions go 
				ON go.GrantOptionId = gl.GrantOptionId 
				INNER JOIN EmployeeMaster emp on 
				go.EmployeeId = emp.EmployeeId 
				INNER JOIN Scheme sch 
				on go.SchemeId = sch.SchemeId 
				INNER JOIN GrantRegistration GR 
				on GR.GrantRegistrationId = go.GrantRegistrationId 
				INNER JOIN  
				Cancelled ON gl.ID = Cancelled.GrantLegSerialNumber INNER JOIN  
				CancelledTrans ON Cancelled.CancelledTransID = CancelledTrans.CancelledTransID 
				LEFT OUTER JOIN ReasonForTermination RFT 
				on RFT.ID = emp.ReasonForTermination 
				WHERE 
				--CONVERT(DATE, cancelled.CancelledDate) >= CONVERT(DATE,'''+@FromDate+''') 
				--AND CONVERT(DATE, cancelled.CancelledDate) <= CONVERT(DATE,'''+@ToDate+''') 
				--AND 
				'+@QuantityToBeAdded+' > 0 
				AND gl.parent IN (''S'',''B'') AND IsBonus=''Y'' 
				GROUP BY sch.SchemeId,go.GrantRegistrationId,emp.EmployeeId, RFT.Reason, GR.GrantDate ,
				gl.GrantOptionId,gl.FinalVestingDate,gl.CancellationDate, gl.CancellationReason,'+@QuantityToBeAdded+', Cancelled.CancelledQuantity,
				CancelledTrans.CancellationReason,gl.VestingType,gl.IsPerfBased,Cancelled.GrantLegSerialNumber,cancelled.CancelledDate, Cancelled.CancellationType,emp.LWD,PANnumber
				ORDER BY SchemeTitle,emp.EmployeeID ASC') 
		END

	ELSE IF (@DisplayAs='C' AND @DisplaySplit='S')
		BEGIN
		
			EXEC('SELECT SUM('+@QuantityToBeAdded+') AS Expr1 ,  
			    gl.grantoptionid, GR.grantdate,MAX(gl.vestingdate)AS VestingDate,gl.finalvestingdate,MAX(gl.finalexpiraydate) AS FinalExpirayDate,  
				MAX(gl.expiraydate)AS ExpirayDate, cancelled.CancelledDate  AS CancelledDate,   
				Expr2 = CASE WHEN MAX(emp.dateoftermination) IS NULL THEN gl.cancellationreason ELSE RFT.reason  END,  
				emp.employeeid, MAX(emp.employeename) AS EmployeeName,MAX(emp.dateoftermination) AS DateOfTermination,MAX(sch.schemetitle)AS SchemeTitle,   
				go.grantregistrationid, MAX(sch.optionratiodivisor) AS OptionRatioDivisor, MAX(sch.optionratiomultiplier)AS OptionRatioMultiplier,   
				''OB'' AS Parent,gl.vestingperiodid, cancelled.grantlegserialnumber, cancelled.cancelledquantity AS CancelledQuantity,  
				CancellationReason = CASE   
					  WHEN cancelledtrans.cancellationreason = ''1'' THEN ''Death''   
					  WHEN cancelledtrans.cancellationreason = ''2'' THEN ''Resignation''  
					  WHEN cancelledtrans.cancellationreason = ''3'' THEN ''Retirement''  
					  WHEN cancelledtrans.cancellationreason = ''4'' THEN ''Transfer''  
					  WHEN cancelledtrans.cancellationreason = ''5'' THEN ''Termination''
					  WHEN cancelledtrans.cancellationreason =''6'' then ''Others''   
					  WHEN cancelledtrans.cancellationreason = ''Employee has been separated and there are no pending options available to him/her'' THEN rft.reason  
					  ELSE  cancelledtrans.cancellationreason END ,
				[Status]=CASE WHEN Max(emp.dateoftermination) IS NULL OR CONVERT(DATE,emp.LWD) < CONVERT(DATE, Max(emp.dateoftermination)) THEN ''Live'' WHEN (CONVERT(DATE,Max(emp.dateoftermination))<=CONVERT(DATE,'''+@ToDate+''')) THEN ''Separated''  ELSE ''Live'' END,
				VestedUnVested= CASE 
				  WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''UNVESTED_CANCELLED'')) 
						THEN ''UnVested''
							
				   WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''VESTED_CANCELLED''))
						THEN ''Vested''						

                   WHEN (cancelled.CancelledDate<FinalVestingDate)
						THEN ''UnVested''							
				        ELSE ''Vested''
			       END
				,OptionsCancelled=CONVERT(DECIMAL, (cancelled.cancelledquantity*(Max(sch.optionratiodivisor))/ Max(sch.optionratiomultiplier)))
				,0 AS Flag,''Original'' AS Note,
				PANnumber,
				getdate() as RowInsrtDttm,
				getdate() as RowUpdtDttm
				FROM grantleg gl INNER JOIN grantoptions go ON go.grantoptionid = gl.grantoptionid  
				INNER JOIN employeemaster emp ON go.employeeid = emp.employeeid  
				INNER JOIN scheme sch ON go.schemeid = sch.schemeid  
				INNER JOIN grantregistration GR ON GR.grantregistrationid = go.grantregistrationid  
				INNER JOIN cancelled ON gl.id = cancelled.grantlegserialnumber  
				INNER JOIN cancelledtrans  ON cancelled.cancelledtransid = cancelledtrans.cancelledtransid  
				LEFT OUTER JOIN reasonfortermination RFT ON RFT.id = emp.reasonfortermination  
				WHERE  
				--CONVERT(DATE, cancelled.CancelledDate) >= CONVERT(DATE,'''+@FromDate+''')  
				--AND CONVERT(DATE, cancelled.CancelledDate) <= CONVERT(DATE,'''+@ToDate+''') 
				AND gl.parent IN (''N'',''B'') AND IsOriginal = ''Y''    
				GROUP  BY gl.vestingperiodid, sch.schemeid, go.grantregistrationid,emp.employeeid,RFT.reason, GR.grantdate, gl.grantoptionid,   
				gl.finalvestingdate,gl.cancellationdate, cancelled.cancelledquantity, cancelled.grantlegserialnumber, cancelledtrans.cancellationreason,gl.VestingType,gl.IsPerfBased,gl.cancellationreason,cancelled.CancelledDate, Cancelled.CancellationType,emp.LWD,PANnumber   

				UNION ALL   

		        SELECT '+@QuantityToBeAdded+' AS Expr1 ,				
				gl.grantoptionid, GR.grantdate, MAX(gl.vestingdate)AS VestingDate, gl.finalvestingdate, MAX(gl.finalexpiraydate) AS FinalExpirayDate,   
				MAX(gl.expiraydate)AS ExpirayDate,cancelled.CancelledDate AS CancelledDate, RFT.reason AS Expr2, emp.employeeid, MAX(emp.employeename)AS EmployeeName,   
				MAX(emp.dateoftermination) AS DateOfTermination, MAX(sch.schemetitle) AS SchemeTitle,go.grantregistrationid,   
				MAX(sch.optionratiodivisor)AS OptionRatioDivisor,MAX(sch.optionratiomultiplier) AS OptionRatioMultiplier, ''SB'' AS Parent,   
				gl.vestingperiodid,cancelled.grantlegserialnumber,cancelled.cancelledquantity AS CancelledQuantity,   
				CancellationReason = CASE   
					  WHEN cancelledtrans.cancellationreason = ''1'' THEN ''Death''   
					  WHEN cancelledtrans.cancellationreason = ''2'' THEN ''Resignation''   
					  WHEN cancelledtrans.cancellationreason = ''3'' THEN ''Retirement''   
					  WHEN cancelledtrans.cancellationreason = ''4'' THEN ''Transfer''   
					  WHEN cancelledtrans.cancellationreason = ''5'' THEN ''Termination''
					  WHEN cancelledtrans.cancellationreason =''6'' then ''Others''    
					  WHEN cancelledtrans.cancellationreason = ''Employee has been separated and there are no pending options available to him/her'' THEN rft.reason  
					  ELSE  cancelledtrans.cancellationreason END,
				[Status]=CASE WHEN Max(emp.dateoftermination) IS NULL OR CONVERT(DATE,emp.LWD) < CONVERT(DATE, Max(emp.dateoftermination)) THEN ''Live'' WHEN (CONVERT(DATE,Max(emp.dateoftermination))<=CONVERT(DATE,'''+@ToDate+''')) THEN ''Separated''  ELSE ''Live'' END,
				VestedUnVested= CASE 
				  WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''UNVESTED_CANCELLED'')) 
						THEN ''UnVested''
							
				   WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''VESTED_CANCELLED''))
						THEN ''Vested''						

                   WHEN (cancelled.CancelledDate<FinalVestingDate)
						THEN ''UnVested''							
				        ELSE ''Vested''
			       END
				,OptionsCancelled= CONVERT(DECIMAL,(cancelled.cancelledquantity*(Max(sch.optionratiodivisor))/ Max(sch.optionratiomultiplier)))
				,0 AS Flag,''Split'' AS Note,
				PANnumber,
				getdate() as RowInsrtDttm,
				getdate() as RowUpdtDttm
				FROM   grantleg gl INNER JOIN grantoptions go  ON go.grantoptionid = gl.grantoptionid    
				INNER JOIN employeemaster emp ON go.employeeid = emp.employeeid    
				INNER JOIN scheme sch ON go.schemeid = sch.schemeid    
				INNER JOIN grantregistration GR  ON GR.grantregistrationid = go.grantregistrationid     
				INNER JOIN cancelled  ON gl.id = cancelled.grantlegserialnumber     
				INNER JOIN cancelledtrans  ON cancelled.cancelledtransid = cancelledtrans.cancelledtransid     
				LEFT OUTER JOIN reasonfortermination RFT  ON RFT.id = emp.reasonfortermination     
				WHERE  
				--CONVERT(DATE, cancelled.CancelledDate) >= CONVERT(DATE,'''+@FromDate+''') 
				--AND CONVERT(DATE, cancelled.CancelledDate) <= CONVERT(DATE,'''+@ToDate+''') 
				AND '+@QuantityToBeAdded+' > 0 AND gl.parent IN (''S'',''B'')  AND IsSplit  = ''Y''    
				GROUP  BY gl.vestingperiodid,sch.schemeid, go.grantregistrationid, emp.employeeid, RFT.reason,     
				GR.grantdate,gl.grantoptionid, gl.finalvestingdate,gl.cancellationdate, gl.cancellationreason,     
				gl.VestingType,gl.IsPerfBased,cancelled.grantlegserialnumber, cancelled.cancelledquantity, cancelledtrans.cancellationreason, gl.bonussplitcancelledquantity,cancelled.CancelledDate, Cancelled.CancellationType,emp.LWD,PANnumber
				ORDER  BY schemetitle, emp.employeeid ASC')
		END

	ELSE IF (@DisplayAs='S' AND @DisplaySplit='S')
		BEGIN
		
			SET @QuantityToBeAdded = replace(@QuantityToBeAdded,'gl','cancelled')
			EXEC('SELECT '+@QuantityToBeAdded+' AS Expr1 ,
			    gl.grantoptionid,GR.grantdate,gl.vestingdate AS VestingDate,gl.finalvestingdate, gl.finalexpiraydate AS FinalExpirayDate, 
				gl.expiraydate AS ExpirayDate,cancelled.CancelledDate AS CancelledDate, 
				Expr2 = CASE 
						WHEN MAX(emp.dateoftermination) IS NULL THEN 
						gl.cancellationreason 
						ELSE RFT.reason 
					  END, 
				emp.employeeid,MAX(emp.employeename) AS EmployeeName, MAX(emp.dateoftermination) AS DateOfTermination, 
				MAX(sch.schemetitle)AS SchemeTitle,go.grantregistrationid,MAX(sch.optionratiodivisor) AS OptionRatioDivisor, 
				MAX(sch.optionratiomultiplier) AS OptionRatioMultiplier, gl.counter, MAX(gl.parent) AS Parent, 
				cancelled.grantlegserialnumber,cancelled.cancelledquantity AS CancelledQuantity, 
				CancellationReason = CASE 
						WHEN cancelledtrans.cancellationreason = ''1'' THEN ''Death'' 
						WHEN cancelledtrans.cancellationreason = ''2'' THEN ''Resignation'' 
						WHEN cancelledtrans.cancellationreason = ''3'' THEN ''Retirement'' 
						WHEN cancelledtrans.cancellationreason = ''4'' THEN ''Transfer'' 
						WHEN cancelledtrans.cancellationreason = ''5'' THEN ''Termination'' 
						WHEN cancelledtrans.cancellationreason =''6'' then ''Others'' 
						WHEN cancelledtrans.cancellationreason = ''Employee has been separated and there are no pending options available to him/her'' THEN rft.reason 
						ELSE  cancelledtrans.cancellationreason END,
				[Status]=CASE WHEN Max(emp.dateoftermination) IS NULL OR CONVERT(DATE,emp.LWD) < CONVERT(DATE, Max(emp.dateoftermination)) THEN ''Live'' WHEN (CONVERT(DATE,Max(emp.dateoftermination))<=CONVERT(DATE,'''+@ToDate+''')) THEN ''Separated''  ELSE ''Live'' END,
				VestedUnVested= CASE
				  WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''UNVESTED_CANCELLED'')) 
						THEN ''UnVested''
							
				   WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''VESTED_CANCELLED''))
						THEN ''Vested''						

                   WHEN (cancelled.CancelledDate<FinalVestingDate)
						THEN ''UnVested''							
				        ELSE ''Vested''
			       END
				,OptionsCancelled=CONVERT(DECIMAL, (cancelled.cancelledquantity*(Max(sch.optionratiodivisor))/ Max(sch.optionratiomultiplier)))
				,0 AS Flag
				,Note=CASE 
				WHEN MAX(gl.parent)=''N'' THEN ''Original''
				WHEN MAX(gl.parent)=''B'' THEN ''Bonus''
				WHEN MAX(gl.parent)=''S'' THEN ''Split'' END,
				PANnumber,
				getdate() as RowInsrtDttm,
				getdate() as RowUpdtDttm
				FROM  grantleg gl INNER JOIN grantoptions go ON go.grantoptionid = gl.grantoptionid 
				INNER JOIN employeemaster emp ON go.employeeid = emp.employeeid 
				INNER JOIN scheme sch ON go.schemeid = sch.schemeid 
				INNER JOIN grantregistration GR ON GR.grantregistrationid = go.grantregistrationid 
				INNER JOIN cancelled ON gl.id = cancelled.grantlegserialnumber 
				INNER JOIN cancelledtrans ON cancelled.cancelledtransid = cancelledtrans.cancelledtransid 
				LEFT OUTER JOIN reasonfortermination RFT ON RFT.id = emp.reasonfortermination 
				WHERE 
				--CONVERT(DATE, cancelled.CancelledDate) >= CONVERT(DATE,'''+@FromDate+''')  AND CONVERT(DATE, cancelled.CancelledDate) <= CONVERT(DATE,'''+@ToDate+''') 
				--AND 
				'+@QuantityToBeAdded+' > 0  
				GROUP  BY sch.schemeid, go.grantregistrationid, emp.employeeid, RFT.reason, GR.grantdate, gl.grantoptionid, gl.counter, gl.finalvestingdate, 
				gl.cancellationdate,gl.cancellationreason,gl.VestingType,gl.IsPerfBased, gl.vestingdate, gl.finalexpiraydate,gl.expiraydate, cancelled.grantlegserialnumber, 
				cancelled.cancelledquantity, cancelledtrans.cancellationreason, gl.bonussplitcancelledquantity , '+@QuantityToBeAdded+',cancelled.CancelledDate, Cancelled.CancellationType,emp.LWD,PANnumber
				ORDER  BY sch.schemeid, emp.employeeid ASC')
		END 
	ELSE 
		BEGIN
		
			SET @QuantityToBeAdded = replace(@QuantityToBeAdded,'gl','cancelled')
			EXEC('SELECT SUM('+@QuantityToBeAdded+') AS Expr1,
			    gl.GrantOptionId, GR.GrantDate, MAX(gl.VestingDate) AS VestingDate, gl.FinalVestingDate,  
				MAX(gl.FinalExpirayDate) AS FinalExpirayDate, MAX(gl.ExpirayDate) AS ExpirayDate, cancelled.CancelledDate AS CancelledDate, 
				CASE  WHEN MAX(emp.dateoftermination)  
				IS NULL THEN gl.cancellationreason ELSE RFT.reason END AS Expr2,
				emp.EmployeeID, MAX(emp.EmployeeName) AS EmployeeName,  
				MAX(emp.DateOfTermination) AS DateOfTermination, MAX(sch.SchemeTitle) AS SchemeTitle, go.GrantRegistrationId,  MAX(sch.OptionRatioDivisor) 
				AS OptionRatioDivisor, MAX(sch.OptionRatioMultiplier) AS OptionRatioMultiplier, Cancelled.GrantLegSerialNumber,Cancelled.CancelledQuantity AS CancelledQuantity, 
				CancellationReason = CASE 
					WHEN cancelledtrans.cancellationreason =''1'' then ''Death''   
					WHEN  cancelledtrans.cancellationreason =''2'' then ''Resignation''   
					WHEN  cancelledtrans.cancellationreason =''3'' then ''Retirement''   
					WHEN cancelledtrans.cancellationreason =''4'' then ''Transfer''   
					WHEN cancelledtrans.cancellationreason =''5'' then ''Termination'' 
					WHEN cancelledtrans.cancellationreason =''6'' then ''Others''  
					WHEN cancelledtrans.cancellationreason = ''Employee has been separated and there are no pending options available to him/her'' THEN rft.reason  
					ELSE cancelledtrans.cancellationreason END ,
				[Status]=CASE WHEN Max(emp.dateoftermination) IS NULL OR CONVERT(DATE,emp.LWD) < CONVERT(DATE, Max(emp.dateoftermination)) THEN ''Live'' WHEN (CONVERT(DATE,Max(emp.dateoftermination))<=CONVERT(DATE,'''+@ToDate+''')) THEN ''Separated''  ELSE ''Live'' END,
				VestedUnVested= CASE 
				  WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''UNVESTED_CANCELLED'')) 
						THEN ''UnVested''
							
				   WHEN ((gl.IsPerfBased = ''1'') AND (UPPER(gl.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''VESTED_CANCELLED''))
						THEN ''Vested''						

                   WHEN (cancelled.CancelledDate<FinalVestingDate)
						THEN ''UnVested''							
				        ELSE ''Vested''
			       END
				,OptionsCancelled=CONVERT(DECIMAL, (cancelled.cancelledquantity*(Max(sch.optionratiodivisor))/ Max(sch.optionratiomultiplier)))
				,0 AS Flag,''-'' AS Note,
				PANnumber,
				getdate() as RowInsrtDttm,
				getdate() as RowUpdtDttm
				FROM GrantLeg AS gl INNER JOIN  
				GrantOptions AS go ON go.GrantOptionId = gl.GrantOptionId INNER JOIN  
				EmployeeMaster AS emp ON go.EmployeeId = emp.EmployeeID INNER JOIN  
				Scheme AS sch ON go.SchemeId = sch.SchemeId INNER JOIN  
				GrantRegistration AS GR ON GR.GrantRegistrationId = go.GrantRegistrationId INNER JOIN  
				Cancelled ON gl.ID = Cancelled.GrantLegSerialNumber INNER JOIN  
				CancelledTrans ON Cancelled.CancelledTransID = CancelledTrans.CancelledTransID LEFT OUTER JOIN  
				ReasonForTermination AS RFT ON RFT.ID = emp.ReasonForTermination  
				WHERE 
				--CONVERT(DATE, cancelled.CancelledDate) >= CONVERT(DATE,'''+@FromDate+''') AND CONVERT(DATE, cancelled.CancelledDate) <= CONVERT(DATE,'''+@ToDate+''')
				--AND
				('+@QuantityToBeAdded+' > 0)  
				GROUP BY sch.SchemeId, go.GrantRegistrationId, emp.EmployeeID, RFT.Reason, GR.GrantDate, gl.GrantOptionId, gl.FinalVestingDate, gl.CancellationDate, 
				gl.CancellationReason,gl.VestingType,gl.IsPerfBased,Cancelled.GrantLegSerialNumber, Cancelled.CancelledQuantity, CancelledTrans.CancellationReason,cancelled.CancelledDate, Cancelled.CancellationType,emp.LWD,PANnumber
				ORDER BY sch.SchemeId, emp.EmployeeID ')
		END  
END
GO
