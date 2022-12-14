/****** Object:  StoredProcedure [dbo].[GetReport194JParameters]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetReport194JParameters]
GO
/****** Object:  StoredProcedure [dbo].[GetReport194JParameters]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================================
-- Author      :  omprakash katre                                                                      -
-- Description :  This procedure will update the UpdateReport194 J -ED records  
--GetReport194JParameters  1                     -
-- =====================================================================================================

CREATE PROCEDURE [dbo].[GetReport194JParameters]
(
  @VendorID INT -- @VendorID = 0 => show all data | 1,2... => show data according to VendorID
)
AS
BEGIN
  SELECT [DeducteeSerialNo],[DeducteeName],[DeducteePAN],[DeducteeAddress],[DeducteePIN],Rptj.VendorID,
         VendorList.VendorName As VendorName ,AmtPaidCreaditedDataFields.FieldName AS AmtPaidCreadited,RptJ.LastUpdatedBy,RptJ.LastUpdatedOn
         FROM Report194J RptJ LEFT OUTER JOIN VendorList ON RptJ.VendorID=VendorList.VendorID
                              LEFT OUTER JOIN AmtPaidCreaditedDataFields ON RptJ.AmtPaidCreaditedID=AmtPaidCreaditedDataFields.ID
         WHERE RptJ.VendorID IN (SELECT VendorID FROM Report194J WHERE Coalesce(@VendorID,0)=0 OR VendorID=@VendorID)
END
GO
