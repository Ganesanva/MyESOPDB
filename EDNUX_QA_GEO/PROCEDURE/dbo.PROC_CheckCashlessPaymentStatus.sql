/****** Object:  StoredProcedure [dbo].[PROC_CheckCashlessPaymentStatus]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CheckCashlessPaymentStatus]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CheckCashlessPaymentStatus]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_CheckCashlessPaymentStatus]
@ExerciseNo NUMERIC(18,0)

AS

BEGIN
	SELECT COUNT(1) AS CashlessPaymentStatus FROM ShExercisedOptions SHEX 
	INNER JOIN TransactionDetails_CashLess TRNC 
	ON SHEX.ExerciseNo = TRNC.ExerciseNo
	WHERE SHEX.ExerciseNo=@ExerciseNo
	AND (SHEX.PaymentMode = 'A' OR SHEX.PaymentMode = 'P') 
END

GO
