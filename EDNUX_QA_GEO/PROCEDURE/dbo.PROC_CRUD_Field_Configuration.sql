/****** Object:  StoredProcedure [dbo].[PROC_CRUD_Field_Configuration]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_Field_Configuration]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_Field_Configuration]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUD_Field_Configuration]    
( 
 @UserId            NVARCHAR(100) ,
 @PageName			NVARCHAR(150) NULL,
 @FieldName			NVARCHAR(150) NULL,
 @DisplayFieldName	NVARCHAR(200) NULL,
 @MappedFieldName	NVARCHAR(150) NULL,
 @SequenceNo		NVARCHAR(100) NULL,
 @IsActive			BIT			  NULL,
 @Description       NVARCHAR(500) NULL,
 @Action		    NVARCHAR(100) NULL,
 @SrNo              NVARCHAR(100) NULL
)    
AS    
BEGIN
    
      IF(@Action ='AddPageName')
	  BEGIN
	       IF NOT EXISTS( SELECT PageName FROM MST_SERVICES WHERE UPPER(PageName)= UPPER(@PageName))
		   BEGIN
			INSERT INTO MST_SERVICES (PageName, IsActive, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON)
			VALUES(@PageName, 1, @UserId, GetDate(), Null, Null)
				IF(@@Rowcount>0)
				BEGIN
					SELECT 1
				END
		   END 
	  END
	  IF(@Action ='AddFieldName')
	  BEGIN
	       IF NOT EXISTS( SELECT FieldName FROM MST_FIELD_MASTER WHERE UPPER(FieldName)= UPPER(@FieldName))
		   BEGIN
			INSERT INTO MST_FIELD_MASTER (FieldName, IsActive, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON)
			VALUES(@FieldName, 1, @UserId, GetDate(), Null, Null)
				IF(@@Rowcount>0)
				BEGIN
					SELECT 1
				END
		    END
	  END
	  IF(@Action ='AddFieldConfig')
	  BEGIN   
		   IF NOT EXISTS( SELECT MFM_Id FROM MST_FIELD_SERVICE_MAPPING WHERE MS_Id = Convert(BIGINT,@PageName) AND MFM_Id = Convert(BIGINT,@FieldName))
		   BEGIN  
				Insert into MST_FIELD_SERVICE_MAPPING (MS_Id, MFM_Id, DisplayFieldName, MappedFieldName, FieldSequenceNo, Descriptions, IsActive, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON)
				values(Convert(BIGINT,@PageName), Convert(BIGINT,@FieldName) , @DisplayFieldName, @MappedFieldName, @SequenceNo, @Description,1, @UserId, GetDate(), NULL, NULL)
           		IF(@@Rowcount>0)
				BEGIN
					SELECT 1
				END
		   END 		
		   ELSE
		   BEGIN
		       SELECT 2
		   END  		
	  END
	  IF(@Action ='UpdateFieldConfig')
	  BEGIN   
		   IF EXISTS( SELECT MappedFieldName FROM MST_FIELD_SERVICE_MAPPING WHERE MFSM_Id= @SrNo)
		   BEGIN 
			IF EXISTS( SELECT MappedFieldName  FROM MST_FIELD_SERVICE_MAPPING WHERE MS_Id = Convert(BIGINT,@PageName) AND MFM_Id = Convert(BIGINT,@FieldName) AND MFSM_Id <> @SrNo)
			BEGIN
			    SELECT 2
			END
			ELSE
			BEGIN
		             UPDATE MST_FIELD_SERVICE_MAPPING 
			     SET MS_Id = Convert(BIGINT,@PageName), MFM_Id = Convert(BIGINT,@FieldName), DisplayFieldName = @DisplayFieldName, MappedFieldName = @MappedFieldName, 
				FieldSequenceNo = @SequenceNo, Descriptions = @Description, IsActive = @IsActive, UPDATED_BY = @UserId, UPDATED_ON = GetDate()
			     WHERE MFSM_Id = Convert(BIGINT,@SrNo)
	          	     IF(@@Rowcount>0)
				BEGIN
					SELECT 1
				END
		        END 		
	             END
	  END
	  IF(@Action ='DeleteFieldConfig')
	  BEGIN   
		   IF EXISTS( SELECT MappedFieldName FROM MST_FIELD_SERVICE_MAPPING WHERE MFSM_Id= @SrNo)
		   BEGIN 
		    DELETE FROM MST_FIELD_SERVICE_MAPPING WHERE MFSM_Id = Convert(BIGINT,@SrNo)
			
	          	IF(@@Rowcount>0)
				BEGIN
					SELECT 1
				END
		   END 		
	  END
END
GO
