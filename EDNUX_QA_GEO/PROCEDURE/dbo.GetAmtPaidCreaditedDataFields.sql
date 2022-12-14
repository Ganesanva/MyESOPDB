/****** Object:  StoredProcedure [dbo].[GetAmtPaidCreaditedDataFields]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetAmtPaidCreaditedDataFields]
GO
/****** Object:  StoredProcedure [dbo].[GetAmtPaidCreaditedDataFields]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================================
-- Author      :  omprakash katre                                                                      -
-- Description :  This procedure will get the list Amount Paid/Creadited Data Fields Name              -
-- =====================================================================================================

CREATE PROCEDURE [dbo].[GetAmtPaidCreaditedDataFields]
AS
BEGIN
   SELECT ID,FieldName from AmtPaidCreaditedDataFields
END
GO
