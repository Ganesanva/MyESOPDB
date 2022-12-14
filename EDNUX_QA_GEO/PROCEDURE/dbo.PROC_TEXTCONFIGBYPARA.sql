/****** Object:  StoredProcedure [dbo].[PROC_TEXTCONFIGBYPARA]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_TEXTCONFIGBYPARA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_TEXTCONFIGBYPARA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_TEXTCONFIGBYPARA]
@ConfigText VARCHAR(500)
AS 
BEGIN
   
   SELECT  CASE 
				WHEN @ConfigText='Text 1' THEN Text1ApprovalDetailsNote
				WHEN @ConfigText='Text 2' THEN Text2GrantIndptDirectors
				WHEN @ConfigText='Text 3' THEN Text3StockExchange
				WHEN @ConfigText='Text 4' THEN Text4StatementReferred
				WHEN @ConfigText='Text 5' THEN Text5RegionalStockExch
				WHEN @ConfigText='Text 6' THEN Text6BoardMeetingDate
				WHEN @ConfigText='Text 7' THEN Text7ApprovalGeneralBodyDate
				WHEN @ConfigText='Text 8' THEN Text8AddressedToBSE
				WHEN @ConfigText='Text 9' THEN Text9AddressedToNSE
				WHEN @ConfigText='Text 10' THEN Text10AddresseeName
				WHEN @ConfigText='Text 11' THEN Text11CDSLAddressee
				WHEN @ConfigText='Text 12' THEN Text12AuthoCommittee
				WHEN @ConfigText='Text 13' THEN Text13AddScheduleNotes
				WHEN @ConfigText='Text 14' THEN Text14ShareTransferAgent
				WHEN @ConfigText='Text 15' THEN Text15AddNotesPartA
				WHEN @ConfigText='Text 16' THEN Text16ShareTransAgentAddress
				WHEN @ConfigText='Text 17' THEN Text17NSDLAddressee
				WHEN @ConfigText='Text 18' THEN Text18AddCorporateActionNote
				ELSE ''
            END AS ConfiguredText
	FROM ListingDocTextConfig
	
END
GO
