/****** Object:  StoredProcedure [dbo].[Manage_CR_Role]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Manage_CR_Role]
GO
/****** Object:  StoredProcedure [dbo].[Manage_CR_Role]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************************************************   
Author:  <Manasi Patil>      
Create date: <24 July 2014>      
Description - For managing CR role rights 

EXEC Manage_CR_Role 'Complete access'
***************************************************************************************************/

CREATE PROCEDURE [dbo].[Manage_CR_Role] 
	 @RoleId AS VARCHAR(50)
AS
	DECLARE @ScreenActionId VARCHAR(50)
	DECLARE @ScreenId VARCHAR(50)
	DECLARE @RolePrivilegeId VARCHAR(50)
   
BEGIN  
 
		-- 1. FOR INBOX
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'INBOX' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN
								
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'INBOX' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId)) 
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
						
						INSERT INTO RolePrivileges 
						(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES
						(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END		
		END
	
		-- 2. FOR CAPITAL GAIN SETTINGS
		BEGIN
			
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'CAPITAL GAIN SETTINGS' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'CAPITAL GAIN SETTINGS' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId)) 
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
						
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END								
	   END
	   
		-- 3. FOR PASSWORD COFIGURAION
		BEGIN
			
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name)= 'PASSWORD CONFIGURATION' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			
			BEGIN
			
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId), 0)+ 1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId , ScreenId, ActionId)
				VALUES (@ScreenActionId,@ScreenId, '2')		
		   
		   END
			    IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'PASSWORD CONFIGURATION' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
												        
						INSERT INTO RolePrivileges(RolePrivilegeId , RoleId , ScreenActionId, LastUpdatedBy ,LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END						
		END
		
		-- 4. FOR FMV UPLOAD (UNLISTED COMPANY)
		BEGIN
			
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name)= 'FMV UPLOAD (UNLISTED COMPANY)' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN
							
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId), 0)+ 1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId , ScreenId, ActionId)
				VALUES (@ScreenActionId,@ScreenId, '2')	
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
						INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
						INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
						WHERE UPPER(SM.Name )= 'FMV UPLOAD (UNLISTED COMPANY)' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													        
						INSERT INTO RolePrivileges(RolePrivilegeId , RoleId , ScreenActionId, LastUpdatedBy ,LastUpdatedon)
						VALUES (@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END					
		END
		
		-- 5. FOR UPLOAD NON TRADING DAYS
		BEGIN
			
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name)= 'UPLOAD NON-TRADING DAYS' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
				
				BEGIN
										
					SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId), 0)+ 1 FROM ScreenActions)
					
					INSERT INTO ScreenActions (ScreenActionId , ScreenId, ActionId)
					VALUES (@ScreenActionId,@ScreenId, '2')		
			        
			    END
			        IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'UPLOAD NON-TRADING DAYS' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
						BEGIN
							SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
							SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
														        
							INSERT INTO RolePrivileges(RolePrivilegeId , RoleId , ScreenActionId, LastUpdatedBy ,LastUpdatedon)
							VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
						END										
		END
		
		-- 6. FOR MASS MAIL UPLOAD
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name)= 'MASS MAIL UPLOAD' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '1')
				BEGIN

					SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId), 0)+ 1 FROM ScreenActions)
					
					INSERT INTO ScreenActions (ScreenActionId , ScreenId, ActionId)
					VALUES (@ScreenActionId,@ScreenId, '1')	
					
				END	
					IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'MASS MAIL UPLOAD' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
							
						BEGIN
							SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '1')
							SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													        
							INSERT INTO RolePrivileges(RolePrivilegeId , RoleId , ScreenActionId, LastUpdatedBy ,LastUpdatedon)
							VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
						END
		END
		
		-- 7. FOR CHANGE PASSWORD
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'CHANGE PASSWORD' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
				BEGIN
					
					SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
					
					INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
					VALUES (@ScreenActionId, @ScreenId, '3')
					
				END
					IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'CHANGE PASSWORD' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
							
						BEGIN
							SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
							SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
															
							INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
							VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
						END		
		END
		
		-- 8. FOR RESET PASSWORD
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'RESET PASSWORD' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '3')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'RESET PASSWORD' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END									
		END
		
		-- 9. FOR WHATS NEW
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'WHATS NEW' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
			BEGIN
											
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '3')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'WHATS NEW' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END								
		END
		
		-- 10. FOR EDIT GRANT MASS UPLOAD
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'EDIT GRANT MASS UPLOAD' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'EDIT GRANT MASS UPLOAD' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END								
		END
		
		-- 11. FOR APPROVE EDIT GRANT MASSUPLOAD FOR APPROVE
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'APPROVE EDIT GRANT MASSUPLOAD' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '5')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '5')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'APPROVE EDIT GRANT MASSUPLOAD' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '5')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END							
		END
	
		-- 12. FOR APPROVE EDIT GRANT MASSUPLOAD FOR DISAPPROVE
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'APPROVE EDIT GRANT MASSUPLOAD' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '6')
			BEGIN
			
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '6')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'APPROVE EDIT GRANT MASSUPLOAD' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '6')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END						
		END
		
		-- 13. FOR EXCEPTION TO THE PERQUISITE TAX RULE MASS UPLOAD
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Exception to the Perquisite Tax Rule Mass Upload' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN
											
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'Exception to the Perquisite Tax Rule Mass Upload' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END				
		END
		
		-- 14. FOR FORM 10 F AND TRC STATUS UPDATE
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'FORM 10 F AND TRC STATUS UPDATE' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN
											
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'FORM 10 F AND TRC STATUS UPDATE' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END		
		END
		
		-- 15. FOR SEND DATA TO TRUST FOR CASHLESS - SELL ALL EXERCISE
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Send data to Trust for Cashless - sell all exercise' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN
	
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'Send data to Trust for Cashless - sell all exercise' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END
		END
		
		-- 16. FOR SEND CASH EXERCISED DATA
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Send Cash Exercised Data' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
			BEGIN
										
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '3')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'Send Cash Exercised Data' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END	
		END
		
		-- 17. FOR UPDATE SENT CASH EXERCISED MASSUPLOAD
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Update Sent Cash Exercised Massupload' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '3')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'Update Sent Cash Exercised Massupload' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END
		END
		
		-- 18. FOR EDIT EMPLOYEE PERSONAL DETAILS 
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Edit Employee Personal Details' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'Edit Employee Personal Details' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END					
		END
		
		-- 19. FOR EMPLOYEE TAXRATE MASSUPLOAD (PERQUISITE TAX)
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'EMPLOYEE TAXRATE MASSUPLOAD (PERQUISITE TAX)' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'EMPLOYEE TAXRATE MASSUPLOAD (PERQUISITE TAX)' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END		
		END
		
		-- 20. FOR EMPLOYEE TAXRATE MASSUPLOAD (PERQUISITE TAX)
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Employee CGT Rate MassUpload' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN

				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'Employee CGT Rate MassUpload' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END
		END
		
		--21. FOR MASSUPLOAD PAYROLLLOCATION
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Massupload PayrollLocation' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'Massupload PayrollLocation' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END	
		END
		
		-- 22. FOR EMPLOYEE TRAVEL INFORMATION
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Employee Travel Information' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN

				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'Employee Travel Information' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END
			
		END
		
		-- 23. FOR EMPLOYEE SEPARATION MASS UPLOAD
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Employee Separation Mass Upload' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '2')
				
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'Employee Separation Mass Upload' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '2')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges (RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END						
			
		END
		
		-- 24. FOR GRANT - REVERSAL
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Grant - Reversal' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '3')
			END
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'Grant - Reversal' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
					    SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END
		END
		
		-- 25. FOR EXERCISES - REVERSAL
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Exercises - Reversal' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '3')
			END	
				IF EXISTS (SELECT 1 FROM ScreenActions SA 
							INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
							INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
							WHERE UPPER(SM.Name )= 'Exercises - Reversal' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
					BEGIN
						SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
						SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
													
						INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
						VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
					END
		END
		
		-- 26. FOR PERFORMANCE BASED VESTING - REVERSAL
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'Performance Based Vesting - Reversal' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '3')
			
			END	
				
			IF EXISTS (SELECT 1 FROM ScreenActions SA 
						INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
						INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
						WHERE UPPER(SM.Name )= 'Performance Based Vesting - Reversal' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId))
			BEGIN
				
				SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId  AND ActionId = '3')
				SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
											
				INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
				VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
			END							
		END
		
		-- 27. FOR MAP HRMS REASONS FOR UPDATE
		BEGIN
			
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'MAP HRMS REASONS' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId  AND ActionId = '3')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '3')
			END	
			
			IF EXISTS (SELECT 1 FROM ScreenActions SA 
						INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
						INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
						WHERE UPPER(SM.Name )= 'MAP HRMS REASONS' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId)) 
			BEGIN
				
				SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId  AND ActionId = '3')
				SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0) + 1 FROM RolePrivileges)
				
				INSERT INTO RolePrivileges(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
				VALUES(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())							
			END									
		END
				
		-- 28. FOR MAP HRMS FIELDS/VALUES FOR UPDATE
		BEGIN
			SET @ScreenId = (SELECT ScreenId FROM ScreenMaster WHERE UPPER(Name) = 'MAP HRMS FIELDS/VALUES' AND UserTypeId = '2')
			IF NOT EXISTS (SELECT 1 FROM ScreenActions WHERE ScreenId = @ScreenId AND ActionId = '3')
			BEGIN
				
				SET @ScreenActionId = (SELECT ISNULL(MAX(ScreenActionId),0)+1 FROM ScreenActions)
				
				INSERT INTO ScreenActions (ScreenActionId, ScreenId, ActionId)
				VALUES (@ScreenActionId, @ScreenId, '3')
			END	
			
			IF EXISTS (SELECT 1 FROM ScreenActions SA 
						INNER JOIN ScreenMaster SM ON SA.ScreenId = SM.ScreenId
						INNER JOIN RolePrivileges RP ON  RP.ScreenActionId = SA.ScreenActionId
						WHERE UPPER(SM.Name )= 'MAP HRMS FIELDS/VALUES' AND SA.ActionId = '1' AND UPPER(RP.RoleId) = UPPER(@RoleId)) 
			BEGIN	
				
				SET @ScreenActionId = (SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = @ScreenId  AND ActionId = '3')			
				SET @RolePrivilegeId = (SELECT ISNULL(MAX(RolePrivilegeId),0)+1 FROM RolePrivileges)
				
				INSERT INTO RolePrivileges 
				(RolePrivilegeId, RoleId, ScreenActionId, LastUpdatedBy, LastUpdatedon)
				VALUES
				(@RolePrivilegeId, @RoleId , @ScreenActionId, 'admin', GETDATE())
			END									
		END		
END
GO
