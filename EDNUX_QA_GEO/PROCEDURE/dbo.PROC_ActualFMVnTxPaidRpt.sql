/****** Object:  StoredProcedure [dbo].[PROC_ActualFMVnTxPaidRpt]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_ActualFMVnTxPaidRpt]
GO
/****** Object:  StoredProcedure [dbo].[PROC_ActualFMVnTxPaidRpt]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_ActualFMVnTxPaidRpt] --20
@NoOfDays VARCHAR(10)
AS
DECLARE @VESTING_DATE DATETIME=(SELECT CONVERT(DATE, DATEADD(DAY,- (CONVERT(INT,@NoOfDays)),Convert(DATE ,GETDATE()))))


DECLARE @TO_DATE DATETIME = (SELECT  REPLACE(CONVERT(VARCHAR(10), GETDATE(),102),'.','-'))

 PRINT(@VESTING_DATE)
 
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
CurrencyAlias VARCHAR(50),          MIT_ID INT,							ExercisableQuantity BIGINT
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
dpidnumber,clientidnumber,location,LotNumber,CurrencyAlias,MIT_ID ,ExercisableQuantity
)
	
EXEC PROC_CRExerciseReport_Template '1900-01-01',@TO_DATE,'---All Employees---'

-----------------------------------------------Get the data from PROC_CRExerciseReport_Template(from Exercised table) and ShExercisedOptions------------------
CREATE TABLE #Shexcercise
(	
	EmployeeID VARCHAR(50),
	EmployeeName VARCHAR(100),
	SchemeTitle VARCHAR(100),
	GrantDate DATETIME,	
	VestingDate DATETIME,
	ExercisedDate DATETIME,
	PaymentMode VARCHAR(100),
	PaymentStatus VARCHAR(100),
	GrantedOptions DECIMAL(18,4),
	VestQty DECIMAL(18,4),   	
	CurrencyName VARCHAR(50),
	ExercisePrice DECIMAL(18,4),	
	grantlegserialnumber INT,
	ExerciseNo INT	,
	ExercisableQuantity BIGINT	,
	ExercisID INT	,
)

INSERT INTO #Shexcercise(ExercisID,EmployeeID,EmployeeName,SchemeTitle,GrantDate,VestingDate,ExercisedDate,PaymentMode,PaymentStatus,GrantedOptions,VestQty,CurrencyName,ExercisePrice,grantlegserialnumber,ExerciseNo)

SELECT ExercisedId, EmployeeID,EmployeeName,SchemeTitle,GrantDate,VestingDate,ExercisedDate,PaymentMode,CASE WHEN PaymentMode IS NULL THEN 'Unpaid' ELSE 'Paid' END AS PaymentStatus,GrantedOptions,ExercisableQuantity AS VestQty,
CurrencyName,ExercisePrice,grantlegserialnumber,ExerciseNo
FROM #CRExerciseReport WHERE VestingDate=@VESTING_DATE 

UNION 
SELECT ex.ExerciseId,emp.employeeid AS EmployeeID,emp.employeename AS EmployeeName,MAX(sch.schemetitle)  AS SchemeTitle,
MAX(gr.grantdate) AS GrantDate,gl.finalvestingdate  AS VestingDate,ex.ExerciseDate AS ExercisedDate,
ex.PaymentMode,CASE WHEN ex.PaymentMode IS NULL THEN 'Unpaid' ELSE 'Paid' END AS PaymentStatus,[GO].GrantedOptions,gl.ExercisableQuantity AS VestQty,CUM.CurrencyName,			
GR.ExercisePrice,ex.GrantLegSerialNumber,ex.ExerciseNo			
FROM employeemaster emp		   	
INNER JOIN grantoptions [GO] ON emp.employeeid = [GO].employeeid 		  	
INNER JOIN grantregistration gr ON gr.grantregistrationid = [GO].grantregistrationid 		  	
INNER JOIN grantleg gl ON [GO].grantoptionid = gl.grantoptionid 		  	
INNER JOIN ShExercisedOptions ex ON ex.GrantLegSerialNumber = gl.id		  	
INNER JOIN scheme sch ON [GO].schemeid = sch.schemeid		  	
LEFT OUTER JOIN paymentmaster PM ON Pm.paymentmode = Ex.paymentmode		  	
INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON sch.MIT_ID=CIM.MIT_ID			
INNER JOIN CurrencyMaster AS CUM ON CIM.CurrencyID=CUM.CurrencyID			
WHERE gl.finalvestingdate=@VESTING_DATE				
GROUP BY emp.employeeid,emp.employeename,GR.ExercisePrice,CUM.CurrencyName,
[GO].GrantedOptions,gl.finalvestingdate,ex.GrantLegSerialNumber,ex.ExerciseNo,		 
ex.PaymentMode,ex.ExerciseDate,gl.ExercisableQuantity,ex.ExerciseId						

------------------------------------------------------------------------------------------------------------------------------------			
------------------------------------Get the data based on excise no and grantlegserialno--------------------------------------------		  



CREATE TABLE #ActualFMVnTxPaidRpt
(
EmployeeID VARCHAR(50),
[Old Employee ID] VARCHAR(50),
[Change in Emp ID during vesting period] VARCHAR(50),
[Transfer Date] datetime,
EmployeeName VARCHAR(100),
SchemeTitle VARCHAR(100),
GrantDate VARCHAR(20),
VestingDate VARCHAR(20),
ExercisedDate VARCHAR(20),
PaymentMode VARCHAR(50),
[Payment status] VARCHAR(50),
[GRANT Qty] bigint,
[Vest Qty] bigint,
[Currency] varchar(100),
[exercise price] Numeric(18,2),
[days between grant date and vesting] int,
[FMV as vesting date] Numeric(18,2),
[Perquisite value] Numeric(18,2),
[Total Tax amount collected (CUR)] Numeric(18,2),
[Total SS amount collected (CUR)] Numeric(18,2),
ExerciseNo int,
[CountryName Trip 1] varchar(50),
[Start DATE Trip 1] VARCHAR(20),
[End DATE Trip 1] VARCHAR(20),
[Number of days in Country Trip 1] int,
[Apportioned perquisite value (CUR) Trip 1] Numeric(18,2),
[Tax amount collected (CUR) Trip 1] Numeric(18,2),
[SS amount collected (CUR) Trip 1] Numeric(18,2)
)


insert into #ActualFMVnTxPaidRpt(EmployeeID,[Old Employee ID],[Change in Emp ID during vesting period],[Transfer Date] ,EmployeeName ,SchemeTitle ,
GrantDate ,VestingDate ,ExercisedDate ,PaymentMode,[Payment status],[GRANT Qty] ,[Vest Qty] ,[Currency] ,[exercise price] ,
[days between grant date and vesting],[FMV as vesting date] ,[Perquisite value] ,[Total Tax amount collected (CUR)] ,
[Total SS amount collected (CUR)] ,ExerciseNo,[CountryName Trip 1],[Start DATE Trip 1] ,[End DATE Trip 1] ,[Number of days in Country Trip 1],
[Apportioned perquisite value (CUR) Trip 1] ,[Tax amount collected (CUR) Trip 1] ,[SS amount collected (CUR) Trip 1] )

SELECT a.EmployeeID,EMP.LoginID as [Old Employee ID],CASE WHEN (a.EmployeeID=EMP.LoginID) THEN 'YES' ELSE 'NO' END  AS [Change in Emp ID during vesting period],
a.[Transfer Date],a.EmployeeName,a.SchemeTitle,convert(VARCHAR(20), a.GrantDate,106) AS GrantDate,convert(VARCHAR(20), a.VestingDate,106) AS VestingDate,convert(VARCHAR(20),a.ExercisedDate,106) AS ExercisedDate,
a.PaymentMode,a.[Payment status],a.[GRANT Qty],a.[Vest Qty],a.[Currency],a.[exercise price],a.[days between grant date and vesting],
b.[FMV as vesting date],b.[Perquisite value],b.[Total Tax amount collected (CUR)],b.[Total SS amount collected (CUR)],
a.ExerciseNo,
a.CountryName,convert(VARCHAR(20),a.FROM_DATE,106) AS [Start DATE],convert(VARCHAR(20),a.TO_DATE,106) AS [End DATE],a.[Number of days in Country],ROUND(a.[Apportioned perquisite value (CUR)],2),ROUND(a.[Tax amount collected (CUR)],2),
a.[SS amount collected (CUR)]
 from

((SELECT CRER.EmployeeID,NULL AS [Old Employee ID],NULL AS [Change in Emp ID during vesting period],
NULL AS [Transfer Date], CRER.EmployeeName,CRER.SchemeTitle,CRER.GrantDate,CRER.VestingDate,
CRER.ExercisedDate,CRER.PaymentMode,CRER.PaymentStatus AS [Payment status], 
CRER.GrantedOptions AS [GRANT Qty],SUM(CRER.VestQty) AS [Vest Qty],CRER.CurrencyName AS [Currency],CRER.ExercisePrice AS [exercise price],
datediff(day,CRER.GrantDate,CRER.VestingDate) as [days between grant date and vesting],
--(CASE WHEN ETD.FMVVALUE IS NOT NULL THEN ETD.FMVVALUE ELSE ETD.TENTATIVEFMVVALUE END) AS
ETD.FMVVALUE,
CT.CountryName,ETD.FROM_DATE,ETD.TO_DATE,Datediff(day,ETD.FROM_DATE,ETD.TO_DATE) AS [Number of days in Country],
SUM( ISNULL(ETD.PERQVALUE,0)) AS [Apportioned perquisite value (CUR)],

sum((CASE WHEN	ETD.TAX_AMOUNT IS NOT NULL THEN ETD.TAX_AMOUNT ELSE ETD.TENTATIVETAXAMOUNT END)) AS [Total Tax amount collected (CUR)], 


sum(ETD.TAX_AMOUNT) AS [Tax amount collected (CUR)],


sum(ETD.TENTATIVETAXAMOUNT) AS [SS amount collected (CUR)],CRER.ExerciseNo
FROM #Shexcercise CRER 
JOIN EXERCISE_TAXRATE_DETAILS ETD 
ON CRER.ExercisID = ETD.EXERCISE_NO                      
AND CRER.grantlegserialnumber=ETD.GRANTLEGSERIALNO 
JOIN CountryMaster CT ON ETD.COUNTRY_ID=CT.ID
GROUP BY 
CRER.EmployeeID,CRER.EmployeeName,CRER.SchemeTitle,CRER.GrantDate,CRER.VestingDate,CRER.ExercisedDate,CRER.PaymentMode, 
CRER.GrantedOptions,CRER.CurrencyName,CRER.ExercisePrice,
datediff(day,CRER.GrantDate,CRER.VestingDate),ETD.FMVVALUE,
CT.CountryName,ETD.FROM_DATE,ETD.TO_DATE,Datediff(day,ETD.FROM_DATE,ETD.TO_DATE),CRER.ExerciseNo,CRER.PaymentStatus
--CRER.VestQty

)a

join

(SELECT CRER.EmployeeID,CRER.EmployeeName,CRER.SchemeTitle,CRER.GrantDate,CRER.VestingDate,
CRER.ExercisedDate,CRER.PaymentMode,CRER.PaymentStatus AS [Payment status], 
CRER.GrantedOptions AS [GRANT Qty],CRER.CurrencyName AS [Currency],CRER.ExercisePrice AS [exercise price],
(CASE WHEN SEO.FMVPrice IS NOT NULL THEN SEO.FMVPrice ELSE SEO.TentativeFMVPrice END) AS [FMV as vesting date],
--(CASE WHEN SEO.PerqstValue IS NOT NULL THEN SEO.PerqstValue ELSE SEO.TentativePerqstValue END) AS [Perquisite value],
SUM((CASE WHEN ETD.PERQVALUE IS NOT NULL THEN ETD.PERQVALUE ELSE ETD.TENTATIVEPERQVALUE END)) AS [Perquisite value],

--SEO.FMVPrice AS [FMV as vesting date],
--SEO.PerqstValue AS [Perquisite value],
--sum(ETD.TAX_AMOUNT) AS [Total Tax amount collected (CUR)],
--sum((CASE WHEN	ETD.TAX_AMOUNT IS NOT NULL THEN sum(ETD.TAX_AMOUNT) ELSE sum(ETD.TENTATIVETAXAMOUNT) END)) AS [Total Tax amount collected (CUR)], 
sum((CASE WHEN	ETD.TAX_AMOUNT IS NOT NULL THEN ETD.TAX_AMOUNT ELSE ETD.TENTATIVETAXAMOUNT END)) AS [Total Tax amount collected (CUR)], 
sum(ETD.TENTATIVETAXAMOUNT) AS [Total SS amount collected (CUR)],CRER.ExerciseNo

FROM #Shexcercise CRER 
JOIN EXERCISE_TAXRATE_DETAILS ETD 
ON CRER.ExercisID = ETD.EXERCISE_NO                      
AND CRER.grantlegserialnumber=ETD.GRANTLEGSERIALNO
JOIN ShExercisedOptions SEO
ON CRER.ExercisID=SEO.ExerciseId
AND CRER.grantlegserialnumber=SEO.GrantLegSerialNumber
GROUP BY 
CRER.EmployeeID,CRER.EmployeeName,CRER.SchemeTitle,CRER.GrantDate,CRER.VestingDate,CRER.ExercisedDate,CRER.PaymentMode, 
CRER.GrantedOptions,CRER.CurrencyName,CRER.ExercisePrice,
CRER.ExerciseNo,SEO.FMVPrice,CRER.PaymentStatus,SEO.TentativeFMVPrice

)b	 

ON a.EmployeeID=b.EmployeeID
AND a.ExerciseNo=b.ExerciseNo
--AND a.grantlegserialnumber=b.grantlegserialnumber
JOIN EmployeeMaster EMP ON a.EmployeeID=EMP.EmployeeID
)
select * from #ActualFMVnTxPaidRpt

-------------------------Get max count to perform pivoting-----------------------------------------------	

SELECT max(EmpCount1) AS EmpCont 
FROM (
Select COUNT(ExerciseNo)as EmpCount1,ExerciseNo 
from #ActualFMVnTxPaidRpt group by ExerciseNo
)d

-----------------------------------------------------------------------------------------------------------------			

GO
