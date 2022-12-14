/****** Object:  UserDefinedFunction [dbo].[FN_GET_COMPANYMAILSETTINGS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_GET_COMPANYMAILSETTINGS]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_COMPANYMAILSETTINGS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GET_COMPANYMAILSETTINGS]
(
      @EmplStatus VARCHAR (500),
	  @EMPLOYEEID varchar(500)
)
RETURNS NVARCHAR(500)


AS      
BEGIN
  DECLARE
	     @IsSecondaryEmailIDForLive BIT,  
         @IsPrimaryEmailIDForLive BIT,  
         @IsPrimaryEmailIDForSep BIT,  
         @IsSecondaryEmailIDForSep BIT,  
		 @EmailID NVARCHAR(500),
         @primaryMail Nvarchar(500),  
        @SecondaryMail Nvarchar(500)
    
		SELECT @IsPrimaryEmailIDForLive = IsPrimaryEmailIDForLive,@IsSecondaryEmailIDForLive  = IsSecondaryEmailIDForLive,
		@IsPrimaryEmailIDForSep = IsPrimaryEmailIDForSep,@IsSecondaryEmailIDForSep = IsSecondaryEmailIDForSep FROM CompanyParameters  
       
	   SELECT @primaryMail = EmployeeEmail, @SecondaryMail=SecondaryEmailID FROM EmployeeMaster WHERE EmployeeID = @EmployeeID

	 
IF(@EmplStatus = 'L')
BEGIN
	 IF(@IsPrimaryEmailIDForLive = 1 and  @IsSecondaryEmailIDForLive = 1)  
	 BEGIN  
	
	   SET @EmailID =  CASE WHEN @SecondaryMail IS NULL THEN @primaryMail
		 ELSE
			@primaryMail +',' + @SecondaryMail  
		 END
	 
	 END  
	 ELSE IF(@IsSecondaryEmailIDForLive = 1 and @IsPrimaryEmailIDForLive = 0)  
	 BEGIN  
  
	   SET @EmailID =  @SecondaryMail  
	 END  
	 ELSE  IF(@IsSecondaryEmailIDForLive = 0 and @IsPrimaryEmailIDForLive = 1)  
	 BEGIN  
	   SET @EmailID = @primaryMail   
	 END  
	 ELSE
	 BEGIN
	    SET @EmailID = @primaryMail 
	 END
END  
 ELSE IF(@EmplStatus = 'S')
BEGIN
	 IF(@IsPrimaryEmailIDForSep = 1 and  @IsSecondaryEmailIDForSep = 1)  
	 BEGIN  
		 SET @EmailID =  CASE WHEN @SecondaryMail IS NULL THEN @primaryMail
		 ELSE
			@primaryMail +',' + @SecondaryMail  
	  END

	 END  
	 ELSE IF(@IsSecondaryEmailIDForSep = 1 and @IsPrimaryEmailIDForSep = 0)  
	 BEGIN    
	   SET @EmailID =  @SecondaryMail  

	 END  
	 ELSE  IF(@IsSecondaryEmailIDForSep = 0 and @IsPrimaryEmailIDForSep = 1)  
	 BEGIN  
	   SET @EmailID = @primaryMail   
	 END  
	 ELSE
	 BEGIN
	    SET @EmailID = @primaryMail 
	 END
 END  



  RETURN @EmailID
  
END
GO
