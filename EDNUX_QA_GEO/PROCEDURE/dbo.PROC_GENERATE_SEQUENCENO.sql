/****** Object:  StoredProcedure [dbo].[PROC_GENERATE_SEQUENCENO]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GENERATE_SEQUENCENO]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GENERATE_SEQUENCENO]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GENERATE_SEQUENCENO]
         @ACTION VARCHAR(20) = Null,
         @SEQUENCENO INT = NULL
AS
BEGIN	
	IF(UPPER(@ACTION)='GET')
	BEGIN
		SELECT SequenceNo + 1 as SequenceNo FROM SequenceTable  WHERE  Seq1 = 'ShExercisedTaxNo'      
	END   
END
GO
