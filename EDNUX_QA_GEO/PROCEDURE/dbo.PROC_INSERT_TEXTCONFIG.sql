/****** Object:  StoredProcedure [dbo].[PROC_INSERT_TEXTCONFIG]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_TEXTCONFIG]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_TEXTCONFIG]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_INSERT_TEXTCONFIG]
	@Text TEXT,
	@TextType VARCHAR(100),
	@CreatedBy VARCHAR(100),
	@Result INT OUT
AS  
BEGIN
    SET @Result=0
    IF NOT EXISTS (SELECT 1 FROM ListingDocTextConfig)
    BEGIN
        IF @TextType='Text 1'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text1ApprovalDetailsNote,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())	
			SET @Result=1
        END
        ELSE IF (@TextType='Text 2')
        BEGIN
			INSERT INTO ListingDocTextConfig (Text2GrantIndptDirectors,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())	
			SET @Result=1
        END
        ELSE IF @TextType='Text 3'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text3StockExchange,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1	
        END
        ELSE IF @TextType='Text 4'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text4StatementReferred,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1
        END
        ELSE IF @TextType='Text 5'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text5RegionalStockExch,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1
        END
        ELSE IF @TextType='Text 6'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text6BoardMeetingDate,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1
        END
        ELSE IF @TextType='Text 7'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text7ApprovalGeneralBodyDate,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1
        END
        ELSE IF @TextType='Text 8'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text8AddressedToBSE,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1
        END
        ELSE IF @TextType='Text 9'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text9AddressedToNSE,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1
        END
        ELSE IF @TextType='Text 10'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text10AddresseeName,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1
        END
        ELSE IF @TextType='Text 11'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text11CDSLAddressee,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1
        END
        ELSE IF @TextType='Text 12'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text12AuthoCommittee,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1          
        END
        ELSE IF @TextType='Text 13'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text13AddScheduleNotes,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1
        END
        ELSE IF @TextType='Text 14'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text14ShareTransferAgent,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1
        END
        ELSE IF @TextType='Text 15'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text15AddNotesPartA,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1	             
        END
        ELSE IF @TextType='Text 16'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text16ShareTransAgentAddress,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1             
        END
        ELSE IF @TextType='Text 17'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text17NSDLAddressee,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1             
        END
        ELSE IF @TextType='Text 18'
        BEGIN
			INSERT INTO ListingDocTextConfig (Text18AddCorporateActionNote,CreatedBy,CreatedOn)	
			       VALUES 
			             (@Text,@CreatedBy,GETDATE())
			SET @Result=1
        END
		
    END
    ELSE 
    BEGIN
     IF @TextType='Text 1'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text1ApprovalDetailsNote=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1
        END
        ELSE IF (@TextType='Text 2')
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text2GrantIndptDirectors=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE()  
			SET @Result=1
        END
        ELSE IF @TextType='Text 3'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text3StockExchange=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE()  
			SET @Result=1	
        END
        ELSE IF @TextType='Text 4'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text4StatementReferred=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1
        END
        ELSE IF @TextType='Text 5'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text5RegionalStockExch=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1
        END
        ELSE IF @TextType='Text 6'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text6BoardMeetingDate=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1
        END
        ELSE IF @TextType='Text 7'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text7ApprovalGeneralBodyDate=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1
        END
        ELSE IF @TextType='Text 8'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text8AddressedToBSE=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE()  
			SET @Result=1
        END
        ELSE IF @TextType='Text 9'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text9AddressedToNSE=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1
        END
        ELSE IF @TextType='Text 10'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text10AddresseeName=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE()  
			SET @Result=1
        END
        ELSE IF @TextType='Text 11'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text11CDSLAddressee=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1
        END
        ELSE IF @TextType='Text 12'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text12AuthoCommittee=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE()  
			SET @Result=1          
        END
        ELSE IF @TextType='Text 13'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text13AddScheduleNotes=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1
        END
        ELSE IF @TextType='Text 14'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text14ShareTransferAgent=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1
        END
        ELSE IF @TextType='Text 15'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text15AddNotesPartA=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1	             
        END
        ELSE IF @TextType='Text 16'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text16ShareTransAgentAddress=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE()  
			SET @Result=1             
        END
        ELSE IF @TextType='Text 17'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text17NSDLAddressee=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1             
        END
        ELSE IF @TextType='Text 18'
        BEGIN
			UPDATE  ListingDocTextConfig
					 SET Text18AddCorporateActionNote=@Text,ModifiedBy=@CreatedBy,ModifiedOn=GETDATE() 
			SET @Result=1
        END
		 
    END
	
	
END
GO
