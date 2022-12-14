/****** Object:  StoredProcedure [dbo].[PROC_CRUDVestingSchedule]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUDVestingSchedule]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUDVestingSchedule]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUDVestingSchedule]
	@Action			CHAR(1),
	@Type			CHAR(1),
	@COLUMN_NAME	VARCHAR(150) = NULL,
	@COLUMN_TYPE	VARCHAR(150) = NULL,
	@HEADER_TEXT	VARCHAR(150) = NULL,
	@FIELDS			VARCHAR(150) = NULL,
	@ROW_NAME		VARCHAR(150) = NULL,
	@VALUE			VARCHAR(150) = NULL,
	@UPDATED_BY		VARCHAR(50)
	
AS
BEGIN
	IF(@Action = 'D' AND @Type = 'C')
	BEGIN
		TRUNCATE TABLE VestingScheduleColumns
	END
	
	ELSE IF(@Action = 'D' AND @Type = 'R')
	BEGIN
		TRUNCATE TABLE VestingScheduleRows
	END
	
	ELSE IF(@Action = 'R' AND @Type = 'C')
	BEGIN
		SELECT COLUMN_NAME, COLUMN_TYPE, HEADER_TEXT, FIELDS, COLUMN_NAME + ' - ' + HEADER_TEXT AS COLUMN_NAME_HEADER_TEXT FROM VestingScheduleColumns ORDER BY COLUMN_NAME
	END
	
	ELSE IF(@Action = 'R' AND @Type = 'R')
	BEGIN
		SELECT VSC.COLUMN_NAME, VSR.ROW_NAME, VSR.VALUE, VSR.FIELDS FROM VestingScheduleRows VSR INNER JOIN VestingScheduleColumns VSC ON VSC.VSCID = VSR.VSCID
	END
	
	ELSE IF(@Action = 'C' AND @Type = 'C')
	BEGIN
		
		INSERT INTO VestingScheduleColumns
			(COLUMN_NAME, COLUMN_TYPE, HEADER_TEXT, FIELDS, UPDATED_BY, UPDATED_ON)
		VALUES
			(@COLUMN_NAME, @COLUMN_TYPE, @HEADER_TEXT, @FIELDS, @UPDATED_BY, GETDATE())
		
	END
	
	ELSE IF (@Action = 'C' AND @Type = 'R')
	BEGIN
				
		INSERT INTO VestingScheduleRows
			(VSCID, ROW_NAME, VALUE, FIELDS, UPDATED_BY, UPDATED_ON)
		VALUES
			((SELECT VSCID FROM VestingScheduleColumns WHERE COLUMN_NAME = @COLUMN_NAME), @ROW_NAME, @VALUE, @FIELDS, @UPDATED_BY, GETDATE())
	END
END

GO
