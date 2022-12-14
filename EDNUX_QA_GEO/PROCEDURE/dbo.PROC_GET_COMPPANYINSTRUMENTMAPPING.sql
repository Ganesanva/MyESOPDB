/****** Object:  StoredProcedure [dbo].[PROC_GET_COMPPANYINSTRUMENTMAPPING]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_COMPPANYINSTRUMENTMAPPING]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_COMPPANYINSTRUMENTMAPPING]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_COMPPANYINSTRUMENTMAPPING]  
  
@MITID INT  
  
AS  
BEGIN  
 SET NOCOUNT ON;   
     
   
    SELECT   
  MIT_ID,IsTaxApplicable,IsResident,IsNonResident,IsForeignNational  
 FROM COMPANY_INSTRUMENT_MAPPING     
 WHERE   
    IS_ENABLED = 1 and    MIT_ID = @MITID  
  
 SET NOCOUNT OFF;   
END  
  
GO
