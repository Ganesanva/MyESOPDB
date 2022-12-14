/****** Object:  StoredProcedure [dbo].[PROC_AuditTrailForConfigPerDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_AuditTrailForConfigPerDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_AuditTrailForConfigPerDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_AuditTrailForConfigPerDetails]
	@EmployeeField			VARCHAR(100)=NULL,
	@Check_ToExercise		CHAR(1)=NULL,
	@Check_Own				CHAR(1)=NULL,
	@Check_Funding			CHAR(1)=NULL,
	@Check_SellAll			CHAR(1)=NULL,
	@Check_SellPartial		CHAR(1)=NULL,
	@Check_Exercise			CHAR(1)=NULL,
	@ADS_CHECK_OWN			CHAR(1)=NULL,
	@ADS_CHECK_FUNDING		CHAR(1)=NULL,
	@ADS_CHECK_SELLALL		CHAR(1)=NULL,
	@ADS_CHECK_SELLPARTIAL	CHAR(1)=NULL,
	@ADS_CHECK_EXERCISE		CHAR(1)=NULL,
	@LastUpdatedBy			VARCHAR(100)=NULL
	--Label, Exercise, Own, Funding, SellAll, SellPartial, ADS_Own, ADS_Funding, ADS_SellAll, ADS_SellPartial,sc.UserId
AS
BEGIN
	INSERT INTO AUDIT_TRAIL_FOR_CONFIGURE_PERSOANL_DETAILS 
	(
		EmployeeField,Check_ToExercise,
		Check_Own,Check_Funding,Check_SellAll,
		Check_SellPartial,
		Check_Exercise,
		ADS_CHECK_OWN,ADS_CHECK_FUNDING,ADS_CHECK_SELLALL,
		ADS_CHECK_SELLPARTIAL,ADS_CHECK_EXERCISE,
		LastUpdatedBy,LastUpdatedOn
	) 
	VALUES
	(
		@EmployeeField,@Check_ToExercise,
		@Check_Own,@Check_Funding,@Check_SellAll,
		@Check_SellPartial,	
		@Check_Exercise,
		@ADS_CHECK_OWN,@ADS_CHECK_FUNDING,@ADS_CHECK_SELLALL,
		@ADS_CHECK_SELLPARTIAL,@ADS_CHECK_EXERCISE,
		@LastUpdatedBy,GETDATE()
	)
END
GO
