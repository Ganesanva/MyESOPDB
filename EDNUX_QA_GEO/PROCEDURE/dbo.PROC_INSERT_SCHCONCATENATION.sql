/****** Object:  StoredProcedure [dbo].[PROC_INSERT_SCHCONCATENATION]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_SCHCONCATENATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_SCHCONCATENATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_INSERT_SCHCONCATENATION]
 @TblSchConcate dbo.SchConcatenationType READONLY,
 @CreatedBy VARCHAR(100),
 @Result INT OUT
AS  
BEGIN
 SET @Result=0
 IF EXISTS (SELECT 1 FROM ListingDocSchConcatenation)
 BEGIN
   DELETE FROM ListingDocSchConcatenation
 END
 IF EXISTS (SELECT 1 FROM @TblSchConcate)
 BEGIN
	 INSERT INTO ListingDocSchConcatenation(SchemeID,UniqueCode,Name,CreatedBy,CreatedOn)
	   SELECT SchemeId,UniqueCode,Name,@CreatedBy,GETDATE() FROM @TblSchConcate WHERE DeleteStatus=0
 END  
SET @Result=1
	
END
GO
