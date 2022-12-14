/****** Object:  StoredProcedure [dbo].[GetVendorList]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetVendorList]
GO
/****** Object:  StoredProcedure [dbo].[GetVendorList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================================
-- Author      :  omprakash katre                                                                      -
-- Description :  This procedure will get the list of vendors                                          -
-- =====================================================================================================

CREATE PROCEDURE [dbo].[GetVendorList]
AS
BEGIN
   SELECT VendorID,VendorName from VendorList
END
GO
