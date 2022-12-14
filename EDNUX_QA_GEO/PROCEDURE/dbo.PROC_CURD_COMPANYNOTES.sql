/****** Object:  StoredProcedure [dbo].[PROC_CURD_COMPANYNOTES]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CURD_COMPANYNOTES]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CURD_COMPANYNOTES]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CURD_COMPANYNOTES] 
(
    @PageName              NVARCHAR(500)=NULL,
	@SectionName           NVARCHAR(500)=NULL,
	@Note                  NVARCHAR(MAX)=NULL,
	@UserTypeID            INT =NULL,
	@LastUpdatedBy         NVARCHAR(200)=NULL,
	@LastUpdatedOn         DATETIME =NULL,
	@MIT_ID		           INT =NULL,
	@SCHEME_ID             VARCHAR(50)=NULL,
	@GRANT_REGISTRATION_ID VARCHAR(20)=NULL,
	@MESSAGETITLE		   VARCHAR(200)=NULL,
	@DISPLAYMESSAGEON      VARCHAR(200)=NULL,
	@DISPLAYFROMDATE       DATETIME=NULL,
	@SRNO                  INT=NULL,
	@ACTION                CHAR(1)
)	
AS
BEGIN
     IF @Action = 'C'
	 BEGIN 
			INSERT INTO CompanyNotes(PageName,SectionName,Note,UserTypeID,LastUpdatedBy,LastUpdatedOn,MIT_ID,SCHEME_ID,GRANT_REGISTRATION_ID,MESSAGETITLE,DISPLAYMESSAGEON,DISPLAYFROMDATE,SRNO)
			VALUES(@PageName,@SectionName,@Note,@UserTypeID,@LastUpdatedBy,@LastUpdatedOn,@MIT_ID,@SCHEME_ID,@GRANT_REGISTRATION_ID,@MESSAGETITLE,@DISPLAYMESSAGEON,@DISPLAYFROMDATE,@SRNO)
	END
	ELSE IF @Action = 'R'
	BEGIN	 		
	   SELECT t1.SRNO, t1.MESSAGETITLE,
			DISPLAYMESSAGEON=STUFF  
			(  
			     (  
			       SELECT DISTINCT ', ' + CN.DISPLAYMESSAGEON 
			       FROM CompanyNotes CN    
			       WHERE CN.SCHEME_ID = t1.SCHEME_ID  AND CN.SRNO = t1.SRNO
			       FOR XML PATH('')  
			     ),1,1,''  
			),   
			GRANT_REGISTRATION_ID=
			
			STUFF  
			(  
			     (  
				   
			       SELECT DISTINCT ', ' + CN.GRANT_REGISTRATION_ID 
			       FROM CompanyNotes CN    
			       WHERE CN.SCHEME_ID = t1.SCHEME_ID AND CN.SRNO = t1.SRNO  
			       FOR XML PATH('')  
			     ),1,1,''  
			),
		t1.SCHEME_ID,t1.DISPLAYFROMDATE, t1.LastUpdatedBy ,t1.Note  
		FROM CompanyNotes t1  Where MESSAGETITLE IS NOT NULL
		GROUP BY MESSAGETITLE ,SCHEME_ID,DISPLAYFROMDATE,LastUpdatedBy,t1.Note,SRNO 
		
		
	END
	ELSE IF @Action = 'D'
	BEGIN
		DELETE FROM CompanyNotes 
		WHERE SRNO=@SRNO
	END
END
GO
