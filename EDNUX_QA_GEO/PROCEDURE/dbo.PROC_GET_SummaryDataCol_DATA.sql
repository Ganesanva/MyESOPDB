/****** Object:  StoredProcedure [dbo].[PROC_GET_SummaryDataCol_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SummaryDataCol_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_SummaryDataCol_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_SummaryDataCol_DATA]  

AS
BEGIN

SELECT * FROM MST_Summary_Column_Setting where IsActive=1 order by SequenceNo
	SET NOCOUNT OFF;

END
GO
