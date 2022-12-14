/****** Object:  StoredProcedure [dbo].[PROC_GET_OGA_GrantStatusForRedirection]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_OGA_GrantStatusForRedirection]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_OGA_GrantStatusForRedirection]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[PROC_GET_OGA_GrantStatusForRedirection]
	@EMPLOYEEID VARCHAR(50),
	@GRANTDATE VARCHAR(10),
	@RESULT			int OUTPUT
	
AS
BEGIN

 IF(CONVERT(date, @GRANTDATE) < CONVERT(date,'08/01/2016'))
 Begin  
		SET @RESULT = 1 
		print 'July'
 End
 Else
 Begin 
 print 'August'

		  IF EXISTS(SELECT (GAMUID) FROM GRANTACCMASSUPLOAD WHERE CONVERT(DATE,GRANTDATE) <= CONVERT(DATE ,@GRANTDATE) And LetterAcceptanceStatus='A' And EmployeeID=@EMPLOYEEID)
		  BEGIN
		  print 'Accepted'
				SET @RESULT = 0
		  END
		  ELSE
		  BEGIN
				 print 'Not Accepted'
				SET @RESULT = 1
		  END
 

 
 End
  
  print @RESULT
END
GO
