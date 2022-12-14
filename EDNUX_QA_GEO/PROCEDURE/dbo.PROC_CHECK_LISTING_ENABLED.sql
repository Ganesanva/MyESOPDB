/****** Object:  StoredProcedure [dbo].[PROC_CHECK_LISTING_ENABLED]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CHECK_LISTING_ENABLED]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CHECK_LISTING_ENABLED]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CHECK_LISTING_ENABLED]
AS  
BEGIN
   
   IF EXISTS(SELECT RolePrivilegeId,RoleId 
				    FROM RolePrivileges  RP
					INNER JOIN ScreenActions SA	ON SA.ScreenActionId = RP.ScreenActionId
					INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
					WHERE SM.Name IN ( 'Corporate Action and Listing Documentation Parameter Setting',
								       'Corporate Action and Listing Document Generation'))
	BEGIN
		DECLARE @Query VARCHAR(MAX)
		SELECT @Query =COALESCE(@Query+', ' ,'') + Temp.Name  FROM 
		(
			SELECT DISTINCT R.Name 
			FROM SCREENMASTER SM
			INNER JOIN SCREENACTIONS SA  ON SA.SCREENID = SM.SCREENID 
			INNER JOIN ACTIONMASTER AM ON SA.ACTIONID = AM.ACTIONID  
			INNER JOIN ROLEPRIVILEGES RP  ON RP.SCREENACTIONID = SA.SCREENACTIONID 	
			INNER JOIN RoleMaster R ON RP.RoleId=R.RoleId
			WHERE SM.Name IN ( 'Corporate Action and Listing Documentation Parameter Setting',
								       'Corporate Action and Listing Document Generation')
		)Temp
		
		SELECT 'Please Deactivate Corporate Action and Listing Documentation menu under roles:- '+ @Query  AS ListingURLEnabledDetails
	END
	
END
GO
