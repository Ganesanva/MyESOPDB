/****** Object:  StoredProcedure [dbo].[st_All_CSV_DB]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [st_All_CSV_DB]
GO
/****** Object:  StoredProcedure [dbo].[st_All_CSV_DB]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vidyadhar
-- Create date: 03-12-2021
-- Description:	Create st_All_Filpkart_CSV
-- =============================================

CREATE   PROCEDURE [st_All_CSV_DB]
	@DBName VARCHAR(100)=''
,	@CSVFilePath VARCHAR(500)=''
as
BEGIN
	DECLARE @CreateFolder VARCHAR(1000)=''
	DECLARE @CSVPath VARCHAR(1000)=''

	SELECT @CreateFolder = CONCAT('exec master..xp_cmdshell ','''','MD F:\CUSTOMEMIS\',@DBName,'\','''')
	EXECUTE (@CreateFolder )	

	SET @CSVPath = CONCAT(@CSVFilePath,'\',@DBName,'\')


	--exec master..xp_cmdshell 'MD F:\CUSTOMEMIS\TEmpdata'
	-- PSR
		EXECUTE st_PSR_To_CSV_DB	@DBName,@CSVPath -- 'Flipkart','F:\FilpkartCSVData\'
	-- GSR
		EXECUTE st_GSR_To_CSV_DB	@DBName,@CSVPath -- 'Flipkart','F:\FilpkartCSVData\'
	-- Cancellation Report
		EXECUTE st_CancellationDetails_To_CSV_DB	@DBName,@CSVPath -- 'Flipkart','F:\FilpkartCSVData\'
	-- Live
		EXECUTE st_Live_TO_CSV_2_DB 'Live',1	,@DBName,@CSVPath -- 'Flipkart','F:\FilpkartCSVData\'
		EXECUTE st_Live_TO_CSV_2_DB 'Live',2	,@DBName,@CSVPath -- 'Flipkart','F:\FilpkartCSVData\'
	-- Seprated
		EXECUTE st_Live_TO_CSV_2_DB 'Separated',1	,@DBName,@CSVPath -- 'Flipkart','F:\FilpkartCSVData\'
		EXECUTE st_Live_TO_CSV_2_DB 'Separated',2	,@DBName,@CSVPath -- 'Flipkart','F:\FilpkartCSVData\'
END
GO
