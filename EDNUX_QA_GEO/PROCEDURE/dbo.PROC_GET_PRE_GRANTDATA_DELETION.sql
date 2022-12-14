/****** Object:  StoredProcedure [dbo].[PROC_GET_PRE_GRANTDATA_DELETION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_PRE_GRANTDATA_DELETION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_PRE_GRANTDATA_DELETION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_PRE_GRANTDATA_DELETION]
	
	@EmployeeId VARCHAR(MAX) = NULL,
	@LetterCode  VARCHAR(MAX) = NULL,
	@LotNumber  VARCHAR(MAX) = NULL   
AS
BEGIN
	DECLARE @SelectQuery NVARCHAR(MAX)
	DECLARE @FROMQuery NVARCHAR(MAX)
	DECLARE @WhereQuery NVARCHAR(MAX)
	SET @SelectQuery='SELECT EmployeeID, LetterCode, LotNumber, SchemeName, GrantDate, LetterAcceptanceStatus, LetterAcceptanceDate '
	SET @FROMQuery=' FROM GrantAccMassUpload '
	SET @WhereQuery=''
	IF(@EmployeeId IS NOT NULL)
	BEGIN
		SET @WhereQuery ='WHERE EmployeeID ='+''''+@EmployeeId+''''
	END

	IF(@LetterCode IS NOT NULL)
	BEGIN
		IF(@WhereQuery='')
		BEGIN
			SET @WhereQuery ='WHERE LetterCode ='+''''+@LetterCode+''''
		END
		ELSE
			SET @WhereQuery =@WhereQuery+'AND LetterCode ='+''''+@LetterCode+''''
	END

	IF(@LotNumber IS NOT NULL)
	BEGIN
		IF(@WhereQuery='')
		BEGIN
			SET @WhereQuery ='WHERE LotNumber ='+''''+@LotNumber+''''
		END
		ELSE
			SET @WhereQuery =@WhereQuery+'AND LotNumber ='+''''+@LotNumber+''''
	END
	EXEC (@SelectQuery+@FROMQuery+@WhereQuery)

	
END
GO
