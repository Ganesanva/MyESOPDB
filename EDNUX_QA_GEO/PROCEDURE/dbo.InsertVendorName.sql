/****** Object:  StoredProcedure [dbo].[InsertVendorName]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[InsertVendorName]
GO
/****** Object:  StoredProcedure [dbo].[InsertVendorName]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================================
-- Author      :  omprakash katre                                                                      -
-- Description :  This procedure will Set the vendors Name                                          -
-- =====================================================================================================

CREATE PROCEDURE [dbo].[InsertVendorName]
(
@VendorName VARCHAR(100),               
@LastUpdatedBy  VARCHAR(100)           
)
AS
BEGIN
   INSERT INTO VendorList(VendorName,LastUpdatedBy,LastUpdatedOn) VALUES(@VendorName,@LastUpdatedBy,GETDATE())
END
GO
