/****** Object:  StoredProcedure [dbo].[SP_PerquisiteTaxFromCompanyParameter]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_PerquisiteTaxFromCompanyParameter]
GO
/****** Object:  StoredProcedure [dbo].[SP_PerquisiteTaxFromCompanyParameter]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================= 
--Procedure Name : SP_PerquisiteTaxFromCompanyParameter
-- Author : Chetan Chopkar & Trupti 
-- Create date : 07 May 2012 
-- Description :   
-- ============================================= 
	
--Sp_perquisitetaxfromcompanyparameter 'KIAL56','Apr26060109'
CREATE PROCEDURE [dbo].[SP_PerquisiteTaxFromCompanyParameter]
	-- Add the parameters for the stored procedure here
	@EmployeeId varchar(20)	,
	@GrantOptionId varchar(100),
	@ExerciseNo numeric (10)= NULL
	
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ResStatus Char
	DECLARE @EmpStatus Char
	DECLARE @EMP_TAXSLAB numeric(18,6)
    -- Insert statements for procedure here
	SELECT 
	@ResStatus =  CASE WHEN (@ExerciseNo IS NOT NULL) THEN (SELECT ResidentialStatus FROM EMPDET_With_EXERCISE WHERE ExerciseNo = @ExerciseNo) 
		ELSE 
			EM.ResidentialStatus
		END,
	@EmpStatus =  CASE WHEN ((EM.DateOfTermination IS NULL) OR (EM.DateOfTermination='')) THEN 'L' 
		ELSE 
			'R' 
		END ,
	@EMP_TAXSLAB=isnull(EM.Tax_slab,0)
	FROM  EmployeeMaster AS EM
	INNER JOIN GrantOptions GOPT ON  EM.EmployeeID = GOPT.EmployeeId 
	WHERE GOPT.GrantOptionId = @GrantOptionId and GOPT.EmployeeID = @EmployeeId

	PRINT 'EmployeeStatus' + @EmpStatus 
	PRINT 'ResidentialStatus' + @ResStatus 
	
	IF((@ResStatus ='R') or (@ResStatus ='') or (@ResStatus is null)) 
		BEGIN
			SELECT @EmployeeId AS EMPLOYEEID ,@GrantOptionId AS GRANTOPTIONID,'C' AS PerqRuleType, RIPerqValue AS calPerqValue, RIPerqTax  AS calPerqTax, 
			PerqTax = 
				CASE WHEN @EmpStatus = 'L' THEN case   WHEN Apply_Emp_taxslab='Y' THEN
									   @EMP_TAXSLAB
									ELSE dbo.FN_PQ_TAX_ROUNDING(prequisiteTax)
							END  
				ELSE  
					CASE WHEN	TaxRate_ResignedEmp >0
						THEN	TaxRate_ResignedEmp
						ELSE case   WHEN Apply_Emp_taxslab='Y' THEN
									   @EMP_TAXSLAB
									ELSE dbo.FN_PQ_TAX_ROUNDING(prequisiteTax)
							END  
						END
				END 
			FROM CompanyParameters   					
		END
	ELSE IF(@ResStatus ='N')  
		BEGIN
			SELECT @EmployeeId AS EMPLOYEEID ,@GrantOptionId AS GRANTOPTIONID,'C' AS PerqRuleType, NRIPerqValue AS calPerqValue, NRIPerqTax AS calPerqTax, 
			PerqTax = 
				CASE WHEN @EmpStatus ='L' THEN 
				CASE WHEN Apply_Emp_taxslab='Y'
							 THEN @EMP_TAXSLAB
								ELSE dbo.FN_PQ_TAX_ROUNDING(prequisiteTax)
							 END  
				ELSE  
					CASE WHEN	TaxRate_ResignedEmp >0
						THEN	TaxRate_ResignedEmp
						ELSE 
							case   WHEN Apply_Emp_taxslab='Y' THEN
									   @EMP_TAXSLAB
									ELSE dbo.FN_PQ_TAX_ROUNDING(prequisiteTax)
							END 								 
						END
				END  
			FROM CompanyParameters   
		END   --begin END
	ELSE IF (@ResStatus ='F')
		BEGIN
			SELECT  @EmployeeId AS EMPLOYEEID ,@GrantOptionId AS GRANTOPTIONID,'C' AS PerqRuleType, FNPerqValue AS calPerqValue, FNPerqTax AS calPerqTax,
			PerqTax = 
				CASE WHEN @EmpStatus ='L' THEN case   WHEN Apply_Emp_taxslab='Y' THEN
									   @EMP_TAXSLAB
									ELSE dbo.FN_PQ_TAX_ROUNDING(prequisiteTax)
							END  
				ELSE  
					CASE WHEN	TaxRate_ResignedEmp >0
						THEN	TaxRate_ResignedEmp
						ELSE case   WHEN Apply_Emp_taxslab='Y' THEN
									   @EMP_TAXSLAB
									ELSE dbo.FN_PQ_TAX_ROUNDING(prequisiteTax)
							END  
						END
				END 
			FROM CompanyParameters
		END	
END
GO
