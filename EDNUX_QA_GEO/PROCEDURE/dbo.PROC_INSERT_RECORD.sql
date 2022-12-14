/****** Object:  StoredProcedure [dbo].[PROC_INSERT_RECORD]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_RECORD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_RECORD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_INSERT_RECORD]
(
	@ApprovalId			NVARCHAR (250),
	@ApprovalDate		DATE,
	@ApprovalTitle		NVARCHAR (250),
	@Description		NVARCHAR (500),
	@NumberOfShares		NUMERIC (18,0),
	@ValidUpToDate		DATE,
	@IsCoverSAR			BIT,
	@LastUpdatedBy		VARCHAR (250),
	@LastUpdatedOn		DATE,
	@Action				CHAR	(1),
	@AdditionalShares	INT,
	@ValidityType		VARCHAR (20)
)
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO ShShareHolderApproval 
	(ApprovalId,ApprovalDate,ApprovalTitle,Description,NumberOfShares,
	ValidUptoDate,IsCoverSAR,AvailableShares,LastUpdatedBy,LastUpdatedOn,Action,AdditionalShares,ValidityType)
	VALUES (@ApprovalId, @ApprovalDate, @ApprovalTitle, @Description, @NumberOfShares, @ValidUpToDate,@IsCoverSAR,
	@NumberOfShares, @LastUpdatedBy, @LastUpdatedOn, @Action, @AdditionalShares, @ValidityType) 

	SET NOCOUNT OFF;
END

GO
