/****** Object:  StoredProcedure [dbo].[PROC_SSOCONFIG_SAVE_UPDATE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SSOCONFIG_SAVE_UPDATE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SSOCONFIG_SAVE_UPDATE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SSOCONFIG_SAVE_UPDATE]
@SSOID int,
@InsertionType nvarchar(50),
@CompanyName nvarchar(50),
@IDP_OR_SP_URL nvarchar(1000),
@Destination nvarchar(1000),
@AssertionConsumerServiceURL nvarchar(1000),
@Issuer  nvarchar(1000),
@RelayState nvarchar(1000),
@CertificateName nvarchar(200),
@Certificate nvarchar(max),
@Parameters NVARCHAR(1000),
@Status nvarchar(10),
@IsActiveForEmployee bit,
@IsActiveForCR bit,
@Message NVARCHAR(100) OUT

AS
BEGIN
	DECLARE @GroupID int
	DECLARE @GroupName NVARCHAR(100)
	SET NOCOUNT ON;
		SET @GroupID=NULL;
		SET @GroupName=NULL;
			SELECT @GroupID=GroupID, @GroupName=GroupName FROM dbo.GroupCompanies Where CompanyID=@CompanyName
   IF(@SSOID=0)
		IF EXISTS (SELECT * FROM [dbo].[SSOConfiguration] WHERE [CompanyName] =@CompanyName AND [Status]='True') 
		BEGIN
		  SET @Message='Company Name Already Exist.';
		END
		ELSE
		BEGIN
				
				INSERT INTO [dbo].[SSOConfiguration] ([GroupID],[GroupName], [CompanyName], [InsertionType], [IDP_SP_URL], [DestinationURL], [AssertionConsumerServiceURL],[IssuerURL],[RelayState],[CertificateName],[Certificate], [Parameters], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Status], [IsSSOLoginActiveForEmp], [IsSSOLoginActiveForCR] )
				VALUES(@GroupID, @GroupName, @CompanyName, @InsertionType, @IDP_OR_SP_URL,@Destination, @AssertionConsumerServiceURL, @Issuer, @RelayState,@CertificateName, @Certificate, @Parameters, 'Admin', GETDATE(), 'Admin', GETDATE(), @Status, @IsActiveForEmployee, @IsActiveForCR);
				SET @Message='Saved';
			
		END

	ELSE IF(@SSOID > 0 AND @Status='True')
	    IF EXISTS (SELECT * FROM [dbo].[SSOConfiguration] WHERE [CompanyName] =@CompanyName AND [Status]='True' AND SSOId <> @SSOID ) 
			BEGIN
			  SET @Message='Company Name Already Exist.';
			END
		ELSE
			BEGIN
			UPDATE [dbo].[SSOConfiguration] SET [GroupID]=@GroupID, [GroupName]=@GroupName, [CompanyName]=@CompanyName, [InsertionType]=@InsertionType, [IDP_SP_URL]=@IDP_OR_SP_URL, [DestinationURL]=@Destination, 
			[AssertionConsumerServiceURL]=@AssertionConsumerServiceURL,[IssuerURL]=@Issuer,[RelayState]=@RelayState,[CertificateName]=@CertificateName,[Certificate]=@Certificate, [Parameters]=@Parameters, [UpdatedBy]='Admin', [UpdatedDate]=GETDATE(), [Status]=@Status,  [IsSSOLoginActiveForEmp]=@IsActiveForEmployee, [IsSSOLoginActiveForCR]=@IsActiveForCR
			WHERE SSOId=@SSOID
			SET @Message ='Updated'
			END
	ELSE IF(@SSOID > 0 AND @Status='False')
		BEGIN
		 UPDATE [dbo].[SSOConfiguration] SET [UpdatedBy]='Admin', [UpdatedDate]=GETDATE(), [Status]=@Status WHERE SSOId=@SSOID
		 SET @Message ='Deleted'
		END
   ELSE
	   BEGIN
			SET @Message = 'Action is not performed'
		  END
		  IF @@ERROR <> 0
			BEGIN
		    SET @Message = 'Some error found while action performed'
		END

END
GO
