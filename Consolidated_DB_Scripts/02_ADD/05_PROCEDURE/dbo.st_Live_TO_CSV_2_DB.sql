/****** Object:  StoredProcedure [dbo].[st_Live_TO_CSV_2_DB]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[st_Live_TO_CSV_2_DB]
GO
/****** Object:  StoredProcedure [dbo].[st_Live_TO_CSV_2_DB]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vidyadhar
-- Create date: 18-11-2021
-- Description:	Create st_Live_TO_CSV_2
-- =============================================

CREATE     PROCEDURE [dbo].[st_Live_TO_CSV_2_DB]
	@Status VARCHAR(20) = ''
,	@SchemeTypeId INT=0
,	@DBName VARCHAR(200)=''
,	@FilePath VARCHAR(4000)=''
,	@FlipkartYN VARCHAR(1)='N'
as
BEGIN
	DECLARE @SQLQuery VARCHAR(1000)=''
	/*
		--Flipkart Stock Option Scheme 2012
		1.Upto Mar 2019
		2.Apr 19 to 18 Aug 2020
		3.After 18 Aug 2020
	*/
	DECLARE @LiveFileName TABLE (FID INT IDENTITY(1,1), CSVFileName VARCHAR(100)
	, FromDate VARCHAR(30), ToDate VARCHAR(30))
	DECLARE @I INT=0, @TotalRecords INT=0
	IF (@FlipkartYN ='Y')
	BEGIN
		IF (@Status = 'Live' AND @SchemeTypeId = 1)
		BEGIN
			INSERT INTO @LiveFileName
			(CSVFileName, FromDate, ToDate)
			VALUES ('Upto_Mar_2019'			, '01-JAN-1900','31-MAR-2019')
				  ,('Apr_19_to_18_Aug_2020'	, '01-APR-2019','18-AUG-2020')
				  ,('After_18_Aug_2020'		, '19-AUG-2020','31-MAR-2050')
		END
		ELSE
		IF (@Status = 'Separated' AND @SchemeTypeId = 1)
		BEGIN
			INSERT INTO @LiveFileName
			(CSVFileName, FromDate, ToDate)
			VALUES ('b4_dec2015'	, '01-JAN-1900','31-DEC-2015')
				  ,('2016_to_2018'	, '01-JAN-2016','31-DEC-2018')
				  ,('2019_to_2021'	, '01-JAN-2019','31-MAR-2050')
		END
		IF (@Status = 'Live' AND @SchemeTypeId = 2)
		BEGIN
			INSERT INTO @LiveFileName
			(CSVFileName, FromDate, ToDate)
			VALUES ('Vestwise_Live_2012A_Report', '01-JAN-1900','31-MAR-2050')
		END
		ELSE
		IF (@Status = 'Separated' AND @SchemeTypeId = 2)
		BEGIN
			INSERT INTO @LiveFileName
			(CSVFileName, FromDate, ToDate)
			VALUES ('Vestwise_Separated_2012A_Report', '01-JAN-1900','31-MAR-2050')
		END
	END
	ELSE
	BEGIN
		IF (@SchemeTypeId = 1)
		BEGIN
			INSERT INTO @LiveFileName
			(CSVFileName, FromDate, ToDate)
			VALUES ('LiveSeprated', '01-JAN-1900','31-MAR-2050')
		END
		ELSE IF (@SchemeTypeId = 2)
		BEGIN
			INSERT INTO @LiveFileName
			(CSVFileName, FromDate, ToDate)
			VALUES ('Vestwise_Report', '01-JAN-1900','31-MAR-2050')
		END


	END


	SELECT @I = MIN(FID), @TotalRecords = MAX(FID)
	FROM @LiveFileName
	WHILE (@I <= @TotalRecords)
	BEGIN
		DECLARE @FromDate VARCHAR(30)='', @ToDate VARCHAR(30)='', @FileName VARCHAR(200)=''
		DECLARE @SchemeId VARCHAR(200)=''
		DECLARE @sql VARCHAR(2000)=''
		IF (@FlipkartYN ='Y')
		BEGIN
			SELECT @SchemeId= (CASE WHEN @SchemeTypeId =1 THEN 'Flipkart Stock Option Scheme 2012' ELSE 'Flipkart Stock Option Scheme 2012 A'  END)
		END
		ELSE
		BEGIN
			SELECT @SchemeId = 'ALL'
		END

		IF (@FlipkartYN ='Y')
		BEGIN
			SELECT @FromDate = FromDate, @ToDate = ToDate
			, @FileName = CONCAT((CASE WHEN @SchemeTypeId = 1 THEN  '2012_' ELSE '' END ),CSVFileName)
			FROm @LiveFileName
			WHERE FID = @I
		END
		BEGIN
			SELECT @FromDate = FromDate, @ToDate = ToDate
			, @FileName = CONCAT((CASE WHEN @SchemeTypeId = 1 THEN  '2012_' ELSE '' END ),CSVFileName)
			FROM @LiveFileName
		END


		/*
			TODO : Create Live and Seperated File

		*/
			PRINt 'Step 1'
			EXECUTE st_Live_TO_CSV_DB @FromDate, @ToDate ,@Status ,@SchemeId
			PRINt 'Step 2'
			SELECT @FileName  =CONCAT((CASE WHEN @SchemeTypeId = 1 THEN @Status ELSE '' END)
										,(CASE WHEN @SchemeTypeId = 1 THEN '_' ELSE '' END),@FileName,'.CSV')
			PRINT @FileName
			select @sql = 'bcp "SELECT * '
			+ ' FROM '
			+@DBName+'..##LiveORSeparated_TO_CSV_DB ORDER BY ID "  queryout '+
			+@FilePath --'D:\FilpkartCSVData\'
			+@FileName
			+' -c -t, -T -S ' + @@servername +' 1>Nul'
			exec master..xp_cmdshell @sql
			--PRINt 'Step 3'
			DROP TABLE ##LiveORSeparated_TO_CSV_DB
			PRINt 'Step 4'
		SELECT FromDate, ToDate, CSVFileName
		fROM @LiveFileName
		WHERE FID= @I
		SET @I = @I + 1
	END

END
GO
