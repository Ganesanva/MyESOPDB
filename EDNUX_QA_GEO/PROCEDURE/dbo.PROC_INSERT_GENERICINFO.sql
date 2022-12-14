/****** Object:  StoredProcedure [dbo].[PROC_INSERT_GENERICINFO]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_GENERICINFO]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_GENERICINFO]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_INSERT_GENERICINFO]
 @Place NVARCHAR(500)=NULL,
 @KindOfSecurity NVARCHAR(500)=NULL,
 @ISINNumber NVARCHAR(500)=NULL,
 @AuthourizedSignName NVARCHAR(500)=NULL,
 @AuthorizedSingDesig NVARCHAR(500)=NULL,
 @TelephoneNo NVARCHAR(500)=NULL,
 @FaxNumber NVARCHAR(500)=NULL,
 @EmailID NVARCHAR(500)=NULL,
 @CreatedBy VARCHAR(100),
 @Result INT OUT
AS  
BEGIN
    SET @Result=0
    IF NOT EXISTS (SELECT 1 FROM ListingDocGenericInfo)
    BEGIN
		INSERT INTO ListingDocGenericInfo(Place,KindOfSecurity,ISINNumber,AuthourizedSignName,AuthorizedSingDesig,TelephoneNo,
											FaxNumber,EmailID,CreatedBy,CreatedOn)
								VALUES	(@Place,@KindOfSecurity,@ISINNumber,@AuthourizedSignName,@AuthorizedSingDesig,@TelephoneNo,
											@FaxNumber,@EmailID,@CreatedBy,GETDATE())
											SET @Result=1
    END
    ELSE 
    BEGIN
       UPDATE ListingDocGenericInfo 
				SET Place=@Place,KindOfSecurity=@KindOfSecurity,ISINNumber=@ISINNumber,AuthourizedSignName=@AuthourizedSignName,
					AuthorizedSingDesig=@AuthorizedSingDesig,TelephoneNo=@TelephoneNo,FaxNumber=@FaxNumber,EmailID=@EmailID,
					ModifiedBy=@CreatedBy,ModifiedOn=GETDATE()
		SET @Result=1
    END
	
	
END
GO
