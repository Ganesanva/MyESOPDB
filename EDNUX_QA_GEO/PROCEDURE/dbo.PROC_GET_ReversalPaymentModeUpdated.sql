/****** Object:  StoredProcedure [dbo].[PROC_GET_ReversalPaymentModeUpdated]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_ReversalPaymentModeUpdated]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_ReversalPaymentModeUpdated]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_ReversalPaymentModeUpdated]

AS
BEGIN
	SET NOCOUNT ON;
	
	Create Table #PaymentMode
	(
		P_ID INT Identity,
		PaymentMode VARCHAR(1),
		MIT_ID INT

	)
	
	INSERT into #PaymentMode
	EXEC('Select DISTINCT pm.PaymentMode,CIM.MIT_ID from ResidentialPaymentMode AS RP INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON RP.MIT_ID = CIM.MIT_ID INNER JOIN PaymentMaster pm ON pm.ID = RP.PaymentMaster_Id  Where RP.IsOneProcessFlow=1')

	Select DISTINCT sh.ExerciseNo,sh.EmployeeID,sh.PaymentMode from shexercisedoptions sh where PaymentMode IN (Select PaymentMode from #PaymentMode where MIT_ID=sh.MIT_ID ) AND IsAccepted=0 AND IsAutoExercised=1

	SET NOCOUNT OFF;
END

Drop Table #PaymentMode

GO
