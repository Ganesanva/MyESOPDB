/****** Object:  StoredProcedure [dbo].[PROC_GET_ALL_PAYMENTMODE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_ALL_PAYMENTMODE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_ALL_PAYMENTMODE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_ALL_PAYMENTMODE]
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT ID, PAYMODENAME FROM PAYMENTMASTER
	
	SET NOCOUNT OFF;
END
GO
