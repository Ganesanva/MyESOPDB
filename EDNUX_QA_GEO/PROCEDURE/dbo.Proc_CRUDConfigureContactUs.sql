/****** Object:  StoredProcedure [dbo].[Proc_CRUDConfigureContactUs]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_CRUDConfigureContactUs]
GO
/****** Object:  StoredProcedure [dbo].[Proc_CRUDConfigureContactUs]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_CRUDConfigureContactUs]
	@Type        VARCHAR(50), 
    @Description VARCHAR(300), 
    @EmailId     VARCHAR(50), 
    @Id          INT     
AS 
  BEGIN 
      SET nocount ON; 

      DECLARE @Result        CHAR, 
              @ReturnMessage VARCHAR(200), 
			  @Message_commontext VARCHAR(200)='Common text is already set. Please delete existing to add new common text.',
			  @Message_Id VARCHAR(50)='Id does not exists.'
			  
      SET @ReturnMessage=NULL       
      
	IF @Type = 'ADD' 
		BEGIN 
			IF NOT EXISTS(SELECT 1 FROM ConfigureContactUs WHERE ([Description] = @Description) AND (EmailId = @EmailId)) 
				BEGIN
					IF(@EmailId IS NULL OR LEN(@EmailId) = 0) 
						BEGIN
							IF EXISTS(SELECT 1 from ConfigureContactUs WHERE EmailId IS NULL)
									SET @ReturnMessage = @Message_commontext
								ELSE
									BEGIN
										INSERT INTO ConfigureContactUs 
										([description], 
										emailid) 
										VALUES     (@Description, 
										@EmailId) 

										SET @Result='I' 
									END
						END
					ELSE
						IF EXISTS(SELECT 1 from ConfigureContactUs WHERE [Description] = @Description AND [Id] <> @Id)
								SET @ReturnMessage ='Record Already Exists'
						ELSE			 				 
							BEGIN	
								INSERT INTO ConfigureContactUs 
								([description], 
								emailid) 
								VALUES     (@Description, 
								@EmailId) 

								SET @Result='I' 
							END				
				END
			ELSE
					SET @ReturnMessage ='Record Already Exists'
		END		
	ELSE IF @Type = 'UPDATE' 
		BEGIN 
			IF NOT EXISTS(SELECT 1 FROM ConfigureContactUs WHERE ([Description] = @Description) AND (EmailId = @EmailId) AND ([Id] <> @Id)) 
				BEGIN
					IF(@EmailId IS NULL OR LEN(@EmailId) = 0)
						BEGIN
							IF EXISTS(SELECT 1 from ConfigureContactUs WHERE EmailId IS NULL AND [Id] <> @Id)
								SET @ReturnMessage = @Message_commontext
							ELSE
								BEGIN	
									UPDATE ConfigureContactUs SET [description] = @Description,emailid = @EmailId WHERE  id = @Id 
									IF (@@ROWCOUNT > 0 ) 
										SET @Result='U'             
									ELSE             
										SET @ReturnMessage = @Message_Id
								END     
						END
					ELSE
						IF EXISTS(SELECT 1 from ConfigureContactUs WHERE [Description] = @Description AND [Id] <> @Id)
								SET @ReturnMessage ='Record Already Exists'
						ELSE
							BEGIN	
								UPDATE ConfigureContactUs SET [description] = @Description,emailid = @EmailId WHERE  id = @Id 
								IF (@@ROWCOUNT > 0 ) 
									SET @Result='U'             
								ELSE             
									SET @ReturnMessage = @Message_Id
							END    
				END
			ELSE
						SET @ReturnMessage ='Record Already Exists'       
		END 
		ELSE IF @Type = 'DELETE' 
			BEGIN 
				DELETE FROM ConfigureContactUs WHERE  id = @ID 

				IF (@@ROWCOUNT > 0)               
					SET @Result='D'               
				ELSE              
					SET @ReturnMessage=@Message_Id

			END
			
	SELECT @Result AS Result,@ReturnMessage AS ReturnMessage  
END
GO
