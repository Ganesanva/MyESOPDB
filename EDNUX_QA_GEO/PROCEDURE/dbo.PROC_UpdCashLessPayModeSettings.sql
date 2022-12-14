/****** Object:  StoredProcedure [dbo].[PROC_UpdCashLessPayModeSettings]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdCashLessPayModeSettings]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdCashLessPayModeSettings]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_UpdCashLessPayModeSettings]
(
	@IsSAEnabled BIT,
	@IsSPEnabled BIT,
	@UserId		 VARCHAR(50),
	@CompanyId	 VARCHAR(50),
	@Result		 BIT = 0 OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @OldIsSAEnabled BIT, 
			@OldIsSPEnabled BIT
			
	SELECT @OldIsSAEnabled = IsSAPayModeAllowed, @OldIsSPEnabled = IsSPPayModeAllowed FROM CompanyParameters
	BEGIN TRY
		--Update data in CompanyParameters based on CompanyID
		UPDATE	CompanyParameters 
		SET		IsSAPayModeAllowed = @IsSAEnabled,
				IsSPPayModeAllowed = @IsSPEnabled
		WHERE CompanyID = @CompanyId	
		
		IF (@@ROWCOUNT > 0)
			BEGIN
				INSERT INTO AuditTrailOfCLsPayModeSetting 
					(CompanyId,OldIsSAPayModeAllowed,NewIsSAPayModeAllowed,OldIsSPPayModeAllowed,NewIsSPPayModeAllowed,ModifiedBy,ModifiedOn)
				VALUES (@CompanyId,@OldIsSAEnabled,@IsSAEnabled,@OldIsSPEnabled,@IsSPEnabled,@UserId,SYSDATETIME())
				SET @Result = 1
			END
	END TRY
	BEGIN CATCH
		--SELECT @@ERROR
		SET @Result = 0		
	END CATCH
	SET NOCOUNT OFF	
END
GO
