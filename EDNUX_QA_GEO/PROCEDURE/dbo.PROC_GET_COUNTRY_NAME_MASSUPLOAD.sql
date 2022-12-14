/****** Object:  StoredProcedure [dbo].[PROC_GET_COUNTRY_NAME_MASSUPLOAD]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_COUNTRY_NAME_MASSUPLOAD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_COUNTRY_NAME_MASSUPLOAD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GET_COUNTRY_NAME_MASSUPLOAD] 
	@CountryName NVARCHAR (100) = NULL,
	@StateName	 NVARCHAR (100) = NULL

AS
BEGIN
   DECLARE @RetCountry nvarchar(200)
   DECLARE @RetState nvarchar(200)
   
	IF EXISTS ( SELECT 1 FROM CountryMaster WHERE IsSelected = 1)
			BEGIN
				IF NOT EXISTS(SELECT ID AS CountryID FROM CountryMaster WHERE CountryName=@CountryName AND IsSelected='1')
					BEGIN
						SET @RetCountry = '0'
					END
				ELSE
				
					BEGIN
						--SELECT ID AS CountryID FROM CountryMaster WHERE CountryName=@CountryName AND IsSelected='1'
						SELECT @RetCountry = ID  FROM CountryMaster WHERE CountryName=@CountryName AND IsSelected='1'
						IF NOT EXISTS(SELECT MS_ID AS StateID FROM MST_STATES WHERE STATE_NAME = @StateName)
							BEGIN
								SET @RetState = '0' 
							END
						ELSE
				
					BEGIN
						--SELECT MS_ID AS StateID FROM MST_STATES WHERE STATE_NAME = @StateName
						SELECT @RetState= MS_ID  FROM MST_STATES WHERE STATE_NAME = @StateName
					END
							
												   
					END
		END
	ELSE
	        BEGIN
				SELECT '0' AS CountryID
				return 1
	        END
     
	/* print @RetState
	print @RetCountry
	*/
	select @CountryName As CountryName, @RetCountry AS CountryID, @RetState AS StateID, @StateName as StateName
END
GO
