/****** Object:  StoredProcedure [dbo].[PROC_UpdateGrantAccLetterStatus]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateGrantAccLetterStatus]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateGrantAccLetterStatus]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_UpdateGrantAccLetterStatus]
(
	@EmployeeID VARCHAR(15),
	@LetterAcceptanceStatus CHAR(1),
	@GAMUID INT
)
AS
BEGIN  
 SET NOCOUNT ON;  
  
 DECLARE @TEMPLATE_NAME VARCHAR(50)  
 DECLARE @Company_NAME NVARCHAR(50)  
 DECLARE @ROWCOUNT INT  
 SELECT TOP 1 @TEMPLATE_NAME= TEMPLATE_NAME FROM GENERATE_GRANT_LETTER WHERE GAMUID=@GAMUID ORDER BY GRANTLETTER_ID DESC  
 SELECT  @Company_NAME=CompanyID FROM CompanyMaster  
   
 Set @EmployeeID=(Select Employeeid From EmployeeMaster Where LoginID=@EmployeeID And Deleted=0)  
 UPDATE GrantAccMassUpload   
 SET   
  LetterAcceptanceStatus = @LetterAcceptanceStatus,   
  LetterAcceptanceDate = GETDATE(),   
  LastUpdatedOn = GETDATE(),   
  TEMPLATE_NAME = @TEMPLATE_NAME,  
  LastUpdatedBy = @EmployeeID   
 WHERE   
  GAMUID = @GAMUID AND   
  EmployeeID = @EmployeeID  
 SET @ROWCOUNT=@@ROWCOUNT  
 Declare @IsReGeneration Int  
 IF(UPPER( @Company_NAME)='EMBASSY')  
 SET @IsReGeneration=1  
   
 IF(@IsReGeneration = 1)  
 BEGIN  
  
     INSERT INTO GENERATE_GRANT_LETTER(TEMPLATE_NAME,GAMUID,ACTION,ISPROCESSD,CREATED_BY,CREATED_ON,UPDATED_BY,UPDATED_ON)  
  SELECT TEMPLATE_NAME,GAMUID,3 AS ACTION,0 AS ISPROCESSD,@EmployeeID AS CREATED_ON,GETDATE(),'ADMIN' AS UPDATED_BY,GETDATE()  
  FROM GrantAccMassUpload WHERE GAMUID = @GAMUID  AND EmployeeID=@EmployeeID  
  SET @ROWCOUNT=@@ROWCOUNT  
 END  
    
 IF (@ROWCOUNT > 0)  
 BEGIN  
  RETURN 1  
 END  
   
 ELSE  
 BEGIN  
  RETURN 0  
 END  
--SET NOCOUNT OFF;
END
GO
