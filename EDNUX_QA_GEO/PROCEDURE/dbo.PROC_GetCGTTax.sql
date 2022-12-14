/****** Object:  StoredProcedure [dbo].[PROC_GetCGTTax]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetCGTTax]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCGTTax]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetCGTTax]      
	@ExNo NUMERIC(9),  
	@LoginId VARCHAR(20)  
AS      
BEGIN    
 --SET NOCOUNT ON added to prevent extra result sets from      
 SET NOCOUNT ON;    
     
 DECLARE @CgtFormulaID INT  
 DECLARE @PANStatus VARCHAR(20)  
 DECLARE @CGTRateST DECIMAL(18,6)  
 DECLARE @CGTRateLT DECIMAL(18,6)  
 DECLARE @EmpResidentialStatus VARCHAR(10)  
 DECLARE @EMPID VARCHAR(50)  
  
 SELECT @EMPID=EmployeeID, @EmpResidentialStatus=ResidentialStatus,@PANStatus=CASE WHEN PANNumber='' THEN 'WITHOUT PAN' ELSE 'WITH PAN' END  
 FROM EmployeeMaster WHERE LoginID=@LoginId  
   
 SELECT TOP 1 @CgtFormulaID=cgt_settings_id,@CGTRateLT=CASE WHEN @EmpResidentialStatus='R' THEN RI_LTCG_Rate  
 WHEN @EmpResidentialStatus='N' THEN NRI_LTCG_Rate WHEN @EmpResidentialStatus='F' THEN FN_LTCG_Rate END,  
 @CGTRateST= CASE    
 WHEN CGT_SETTINGS_At='C' THEN -- CompanyLevel  
 ----------------------------  
 CASE   
 WHEN @EmpResidentialStatus='R' THEN    
 CASE WHEN @PANStatus='WITH PAN' THEN RI_STCG_Rate_WPAN WHEN @PANStatus='WITHOUT PAN' THEN RI_STCG_Rate_WOPAN ELSE 0 END  
 WHEN @EmpResidentialStatus='N' THEN  
 CASE WHEN @PANStatus='WITH PAN' THEN NRI_STCG_Rate_WPAN WHEN @PANStatus='WITHOUT PAN' THEN NRI_STCG_Rate_WOPAN ELSE 0 END  
 WHEN @EmpResidentialStatus='F' THEN   
    CASE WHEN @PANStatus='WITH PAN' THEN FN_STCG_Rate_WPAN WHEN @PANStatus='WITHOUT PAN' THEN FN_STCG_Rate_WOPAN ELSE 0 END  
 END  
 ---------------------------  
 WHEN CGT_SETTINGS_At='E' THEN  --Emp Level  
 ----------------  
 CASE  
 WHEN @PANStatus='WITH PAN' THEN (SELECT TOP 1 CGTWithPAN FROM CGTEmployeeTax WHERE EmployeeID=@EMPID ORDER BY CGT_ID DESC )  
 WHEN @PANStatus='WITHOUT PAN' THEN (SELECT TOP 1 CGTWithoutPAN FROM CGTEmployeeTax WHERE EmployeeID=@EMPID ORDER BY CGT_ID DESC )  
 END  
 -------------------------------------------------  
 END  
 FROM CGT_SETTINGS WHERE CONVERT(DATE,APPLICABLE_FROM)<=CONVERT(DATE,GETDATE()) ORDER BY lastupdated_on DESC  
   
 SELECT  @CGTRateST AS CapitalGainTax
END  
GO
