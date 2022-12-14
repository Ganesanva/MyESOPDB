/****** Object:  StoredProcedure [dbo].[PROC_ExceptionalCashlessTransCharges]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_ExceptionalCashlessTransCharges]
GO
/****** Object:  StoredProcedure [dbo].[PROC_ExceptionalCashlessTransCharges]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_ExceptionalCashlessTransCharges]
(	
	@ACTION									CHAR(5),
    @TrustDBName							NVARCHAR(100),
    @ClientCompany							NVARCHAR(100),
    @ExerciseNos							NVARCHAR(MAX) = NULL,
    @EmployeeNames							NVARCHAR(MAX) = NULL
 )
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		IF @ACTION = 'EXNO'
		BEGIN
			EXEC 
				('
				SELECT 
					DISTINCT TC.ExerciseNumber
				FROM 
					' + @TrustDBName + '..TrancheConsolidation TC INNER JOIN 
					' + @TrustDBName + '..TRANCHE TR ON TR.TRANCHEID = TC.TRANCHEID					
				WHERE TR.TrancheStatus = 8 AND TR.CompanyId = ' + '''' + @ClientCompany + '''' + ' 
				ORDER BY TC.ExerciseNumber
				' 
				)
		END
		
		ELSE IF @ACTION = 'EMP'
		BEGIN
			EXEC 
				('
				SELECT 
					DISTINCT TC.EmployeeName
				FROM 
					' + @TrustDBName + '..TrancheConsolidation TC INNER JOIN 
					' + @TrustDBName + '..TRANCHE TR ON TR.TRANCHEID = TC.TRANCHEID					
				WHERE TR.TrancheStatus = 8 AND TR.CompanyId = ' + '''' + @ClientCompany + '''' + ' 
				ORDER BY TC.EmployeeName
				' 
				)
		END		
		
		ELSE IF @ACTION = 'DATA'
		BEGIN
			
			IF (@ExerciseNos <> '')
			BEGIN
				SET @ExerciseNos = ' WHERE TC.ExerciseNumber IN (' + @ExerciseNos + ')'
			END
			
			IF (@EmployeeNames <> '')
			BEGIN
				IF (@ExerciseNos = '')
					SET @EmployeeNames = ' WHERE ' + ' TC.EmployeeName IN (' + CHAR(39) + REPLACE(@EmployeeNames,',', CHAR(39) + ',' + CHAR(39)) + CHAR(39) + ')'
				ELSE
					SET @EmployeeNames = ' AND ' + ' TC.EmployeeName IN (' + CHAR(39) + REPLACE(@EmployeeNames,',', CHAR(39) + ',' + CHAR(39)) + CHAR(39) + ')'
			END
			
			PRINT @ExerciseNos
			PRINT @EmployeeNames
						
			EXEC			
				('
				SELECT COUNT(ExerciseNumber) ExerciseidCount, ExerciseNumber INTO #TEMP_EXERCISE_DETAILS FROM  ' + @TrustDBName + '..TrancheConsolidation TC 
				  INNER JOIN ' + @TrustDBName + '..TRANCHE TR ON TR.TRANCHEID = TC.TRANCHEID AND TR.CompanyId = ' + '''' + @ClientCompany + '''' + @ExerciseNos + ' GROUP BY TC.ExerciseNumber
				
				
				SELECT DISTINCT
					TR.TrancheIDAsCompanySeq AS TrancheNumber, TC.EmployeeId, TC.EmployeeName, TC.ExerciseNumber, TC.ExerciseId, TD.TransactionDate AS DateOfSelling,  CAST(TC.OptionsExercised AS INT) [SharesSold]
				FROM 
					' + @TrustDBName + '..TrancheConsolidation TC INNER JOIN 
					' + @TrustDBName + '..TRANCHE TR ON TR.TRANCHEID = TC.TRANCHEID AND TR.CompanyId = ' + '''' + @ClientCompany + '''' + ' INNER JOIN 
					' + @TrustDBName + '..PlacedOrders PO ON PO.TRANCHEID = TC.TRANCHEID INNER JOIN 
					' + @TrustDBName + '..TransactionsDetails TD ON PO.OrderNo = TD.OrderNo AND PO.OrderId = TD.OrderId LEFT OUTER JOIN 
					' + @TrustDBName + '..#TEMP_EXERCISE_DETAILS TED ON TED.ExerciseNumber = TC.ExerciseNumber
				'
				+ @ExerciseNos
				+ @EmployeeNames
				
				)
		END
		
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		RETURN 0
		
	END CATCH
	SET NOCOUNT OFF;
END
GO
