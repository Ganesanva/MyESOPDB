/****** Object:  StoredProcedure [dbo].[PROC_UpdateFundingStatus]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateFundingStatus]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateFundingStatus]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_UpdateFundingStatus]
(
	@UserId NVARCHAR(50),
	@Nationality NVARCHAR(80)
)
AS
BEGIN
	UPDATE 	RPM 
	SET 	RPM.isActivated='Y', RPM.LastUpdatedBy=@UserId, RPM.LastUpdatedOn=GETDATE()
	FROM	ResidentialPaymentMode RPM INNER JOIN 
			ResidentialType RT ON RT.id = RPM.ResidentialType_Id INNER JOIN
			PaymentMaster PM ON PM.Id = RPM.PaymentMaster_Id
	WHERE	RT.Description = (@Nationality) 
	AND		UPPER(PM.PayModeName) = 'FUNDING'
	
	--The operation completed successfully.
	IF(@@ERROR=0)
		RETURN 1
	ELSE
		RETURN 0
END
GO
