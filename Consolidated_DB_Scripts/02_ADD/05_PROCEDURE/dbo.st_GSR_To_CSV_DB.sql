/****** Object:  StoredProcedure [dbo].[st_GSR_To_CSV_DB]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[st_GSR_To_CSV_DB]
GO
/****** Object:  StoredProcedure [dbo].[st_GSR_To_CSV_DB]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vidyadhar
-- Create date: 18-11-2021
-- Description:	Create GSR File CSV 
-- =============================================
CREATE      PROCEDURE [dbo].[st_GSR_To_CSV_DB] 	
	@DBName VARCHAR(200)=''
,	@FilePath VARCHAR(4000)=''
AS
BEGIN
    declare @sql varchar(8000)

	DECLARE @FileName VARCHAR(50)=''
	SELECT @FileName  =CONCAT('GSR','.CSV')
	select @sql = 'bcp "SELECT * '
	+ ' FROM '
	+@DBName+'..VW_GSR_DB ORDER BY 22,1, 2, 3, 4, 5, 6 "  queryout '+
	+@FilePath
	+@FileName
	+' -c -t, -T -S ' + @@servername +' 1>Nul'
    exec master..xp_cmdshell @sql
END

GO
