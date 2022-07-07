/****** Object:  StoredProcedure [dbo].[PROC_OUTPUT_DATA_FILE_EXCHANGE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_OUTPUT_DATA_FILE_EXCHANGE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_OUTPUT_DATA_FILE_EXCHANGE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_OUTPUT_DATA_FILE_EXCHANGE]
(
	 @FILESRNO VARCHAR(20)= NULL,
	 @DATATYPE NVARCHAR(50)= NULL, 
	 @FILENAME NVARCHAR(250)= NULL,
	 @FILENAMEWITHDATESTAMP NVARCHAR(500)=NULL, 
	 @FILEUPLOADEDDATE DATETIME= NULL, 
	 @FILEPATH NVARCHAR(1000)= NULL, 
	 @CREATED_BY NVARCHAR(100)=  NULL,
	 @UPDATED_BY NVARCHAR(100)=  NULL, 
	 @ACTION CHAR(1) 
)
AS	   
BEGIN
	
	SET NOCOUNT ON;

	IF(UPPER(@ACTION)='A')
	BEGIN				
		INSERT INTO OUTPUT_DATA_EXCHANGE (DATATYPE , [FILENAME] ,FILENAMEWITHDATESTAMP , FILEUPLOADEDDATE,  FILEPATH , CREATED_BY,CREATED_ON ,UPDATED_BY,UPDATED_ON )
		VALUES(@DATATYPE , @FILENAME ,@FILENAMEWITHDATESTAMP , @FILEUPLOADEDDATE,  @FILEPATH , @CREATED_BY,GETDATE() ,@UPDATED_BY,GETDATE() ) 
		
	END		
	ELSE IF(UPPER(@ACTION)='R')
	BEGIN
		SELECT  
			FILESRNO,REPLACE(CONVERT(NVARCHAR,CAST(FILEUPLOADEDDATE AS DATETIME), 106), ' ', '/') AS [DATE],LTRIM(RIGHT(CONVERT(VARCHAR(20), FILEUPLOADEDDATE, 100),7)) AS [TIME],[FILENAME],UPDATED_BY,  FILEPATH 
		FROM 
			OUTPUT_DATA_EXCHANGE  
		WHERE 
			DATATYPE =@DATATYPE AND FILEUPLOADEDDATE >= DATEADD(DAY, -60, GETDATE()) ORDER BY FILEUPLOADEDDATE DESC;						
	END
	ELSE IF(UPPER(@ACTION)='D')
	BEGIN
		DELETE FROM OUTPUT_DATA_EXCHANGE WHERE FILESRNO=@FILESRNO 			
	END
		
END
GO
