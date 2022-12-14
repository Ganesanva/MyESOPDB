/****** Object:  StoredProcedure [dbo].[PROC_SAVE_EMP_DocumentUploadMaster]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SAVE_EMP_DocumentUploadMaster]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SAVE_EMP_DocumentUploadMaster]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SAVE_EMP_DocumentUploadMaster]
@MST_Document_Upload_Master_Details_type MST_Document_Upload_Master_Details_type READONLY,
@DocumentType VARCHAR(100),
@IsazureUpload BIT

AS
BEGIN

	DECLARE  @MDUM_ID int
	SET @MDUM_ID =(SELECT MDUM_ID FROM MST_DOCUMENT_UPLOAD_MASTER WHERE DOCUMENT_NAME=@DocumentType)

	CREATE TABLE #tblUpload_Master_Details
    (
    LoginId  VARCHAR(500), 
    FilePath NVARCHAR(500)
	)

	CREATE TABLE #tblUpload_Master_Details_Update
    (
    LoginId  VARCHAR(500), 
    FilePath NVARCHAR(500)
	)

	CREATE TABLE #tblUpload_Master_Details_Insert
    (
    LoginId  VARCHAR(500), 
    FilePath NVARCHAR(500)
	)

	---Insert For All Record
	INSERT INTO #tblUpload_Master_Details SELECT * FROM @MST_Document_Upload_Master_Details_type

	--Insert only Existing Record for update 
	INSERT INTO #tblUpload_Master_Details_Update	SELECT LoginId, tblM.FilePath 
	FROM #tblUpload_Master_Details tblM
	INNER JOIN MST_Document_Upload_Master_Details M
	ON M.EmployeeID=tblM.LoginId and M.MDUM_ID=@MDUM_ID 

	UPDATE  A
	SET A.FilePath =  B.FilePath,UPDATED_BY='Admin',A.IsOnCloud=@IsazureUpload, UPDATED_ON=GETDATE()
	FROM MST_Document_Upload_Master_Details A INNER JOIN #tblUpload_Master_Details_Update B
	ON B.LoginId = A.EmployeeID and  A.MDUM_ID=@MDUM_ID 


	--Insert only New Record
	INSERT INTO #tblUpload_Master_Details_Insert	SELECT tblM.LoginId, tblM.FilePath 
	FROM #tblUpload_Master_Details tblM
	where  tblM.LoginId not in (SELECT  M.LoginId FROM #tblUpload_Master_Details_Update M)

    INSERT INTO MST_Document_Upload_Master_Details
    SELECT @MDUM_ID,Null,1,GETDATE(),LoginId,'Admin',GETDATE(),'Admin',GETDATE(),@IsazureUpload, #tblUpload_Master_Details_Insert.FilePath FROM #tblUpload_Master_Details_Insert

	DROP TABLE #tblUpload_Master_Details
	DROP TABLE #tblUpload_Master_Details_Insert
	DROP TABLE #tblUpload_Master_Details_Update

END



GO
