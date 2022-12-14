/****** Object:  StoredProcedure [dbo].[PROC_SaveExerciseWindowCloseMassUpload]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SaveExerciseWindowCloseMassUpload]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SaveExerciseWindowCloseMassUpload]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SaveExerciseWindowCloseMassUpload]    
   (
      @WindowCloseDtls ExerciseWindowCloseMassUploadType READONLY,
      @Value Int Output
   )
   
AS    
BEGIN    
   SET NOCOUNT ON    
   Declare @Count int = 0,
		   @IsValid BIT = 1
   --CREATE APPLICATIONSUPPORT TABLE STRUCTURE
    IF (OBJECT_ID('ApplicationSupport','U')) IS NOT NULL
    BEGIN
		SELECT * INTO #TEMP FROM ApplicationSupport WHERE 1 = 2		
	END 
   BEGIN TRY 
   --PRINT 'Enter in try block'		
	   INSERT INTO #TEMP(FromDate,ToDate,Cash,ISIN,ISNonTradingDay)
	   --SELECT CONVERT(VARCHAR(19),FromDate + DATEPART(HOUR,FromTime)+ DATEPART(MINUTE,FromTime)),CONVERT(VARCHAR(19),ToDate + DATEPART(HOUR,ToTime)+ DATEPART(MINUTE,ToTime)),
	   --SELECT CONVERT(VARCHAR(19), CAST( CONCAT(CAST(FromDate AS DATE),' ',  CAST(FromTime AS TIME(0)) ) AS DATETIME)),
       --CONVERT(VARCHAR(19), CAST( CONCAT(CAST(ToDate AS DATE),' ',  CAST(ToTime AS TIME(0)) ) AS DATETIME)),
		SELECT CONVERT(VARCHAR(19), CONCAT(CAST(FromDate AS DATE),' ',  CAST(FromTime AS TIME(0)) )),
       CONVERT(VARCHAR(19), CONCAT(CAST(ToDate AS DATE),' ',  CAST(ToTime AS TIME(0)) )),
	 
	   'Cash',NULL,ISNonTradingDay FROM @WindowCloseDtls 
   END TRY
   BEGIN CATCH
    SET @IsValid = 0
	SELECT '1' [ID],@IsValid [IsError],@Count [Records],'Error while performing massupload' [Message],@@ERROR [SQLMessage]
   END CATCH
           
   SELECT @Count = (SELECT Count(1) FROM @WindowCloseDtls), @Value = (SELECT COUNT(1) FROM  #TEMP)
   IF(@Value = @Count)
	   BEGIN
	   SET @IsValid=0
		-- Insert into final table
			--TRUNCATE TABLE ApplicationSupport
			DELETE FROM ApplicationSupport
			INSERT INTO ApplicationSupport SELECT FromDate,ToDate,'CASH',NULL,ISNonTradingDay FROM #TEMP
		SELECT 1 [ID],@IsValid [IsError],@Count [Records],'Data Uploaded successfully' [Remark],NULL [SQLMessage]
	   END
   ELSE
	   BEGIN
	   SET @IsValid=1
		 SELECT '1' [ID],@IsValid[IsError],@Count [Records],'Error while performing massupload' [Remark],NULL [SQLMessage]
	   END
END
GO
