/****** Object:  StoredProcedure [dbo].[PROC_UpdtCnfigPayModeInCompParam]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdtCnfigPayModeInCompParam]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdtCnfigPayModeInCompParam]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_UpdtCnfigPayModeInCompParam]
(
	@TrustCompanyName VARCHAR(100),
	@CompanyId		VARCHAR(100)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Query VARCHAR(80)= @TrustCompanyName +'..GetTrustResidentDetails '''+ @CompanyID +''''
	--PRINT @Query
	CREATE TABLE #TEMP(SELLALLTYPE VARCHAR(2),SELLPARTIALTYPE VARCHAR(2),RI CHAR,NRI CHAR,FN CHAR,SPRI CHAR,SPNRI CHAR,SPFN CHAR )
	INSERT INTO #TEMP EXEC (@Query)
	
	UPDATE CompanyParameters 
	SET IsSAPayModeAllowed= (SELECT CASE WHEN (COUNT(1)= 1) THEN 1 ELSE 0 END 
							FROM #TEMP WHERE SELLALLTYPE='SA' AND (RI='Y' OR NRI='Y' OR FN='Y')),
		IsSPPayModeAllowed = (SELECT CASE WHEN (COUNT(1)= 1) THEN 1 ELSE 0 END 
							FROM #TEMP WHERE SELLPARTIALTYPE='SP' AND (SPRI='Y' OR SPNRI='Y' OR SPFN='Y'))							
	
	DROP TABLE #TEMP
	SET NOCOUNT OFF
END
GO
