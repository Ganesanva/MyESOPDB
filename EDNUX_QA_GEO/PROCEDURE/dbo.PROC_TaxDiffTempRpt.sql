/****** Object:  StoredProcedure [dbo].[PROC_TaxDiffTempRpt]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_TaxDiffTempRpt]
GO
/****** Object:  StoredProcedure [dbo].[PROC_TaxDiffTempRpt]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_TaxDiffTempRpt] 
@NoOfDays VARCHAR(10)
AS
DECLARE @VESTING_DATE DATETIME=(SELECT CONVERT(DATE, DATEADD(DAY,- (CONVERT(INT,@NoOfDays)),Convert(DATE ,GETDATE()))))

DECLARE @TO_DATE DATETIME = (SELECT  REPLACE(CONVERT(VARCHAR(10), GETDATE(),102),'.','-'))

 
CREATE TABLE #CRExerciseReport
(
EmployeeID VARCHAR(20), 			INSTRUMENT_NAME NVARCHAR(500),		CountryName VARCHAR(50),		ExercisePrice INT,
CurrencyName VARCHAR(50),			SharesArised INT, 					SARExerciseAmount INT,			ExercisedId INT,
EmployeeName VARCHAR(75),			GrantRegistrationId VARCHAR(20),	grantoptionid VARCHAR(100), 	GrantedOptions INT,
GrantDate DATETIME,
ExercisedQuantity INT,				SharesAlloted INT,					ExercisedDate DATETIME,			ExercisedPrice INT,
SchemeTitle VARCHAR(50),			OptionRatioMultiplier INT,			schemeid VARCHAR(50),			OptionRatioDivisor INT,
SharesIssuedDate DATETIME,			DateOfPayment DATETIME,				Parent VARCHAR(8),				VestingDate DATETIME,
GrantLegId INT,						FBTValue INT,						Cash VARCHAR(50),				SAR_PerqValue INT, 
FaceValue INT,						PerqstValue VARCHAR(30),			PerqstPayable INT,				FMVPrice INT,
FBTdays INT,						TravelDays INT, 					PaymentMode VARCHAR(20), 		PerqTaxRate INT, 
ExerciseNo INT, 					grantlegserialnumber INT, 			Exercise_Amount INT, 			[Date of Payment] DATETIME, 
[Account number] VARCHAR(20), 		ConfStatus CHAR(1), 				dateofjoining DATETIME, 		dateoftermination DATETIME, 
department VARCHAR(200), 			employeedesignation VARCHAR(200), 	Entity VARCHAR(200),			Grade VARCHAR(200), Insider char(1),[ReasonForTermination] VARCHAR(50), 
SBU VARCHAR(200), 					residentialstatus VARCHAR(50), 		itcircle_wardnumber VARCHAR(15), depositoryname VARCHAR(200), 
depositoryparticipatoryname VARCHAR(200), confirmationdate DATETIME,    nameasperdprecord VARCHAR(50),   employeeaddress VARCHAR(500),         
employeeemail VARCHAR(500), 		employeephone VARCHAR(20), 			pan_girnumber VARCHAR(50), 		 dematactype VARCHAR(50),	                         
dpidnumber VARCHAR(50),             clientidnumber VARCHAR(50),         location VARCHAR(200),        	 LotNumber VARCHAR(20),	
CurrencyAlias VARCHAR(50),          MIT_ID INT, 						ExercisableQuantity BIGINT	
)                   
                            
                            
INSERT INTO #CRExerciseReport 
(
EmployeeID,INSTRUMENT_NAME,CountryName,ExercisePrice,CurrencyName,SharesArised,SARExerciseAmount,ExercisedId,
EmployeeName,GrantRegistrationId,grantoptionid,GrantedOptions,GrantDate,ExercisedQuantity,SharesAlloted,ExercisedDate,ExercisedPrice,
SchemeTitle,OptionRatioMultiplier,schemeid,OptionRatioDivisor,SharesIssuedDate,DateOfPayment,Parent,VestingDate,
GrantLegId,FBTValue,Cash,SAR_PerqValue,FaceValue,PerqstValue,PerqstPayable,FMVPrice,FBTdays,TravelDays,PaymentMode,PerqTaxRate, 
ExerciseNo,grantlegserialnumber,Exercise_Amount,[Date of Payment],[Account number],ConfStatus,dateofjoining,dateoftermination, 
department,employeedesignation,Entity,Grade,Insider,[ReasonForTermination],SBU ,residentialstatus,itcircle_wardnumber,depositoryname, 
depositoryparticipatoryname,confirmationdate,nameasperdprecord,employeeaddress,employeeemail,employeephone,pan_girnumber,dematactype,	                         
dpidnumber,clientidnumber,location,LotNumber,CurrencyAlias,MIT_ID,ExercisableQuantity 
)
	
EXEC PROC_CRExerciseReport_Template '1900-01-01',@TO_DATE,'---All Employees---'



CREATE TABLE #Shexcercise
(	
	EmployeeID VARCHAR(50),
	SchemeTitle VARCHAR(100),
	GrantDate DATETIME,	
   	ExercisePrice DECIMAL(18,4),
	CurrencyName VARCHAR(50),
	GrantedOptions DECIMAL(18,4),
	VestingDate DATETIME,
	grantlegserialnumber INT,
	ExerciseNo INT,
	ExercisID INT			
)

INSERT INTO #Shexcercise(ExercisID,EmployeeID,SchemeTitle,GrantDate,ExercisePrice,CurrencyName,GrantedOptions,VestingDate,grantlegserialnumber,ExerciseNo)

SELECT ExercisedId,EmployeeID,SchemeTitle,GrantDate,ExercisePrice,CurrencyName,GrantedOptions,VestingDate,grantlegserialnumber,ExerciseNo
FROM #CRExerciseReport WHERE VestingDate=@VESTING_DATE 
--AND ExerciseNo=7

UNION 
SELECT	ex.ExerciseId,emp.employeeid AS EmployeeID,MAX(sch.schemetitle)  AS SchemeTitle,MAX(gr.grantdate) AS GrantDate,GR.ExercisePrice AS[ExercisePrice],
CUM.CurrencyName AS [CurrencyName],[GO].GrantedOptions,gl.finalvestingdate  AS VestingDate,ex.GrantLegSerialNumber,ex.ExerciseNo		   	
FROM employeemaster emp INNER JOIN grantoptions [GO] ON emp.employeeid = [GO].employeeid 		  	
INNER JOIN grantregistration gr ON gr.grantregistrationid = [GO].grantregistrationid			
INNER JOIN grantleg gl ON [GO].grantoptionid = gl.grantoptionid 					 
INNER JOIN ShExercisedOptions ex ON ex.GrantLegSerialNumber = gl.id 			
INNER JOIN scheme sch ON [GO].schemeid = sch.schemeid			
LEFT OUTER JOIN paymentmaster PM ON Pm.paymentmode = Ex.paymentmode			
INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON sch.MIT_ID=CIM.MIT_ID						
INNER JOIN CurrencyMaster AS CUM ON CIM.CurrencyID=CUM.CurrencyID			
WHERE gl.finalvestingdate=@VESTING_DATE 
--AND ex.ExerciseNo=7
GROUP BY emp.employeeid,GR.ExercisePrice,CUM.CurrencyName,[GO].GrantedOptions,gl.finalvestingdate,ex.ExerciseNo,ex.GrantLegSerialNumber,ex.ExerciseId			 


SELECT * from #Shexcercise


DECLARE @ColumnName AS NVARCHAR(max)
DECLARE @query AS NVARCHAR(max)
SELECT 
	@ColumnName=isnull(@ColumnName + ',','') + quotename(Tax_Title) 
FROM 
	(SELECT DISTINCT Tax_Title FROM EXERCISE_TAXRATE_DETAILS ex
	inner join #Shexcercise Shex on Shex.ExercisID = ex.EXERCISE_NO and Shex.grantlegserialnumber=ex.GRANTLEGSERIALNO        
     ) AS TaxHeadings                                        
                        
	
	
	
	
	  
	      
set @query = 'SELECT EmployeeID as [EmpNo],CountryName as [Country],SchemeTitle as [Schemename],convert(varchar(20),GrantDate,106) AS GrantDate,CurrencyName as [Currency],ExercisePrice,GrantedOptions,convert(varchar(20),VestingDate,106) AS VestingDate,FMVVALUE as ActualFMVconsidered,PERQVALUE as ProcessedPerquisitevalue,  ' + @ColumnName + ',TotalTaxorSSEmployeeobligation,TaxorSScollected,RefundorAdditionalliability,null as Remarks,null as EDUploadStatus,null as EDRemarks,ExercisID from 
             (
  select b.EmployeeID,b.GrantedOptions,b.CountryName,b.TAX_AMOUNT,b.Tax_Title,b.SchemeTitle,b.GrantDate,b.CurrencyName,b.ExercisePrice,b.VestingDate,a.FMVVALUE,a.PERQVALUE,a.TotalTaxorSSEmployeeobligation,a.TaxorSScollected,a.RefundorAdditionalliability,a.ExercisID from
                         ((select
                         t.EmployeeID
                        ,t.GrantedOptions
                        ,t.SchemeTitle
                        ,t.GrantDate
                        ,t.CurrencyName
                        ,t.ExercisePrice                        
                        ,t.VestingDate
                        ,t.ExercisID
                        --,p.GRANTLEGSERIALNO
                        ,(CASE WHEN p.FMVVALUE!=0 OR p.FMVVALUE!=NULL THEN  p.FMVVALUE ELSE p.TENTATIVEFMVVALUE END) AS FMVVALUE
                        ,(CASE WHEN p.PERQVALUE!=0 OR p.PERQVALUE!=NULL THEN  p.PERQVALUE ELSE p.TENTATIVEPERQVALUE END) AS PERQVALUE                        
                        ,sum(CASE WHEN p.TAX_AMOUNT!=0 OR p.TAX_AMOUNT!=NULL THEN  p.TAX_AMOUNT ELSE p.TENTATIVETAXAMOUNT END) TotalTaxorSSEmployeeobligation
                       	,sum(isnull(p.TAX_AMOUNT,0)) as TaxorSScollected
                       	,sum(isnull(p.TAX_AMOUNT,0)) - (sum(CASE WHEN p.TAX_AMOUNT!=0 OR p.TAX_AMOUNT!=NULL THEN  p.TAX_AMOUNT ELSE p.TENTATIVETAXAMOUNT END)) as RefundorAdditionalliability
                       	,p.COUNTRY_ID
                    from #Shexcercise t
                    inner join EXERCISE_TAXRATE_DETAILS p
                        on t.ExercisID = p.EXERCISE_NO                      
                        and t.grantlegserialnumber=p.GRANTLEGSERIALNO
                        
                        group by 
                        t.EmployeeID
                        ,t.GrantedOptions
                        ,t.SchemeTitle
                        ,t.GrantDate
                        ,t.CurrencyName
                        ,t.ExercisePrice                        
                        ,t.VestingDate
                        ,t.ExercisID
                   -----,p.GRANTLEGSERIALNO
                        ,p.FMVVALUE
                		,p.PERQVALUE
                        ,p.TENTATIVEFMVVALUE
                        ,p.TENTATIVEPERQVALUE
                        ,p.COUNTRY_ID
                        )a
                        join
                         (select
                         t.EmployeeID
                        ,t.GrantedOptions
                        ,t.SchemeTitle
                        ,t.GrantDate
                        ,t.CurrencyName
                        ,t.ExercisePrice                        
                        ,t.VestingDate
                        ,p.Tax_Title
                        ,(CASE WHEN p.TAX_AMOUNT!=0 OR p.TAX_AMOUNT!=NULL THEN  p.TAX_AMOUNT ELSE p.TENTATIVETAXAMOUNT END) as TAX_AMOUNT                        
                       	,c.CountryName
                       	,t.ExercisID 
                        --,p.GRANTLEGSERIALNO
                        ,p.COUNTRY_ID
                    from #Shexcercise t
                    inner join EXERCISE_TAXRATE_DETAILS p
                        on t.ExercisID = p.EXERCISE_NO                      
                        and t.grantlegserialnumber=p.GRANTLEGSERIALNO
                        join CountryMaster c on
                        c.ID=p.COUNTRY_ID
                        )b
                        on a.ExercisID =b.ExercisID 
                        --and a.GRANTLEGSERIALNO=b.GRANTLEGSERIALNO
                        and a.COUNTRY_ID=b.COUNTRY_ID
                        )
            ) x
            pivot 
            (
                min(TAX_AMOUNT)
                for Tax_Title in (' + @ColumnName + ')
            ) p '

execute(@query)


GO
