/****** Object:  StoredProcedure [dbo].[GetDematDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetDematDetails]
GO
/****** Object:  StoredProcedure [dbo].[GetDematDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************************************************   
Author:  <Chetan Tembhre>      
Create date: <01 Apr 2013>  
Updated by VivekH On 25 April 2019    

Updated by :  Bhakti Pande
Updated On : 23 jun 2020
Updated On : 01 july 2020
Description : Add CML Copy Upload columns and  added filters to report .
Description -1. Employee Demat Details Report
EXEC GetDematDetails '10010'
***************************************************************************************************/
CREATE PROCEDURE [dbo].[GetDematDetails]
(
	@EmployeeId VARCHAR(50) = NULL,
	@CMLUploadStatus VARCHAR(200)= NULL,
	@Accounttype VARCHAR(20)= NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @QUERY_1 AS NVARCHAR(MAX)
	DECLARE @QUERY_2 AS NVARCHAR(MAX)
	DECLARE @QUERY_3 AS NVARCHAR(MAX)
	DECLARE @QUERY_4 AS NVARCHAR(MAX)
	DECLARE @STR_EMPLOYEEID NVARCHAR(500)
	DECLARE @CMLSTAUS NVARCHAR(200)
	DECLARE @ACCOUNT_TYPE NVARCHAR(100)
	DECLARE @STR_SQL_FINAL NVARCHAR(MAX)
	SET @STR_EMPLOYEEID = ''	
	IF(@EmployeeId IS NOT NULL)
	BEGIN
		IF(@EmployeeId <> '---All Employees---')
			SET @STR_EMPLOYEEID = ' AND EM.EmployeeID = '''+@EmployeeId+''''	
	END
	
	SET @CMLSTAUS = ''
	IF(@CMLUploadStatus <> '--Please Select--')
			IF(@CMLUploadStatus = 'Yes')
			SET @CMLSTAUS = ' AND ED.CMLUploadStatus = '''+'Y'+'''' 
		
			ELSE IF(@CMLUploadStatus = 'No')			
			SET @CMLSTAUS = ' AND ED.CMLUploadStatus  ' + convert(varchar,@CMLSTAUS)+'IS NULL'+''


	SET @ACCOUNT_TYPE = ''
		IF(@Accounttype ='BOTH' OR @Accounttype ='--Please Select--')
			SET @ACCOUNT_TYPE = 'BOTH'				

		ELSE IF(@Accounttype ='BROKER')
			SET @ACCOUNT_TYPE = 'BROKER'

		ELSE IF(@Accounttype ='DEMAT')
			SET @ACCOUNT_TYPE= 'DEMAT'
		
	--for Both
	SET @QUERY_1 ='

	SELECT  DISTINCT EM.LoginID,EM.EmployeeID,EM.EmployeeName,ISNULL(EM.PANNumber,'''') AS PANNumber,
		CASE 
		   WHEN ED.DematAccountType=''R'' THEN ''Repatriable'' 
		   WHEN ED.DematAccountType=''N'' OR ED.DematAccountType=''NR'' THEN ''Non-Repatriable''
		   WHEN ED.DematAccountType=''A'' THEN ''Not Applicable''
		   ELSE '''' 
		END AS DematAccountType,
		CASE 
		   WHEN ED.DepositoryName=''N'' THEN ''NSDL''
		   WHEN ED.DepositoryName=''C'' THEN ''CDSL''
		   ELSE '''' 
		END AS DepositoryName,
	ED.DepositoryIDNumber,
	ED.DepositoryParticipantName AS DepositoryParticipantNo,ED.ClientIDNumber,
	ED.DPRecord AS NameAsPerDP_Record,
	CASE 
	   WHEN ED.CMLUploadStatus IS NULL THEN ''No''
	   WHEN ED.CMLUploadStatus =''Y'' THEN ''Yes''
	   ELSE '''' 
	END AS CMLUploadStatus,

	CASE 	   		 
	   WHEN ED.CMLCopy IS NOT NULL AND ED.CMLUploadDate IS NOT NULL THEN convert(varchar, ED.CMLUploadDate, 103)
	   ELSE NULL
	END AS CMLUploadDate,

	CASE 
	   WHEN ISNUll(ED.IsValidDematAcc,0)=0 THEN ''Invalid''		 
	   ELSE ''Valid'' 
	END AS IsValidDematAcc,
	CASE WHEN ISNULL(ED.IsActive,0)=1 THEN ''Active''
	ELSE ''Inactive''
	END AS [Status],

	    B.BROKER_DEP_TRUST_CMP_NAME AS [Broker / Depository Trust Company name],
		B.BROKER_DEP_TRUST_CMP_ID AS [Broker / Depository Trust Company ID],
		B.BROKER_ELECT_ACC_NUM AS [Broker / Electronic Account Number],
		CASE WHEN ISNULL(B.IsValidBrokerAcc,0) = 1 THEN ''Valid''
		ELSE ''Invalid'' END AS [BrokerStatus]
	FROM EmployeeMaster EM
	LEFT JOIN Employee_UserDematDetails ED ON EM.EmployeeID=ED.EmployeeID AND ED.IsActive=1
	LEFT JOIN Employee_UserBrokerDetails B ON B.EMPLOYEE_ID=EM.EmployeeID AND B.IS_ACTIVE=1
	WHERE NewEmployeeId IS NULL AND EM.deleted = 0 '

	--for Demat
	SET @QUERY_2 ='
	SELECT EM.LoginID,EM.EmployeeID,EM.EmployeeName,ISNULL(EM.PANNumber,'''') AS PANNumber,
		CASE 
		   WHEN ED.DematAccountType=''R'' THEN ''Repatriable'' 
		   WHEN ED.DematAccountType=''N'' OR ED.DematAccountType=''NR'' THEN ''Non-Repatriable''
		   WHEN ED.DematAccountType=''A'' THEN ''Not Applicable''
		   ELSE '''' 
		END AS DematAccountType,
		CASE 
		   WHEN ED.DepositoryName=''N'' THEN ''NSDL''
		   WHEN ED.DepositoryName=''C'' THEN ''CDSL''
		   ELSE '''' 
		END AS DepositoryName,
	ED.DepositoryIDNumber,
	ED.DepositoryParticipantName AS DepositoryParticipantNo,ED.ClientIDNumber,
	ED.DPRecord AS NameAsPerDP_Record,
	CASE 
	   WHEN ED.CMLUploadStatus IS NULL THEN ''No''
	   WHEN ED.CMLUploadStatus =''Y'' THEN ''Yes''
	   ELSE '''' 
	END AS CMLUploadStatus,

	CASE		 
	   WHEN ED.CMLCopy IS NOT NULL AND ED.CMLUploadDate IS NOT NULL THEN convert(varchar, ED.CMLUploadDate, 103)
	   ELSE NULL
	END AS CMLUploadDate,

	CASE 
	   WHEN ISNUll(ED.IsValidDematAcc,0)=0 THEN ''Invalid''		 
	   ELSE ''Valid'' 
	END AS IsValidDematAcc,
	CASE WHEN ISNULL(ED.IsActive,0)=1 THEN ''Active''
	ELSE ''Inactive''
	END AS [Status],

	'''' AS [Broker / Depository Trust Company name],
	'''' AS [Broker / Depository Trust Company ID],
	'''' AS [Broker / Electronic Account Number],
	'''' AS [BrokerStatus]
	FROM EmployeeMaster EM
	INNER JOIN Employee_UserDematDetails ED ON EM.EmployeeID=ED.EmployeeID AND ED.IsActive=1	
	WHERE NewEmployeeId IS NULL AND EM.deleted = 0 '
	
	--for Broker
	SET @QUERY_3 = 'SELECT EM.LoginID,EM.EmployeeID,EM.EmployeeName,ISNULL(EM.PANNumber,'''') AS PANNumber,
	'''' AS DematAccountType,'''' AS DepositoryName,'''' AS DepositoryIDNumber,
	'''' AS DepositoryParticipantNo,'''' AS ClientIDNumber,'''' AS NameAsPerDP_Record,
	'''' AS CMLUploadStatus,'''' AS CMLUploadDate,
	'''' AS IsValidDematAcc,
	'''' AS [Status],

	B.BROKER_DEP_TRUST_CMP_NAME AS [Broker / Depository Trust Company name],
	B.BROKER_DEP_TRUST_CMP_ID AS [Broker / Depository Trust Company ID],
	B.BROKER_ELECT_ACC_NUM AS [Broker / Electronic Account Number],
	CASE WHEN ISNULL(B.IsValidBrokerAcc,0) = 1 THEN ''Valid''
	ELSE ''Invalid'' END AS [BrokerStatus]

	FROM EmployeeMaster EM	
	INNER JOIN Employee_UserBrokerDetails B ON B.EMPLOYEE_ID=EM.EmployeeID AND B.IS_ACTIVE=1
	WHERE NewEmployeeId IS NULL AND EM.deleted =0 '

	SET @QUERY_4= ' ORDER BY EM.EmployeeID ASC '

	--PRINT ('----Q1------')
	---PRINT (@QUERY_5)
	--PRINT ('--------- Q2')
	--PRINT (@QUERY_2)
	--PRINT ('--------- Q3')
	--PRINT (@QUERY_3)
	--PRINT ('--------- Q4')
	--PRINT (@QUERY_4)
	--PRINT ('----@STR_EMPLOYEEID------')
	--PRINT (@STR_EMPLOYEEID)
	--PRINT ('----@CMLSTAUS------')
	--PRINT (@CMLSTAUS)
	--print (@ACCOUNT_TYPE)
	
	IF(@ACCOUNT_TYPE='BOTH' AND @CMLSTAUS IS NULL)
	BEGIN
		EXEC (@QUERY_1 + @STR_EMPLOYEEID + @QUERY_4)
	END
	ELSE IF(@ACCOUNT_TYPE='BOTH' OR @ACCOUNT_TYPE = '--Please Select--')
	BEGIN
		EXEC (@QUERY_1 + @CMLSTAUS + @STR_EMPLOYEEID + @QUERY_4)
	END
	ELSE IF(@ACCOUNT_TYPE = 'DEMAT')
	BEGIN
		EXEC(@QUERY_2 + @STR_EMPLOYEEID + @CMLSTAUS + @QUERY_4)
	END
	ELSE IF(@ACCOUNT_TYPE ='BROKER')
	BEGIN
		EXEC(@QUERY_3 + @STR_EMPLOYEEID + @QUERY_4) 
	END
	ELSE
	BEGIN
		EXEC (@QUERY_1 + @STR_EMPLOYEEID + @QUERY_4)
	END
		
	SET NOCOUNT OFF
	END
GO
