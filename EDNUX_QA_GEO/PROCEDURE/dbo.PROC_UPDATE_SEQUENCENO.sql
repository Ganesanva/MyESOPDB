/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_SEQUENCENO]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_SEQUENCENO]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_SEQUENCENO]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UPDATE_SEQUENCENO]
         @ACTION VARCHAR(20) = Null,
         @SEQUENCENO INT
AS
BEGIN	
	 IF(UPPER(@ACTION)='UPDATE')
	BEGIN	
		UPDATE SequenceTable  SET SequenceNo = @SEQUENCENO WHERE Seq1 = 'ShExercisedTaxNo'		
	END
END
GO
