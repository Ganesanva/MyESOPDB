/****** Object:  StoredProcedure [dbo].[PROC_GET_TEXTCONFIG]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_TEXTCONFIG]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_TEXTCONFIG]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_TEXTCONFIG]
AS  
BEGIN
   
	SELECT Text1ApprovalDetailsNote,Text2GrantIndptDirectors,Text3StockExchange,Text4StatementReferred,Text5RegionalStockExch,Text6BoardMeetingDate,
		   Text7ApprovalGeneralBodyDate,Text8AddressedToBSE,Text9AddressedToNSE,Text10AddresseeName,Text11CDSLAddressee,Text12AuthoCommittee,
		   Text13AddScheduleNotes,Text14ShareTransferAgent,Text15AddNotesPartA,Text16ShareTransAgentAddress,Text17NSDLAddressee,
		   Text18AddCorporateActionNote
	FROM ListingDocTextConfig
	
END
GO
