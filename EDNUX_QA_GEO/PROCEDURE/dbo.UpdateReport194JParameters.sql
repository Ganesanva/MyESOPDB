/****** Object:  StoredProcedure [dbo].[UpdateReport194JParameters]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[UpdateReport194JParameters]
GO
/****** Object:  StoredProcedure [dbo].[UpdateReport194JParameters]    Script Date: 7/6/2022 1:40:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================================
-- Author      :  omprakash katre                                                                      -
-- Description :  This procedure will update the UpdateReport194 records                               -
-- =====================================================================================================

CREATE PROCEDURE [dbo].[UpdateReport194JParameters]

@DeducteeName   VARCHAR(100),
@DeducteePAN VARCHAR(15),
@DeducteeAddress VARCHAR(500),
@DeducteePIN NUMERIC(10,2),
@VendorID Int,
@AmtPaidCreadited VARCHAR(100),
@LastUpdatedBy VARCHAR(20)
AS
BEGIN
   IF NOT EXISTS(SELECT * FROM Report194J WHERE VendorID=@VendorID )
   BEGIN
    INSERT INTO Report194J(DeducteeName,DeducteePAN,DeducteeAddress,DeducteePIN,VendorID,AmtPaidCreaditedID,LastUpdatedBy,LastUpdatedOn)
                      VALUES(@DeducteeName,@DeducteePAN,@DeducteeAddress,@DeducteePIN,@VendorID,@AmtPaidCreadited,@LastUpdatedBy,GETDATE())
   END
   ELSE
   BEGIN
     UPDATE Report194J SET DeducteeName=@DeducteeName,DeducteePAN=@DeducteePAN,
                           DeducteeAddress=@DeducteeAddress,DeducteePIN=@DeducteePIN,
                           AmtPaidCreaditedID=@AmtPaidCreadited,LastUpdatedBy=@LastUpdatedBy,
                           LastUpdatedOn=GETDATE() where VendorID=@VendorID
   END
END
GO
