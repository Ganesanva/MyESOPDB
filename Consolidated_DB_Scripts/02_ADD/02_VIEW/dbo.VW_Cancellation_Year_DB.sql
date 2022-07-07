/****** Object:  View [dbo].[VW_Cancellation_Year_DB]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_Cancellation_Year_DB]'))
EXEC dbo.sp_executesql @statement = N'

-- =============================================
-- Author:		Vidyadhar
-- Create date: 18-11-2021
-- Description:	Create VW_Cancellation_Year 
-- =============================================
CREATE     VIEW [dbo].[VW_Cancellation_Year_DB]
as
SELECT DISTINCT YEAR(GrantDate) as CancellationYear
FROM CancellationDetails_rpt
' 
GO
