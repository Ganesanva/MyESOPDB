/****** Object:  StoredProcedure [dbo].[st_CancellationDetails_To_CSV_DB]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[st_CancellationDetails_To_CSV_DB]
GO
/****** Object:  StoredProcedure [dbo].[st_CancellationDetails_To_CSV_DB]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vidyadhar
-- Create date: 18-11-2021
-- Description:	Create st_CancellationDetails_To_CSV 
-- =============================================

CREATE     PROCEDURE [dbo].[st_CancellationDetails_To_CSV_DB] 
	@DBName VARCHAR(200)=''
,	@FilePath VARCHAR(4000)=''
,  	@FlipkartYN VARCHAR(20)='N'
AS

BEGIN
	SET NOCOUNT ON
    declare @sql varchar(8000)
	DECLARE @FileName VARCHAR(50)=''
	DECLARE @I INT, @TotalRecords INT=0

	DECLARE @CnYear INT=0
	DECLARE @S_SchemeTitle VARCHAR(50) =''
	DECLARE @SchemeTitle INT=1, @TotalM INt=2

	DECLARE @CanlYear TABLE (ID INT IDENTITY(1,1), CnYear INT)

	IF (@FlipkartYN ='Y')
	BEGIN
		INSERT INTO @CanlYear
		(CnYear)
		SELECT *
		FROM VW_Cancellation_Year_DB
		ORDER BY 1
	END
	ELSE
	BEGIN
		INSERT INTO @CanlYear
		(CnYear)
		SELECT '1900'
	END

	SELECT @I= MIN(ID), @TotalRecords = MAX(ID)
	FROM @CanlYear

	WHILE (@I <= @TotalRecords)
	BEGIN

		SET  @CnYear =0
		SET  @S_SchemeTitle  =''
		SET  @SchemeTitle =1
		SET	 @TotalM =2

		SELECT @CnYear = CnYear FROM @CanlYear WHERE ID = @I


		WHILE (@SchemeTitle <= 1)
		BEGIN
			SET @S_SchemeTitle =(CASE WHEN @SchemeTitle = 1 THEN '2012' 
				WHEN @SchemeTitle = 12 THEN '2012A' END)

			PRINt 'Step 1'
			PRINT @S_SchemeTitle
			EXECUTE st_CancellationDetails_Data_DB @CnYear, 1 --@SchemeTitle 
			PRINt 'Step 2'
			IF (@FlipkartYN ='Y')
			BEGIN
				SELECT @FileName  =  CONCAT('Cancellation_',@S_SchemeTitle,'_',CONVERT(VARCHAR,@CnYear),'.CSV')
			END
			ELSE
			BEGIN
				SELECT @FileName  =  CONCAT('Cancellation','.CSV')
			END

			PRINT @FileName
			select @sql = 'bcp "SELECT * '
			+ ' FROM '
			+@DBName+'..##MCancellations_DB ORDER BY ID "  queryout '+
			+@FilePath -- 'D:\FilpkartCSVData\'
			+@FileName
			+' -c -t, -T -S ' + @@servername +' 1>Nul'
			exec master..xp_cmdshell @sql
			PRINt 'Step 3'
			DROP TABLE ##MCancellations_DB
			PRINt 'Step 4'
			SET @SchemeTitle =  @SchemeTitle +1
		END
		SET @I = @I + 1
		SET @SchemeTitle =2
	END
	IF (@SchemeTitle =2)
	BEGIN
		PRINt 'Step 1'
		EXECUTE st_CancellationDetails_Data_A_DB

			IF (@FlipkartYN ='Y')
			BEGIN
				SELECT @FileName  =CONCAT('Vestwise_Cancellation_2012A','.CSV')
			END
			ELSE
			BEGIN
				SELECT @FileName  =CONCAT('Vestwise_Cancellation','.CSV')
			END
		PRINT @FileName
		select @sql = 'bcp "SELECT * '
		+ ' FROM '
		+@DBName +'..##MCancellations_DB ORDER BY ID"  queryout '+
		+@FilePath --'D:\FilpkartCSVData\'
		+@FileName
		+' -c -t, -T -S ' + @@servername +' 1>Nul'
		exec master..xp_cmdshell @sql
		PRINt 'Step 3'
		DROP TABLE ##MCancellations_DB
		PRINt 'Step 4'
		
	END
END

GO
