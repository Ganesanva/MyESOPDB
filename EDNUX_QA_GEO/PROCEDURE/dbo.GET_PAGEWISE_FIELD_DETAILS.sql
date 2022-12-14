/****** Object:  StoredProcedure [dbo].[GET_PAGEWISE_FIELD_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_PAGEWISE_FIELD_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[GET_PAGEWISE_FIELD_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GET_PAGEWISE_FIELD_DETAILS]    
( 
 @PageName    VARCHAR(150) = NULL,
 @PageNameId  VARCHAR(50) = NULL
)    
AS    
BEGIN
   
      IF(@PageName ='ReadPageName')
	  BEGIN
			SELECT MS_Id, PageName, IsActive FROM MST_SERVICES WHERE ISNULL(IsActive,0)=1
	  END
	  ELSE IF(@PageName ='ReadFieldName' AND ISNULL(@PageNameId,'') <> '')
	  BEGIN
			SELECT MFM_Id, FieldName, IsActive FROM MST_FIELD_MASTER WHERE MS_Id = CONVERT(BIGINT, @PageNameId) AND ISNULL(IsActive,0)=1
	  END
	  ELSE IF(@PageName ='ReadFieldName')
	  BEGIN
			SELECT MFM_Id, FieldName, IsActive FROM MST_FIELD_MASTER WHERE ISNULL(IsActive,0)=1
	  END	  
	  ELSE IF(@PageName ='ReadFieldConfig')
	  BEGIN
			SELECT MFSM.MFSM_Id, MS.PageName, MFM.FieldName, CASE WHEN ISNULL(MFSM.DisplayFieldName,'')='' THEN MFM.FieldName ELSE MFSM.DisplayFieldName END AS DisplayFieldName, MFSM.MappedFieldName,
					 MFSM.FieldSequenceNo, MFSM.Descriptions, MFSM.isActive 
			FROM MST_FIELD_SERVICE_MAPPING MFSM 
			INNER JOIN MST_FIELD_MASTER MFM ON MFSM.MFM_Id = MFM.MFM_Id
			INNER JOIN  MST_SERVICES MS ON MFSM.MS_Id = MS.MS_Id
			ORDER BY MS.PageName, MFSM.FieldSequenceNo
	  END
	  ELSE
      BEGIN
			SELECT MFSM.MFSM_Id, MS.PageName, MFM.FieldName, CASE WHEN ISNULL(MFSM.DisplayFieldName,'')='' THEN MFM.FieldName ELSE MFSM.DisplayFieldName END AS DisplayFieldName, MFSM.MappedFieldName,
					 MFSM.FieldSequenceNo, MFSM.Descriptions, MFSM.isActive 
			FROM MST_FIELD_SERVICE_MAPPING MFSM 
			INNER JOIN MST_FIELD_MASTER MFM ON MFSM.MFM_Id = MFM.MFM_Id
			INNER JOIN  MST_SERVICES MS ON MFSM.MS_Id = MS.MS_Id
			WHERE MS.PageName = @PAGENAME
			ORDER BY MS.PageName, MFSM.FieldSequenceNo
	  END
END
GO
