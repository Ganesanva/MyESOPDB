/****** Object:  StoredProcedure [dbo].[PROC_GET_OGA_GRANTDETAILSTATUS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_OGA_GRANTDETAILSTATUS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_OGA_GRANTDETAILSTATUS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_OGA_GRANTDETAILSTATUS]
	@EmployeeId varchar(50),
	@PageName Char(1) = null
AS
BEGIN
  DECLARE @IS_EGRANTS_ENABLED char(1),
          @IS_GRANTDETWITHOUTACCORREJ char(1),
          @IS_GRANTDETONLYAFTERACC char(1),
          @IS_GRANTDETIFACCORREJ char(1),
          @IS_GRANTDETDISEXENOWIFNOTACC char(1)

  -- ***************Resolved Issue for Association EmployeeID **********
  SET @EmployeeId=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@EmployeeID AND Deleted=0)

  SET @IS_EGRANTS_ENABLED = (SELECT IS_EGRANTS_ENABLED FROM CompanyMaster)
  
  IF (@IS_EGRANTS_ENABLED = 1)
  BEGIN
    -- a.Show grant details only after acceptance
    SET @IS_GRANTDETONLYAFTERACC = (SELECT  IS_GRANTDETONLYAFTERACC FROM OGACONDGRANTVIEWSETTINGS)
   
    IF (@IS_GRANTDETONLYAFTERACC = 1)
    BEGIN
		 SELECT *, 'N' As CheckDisableFlag FROM [dbo].[GrantAccMassUpload] WHERE EmployeeID = @EmployeeId AND LetterAcceptanceStatus = 'A'      
    END

    --b. Show grant details without acceptance/rejection 
    SET @IS_GRANTDETWITHOUTACCORREJ = (SELECT IS_GRANTDETWITHOUTACCORREJ FROM OGACONDGRANTVIEWSETTINGS)
   
    IF (@IS_GRANTDETWITHOUTACCORREJ = 1)
    BEGIN
      SELECT *, 'N' As CheckDisableFlag FROM [dbo].[GrantAccMassUpload] WHERE  EmployeeID = @EmployeeId-- AND IsGlGenerated=1 AND MailSentStatus=1
    END

    --C.Show grant details if accepted/rejected 
    SET @IS_GRANTDETIFACCORREJ = (SELECT IS_GRANTDETIFACCORREJ FROM OGACONDGRANTVIEWSETTINGS)
    
    IF (@IS_GRANTDETIFACCORREJ = 1)
    BEGIN    
      IF(@PageName = 'E')
      BEGIN
        SELECT *, 'N' As CheckDisableFlag  FROM [dbo].[GrantAccMassUpload] WHERE  EmployeeID = @EmployeeId   AND (LetterAcceptanceStatus = 'A')
      END
      ELSE
      BEGIN
        SELECT *, 'N' As CheckDisableFlag  FROM [dbo].[GrantAccMassUpload] WHERE  EmployeeID = @EmployeeId   AND (LetterAcceptanceStatus = 'A' OR LetterAcceptanceStatus = 'R')
      END
		    END

    --D.Show Grant details but disable Exercise Now if grant is not accepted
    SET @IS_GRANTDETDISEXENOWIFNOTACC = (SELECT IS_GRANTDETDISEXENOWIFNOTACC
										  FROM OGACONDGRANTVIEWSETTINGS)
    IF (@IS_GRANTDETDISEXENOWIFNOTACC = 1)
    BEGIN  
		 SELECT *, 'Y' As CheckDisableFlag FROM [dbo].[GrantAccMassUpload] WHERE  EmployeeID = @EmployeeId -- AND IsGlGenerated=1 AND MailSentStatus=1
		 AND (LetterAcceptanceStatus IS Null OR LetterAcceptanceStatus = 'R' OR  LetterAcceptanceStatus = '' OR 
		 LetterAcceptanceStatus = 'A' OR LetterAcceptanceStatus = 'P')   
    END

  END
END
GO
