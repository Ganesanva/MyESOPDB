IF not EXISTS(SELECT NAME FROM SYS.TYPES WHERE NAME = 'TypeGrantViewConfiguration')
BEGIN

CREATE TYPE [dbo].[TypeGrantViewConfiguration] AS TABLE(
	[LetterAcceptanceStatus] [varchar](100) NULL,
	[IsViewEnabled] [bit] NULL,
	[IsDownloadEnabled] [bit] NULL
)
end


