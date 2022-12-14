/****** Object:  StoredProcedure [dbo].[ApproveDisApproveAcceleratedVesting]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ApproveDisApproveAcceleratedVesting]
GO
/****** Object:  StoredProcedure [dbo].[ApproveDisApproveAcceleratedVesting]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================
-- Author      : omprakash katre                                                        =
-- Description : This procedure Approve/DisApprove the accelerated Data                 =
-- EXEC ApproveDisApproveAcceleratedVesting 82, 'NehaTank', 'Approve'                   =
-- ======================================================================================

CREATE PROCEDURE [dbo].[ApproveDisApproveAcceleratedVesting]
    @AccVestingId INT,
    @LastUpdatedBy VARCHAR(20),
    @Status VARCHAR(20)
AS
BEGIN
  IF @Status='Approve' --For approve
	  BEGIN
	  DECLARE @arLevel INT
	  DECLARE @schemeID VARCHAR(30)
	  DECLARE @AccVestingDate DATETIME
	  DECLARE @ExPeriodStartAfter VARCHAR(1)
	  DECLARE @ExPeriodOffset INT
	  
	  SET @arLevel=(SELECT ArLevel FROM AcceleratedRemarks WHERE ArAcceleratedVestingId=@AccVestingId)
	  SELECT @schemeID=SchemeId,@AccVestingDate=AcceleratedVestingDate FROM ShAcceleratedVesting WHERE AcceleratedVestingId=@AccVestingId
	  
	  SELECT @ExPeriodStartAfter=ExercisePeriodStartsAfter, @ExPeriodOffset=ExercisePeriodOffset FROM Scheme WHERE SchemeId=@schemeID
	  
	  ---------------------------------------------------------------------Scheme Level-------------------------------------------------------------
	   IF @arLevel=1
	   BEGIN
		 --STEP 1 - Insert data into AcceleratedVesting table
		 INSERT INTO AcceleratedVesting(AcceleratedVestingId,SchemeId,AcceleratedVestingDate,LastUpdatedBy,LastUpdatedOn)
								 values(@AccVestingId,@schemeID,@AccVestingDate,@LastUpdatedBy,GETDATE())
	         
		 --STEP 2 - Update data into AcceleratedRemark table    
		 UPDATE AcceleratedRemarks SET ArIsShadow='N' WHERE ArAcceleratedVestingId=@AccVestingId AND ArIsShadow='Y'
	     
			 IF @ExPeriodStartAfter='V' -- if exercise period is linked to date of vesting
			  BEGIN
			  --STEP 3 - Update data into GrantLeg table 
			   UPDATE GrantLeg SET AcceleratedVestingDate=@AccVestingDate,
								   AcceleratedExpirayDate=DATEADD(MONTH,@ExPeriodOffset,@AccVestingDate),
								   FinalVestingDate =@AccVestingDate,
								   FinalExpirayDate= DATEADD(MONTH,@ExPeriodOffset,@AccVestingDate)
							 WHERE SchemeId= @schemeID 
							       AND FinalVestingDate>GETDATE()
			  END       
			 ELSE 
			  BEGIN
				UPDATE GrantLeg SET AcceleratedVestingDate=@AccVestingDate,   -- exercise period is linked to the date of grant
							   --   AcceleratedExpirayDate=
									FinalVestingDate = @AccVestingDate
							   --   FinalExpirayDate=''
							 WHERE SchemeId= @schemeID 
							       AND FinalVestingDate>GETDATE()
			  END 
			  
		 --STEP 4 - Delete data from shAcceleratedVesting Table 		            
		 DELETE FROM ShAcceleratedVesting WHERE AcceleratedVestingId=@AccVestingId
	      
	   END
	   --------------------------------------------------------------------Grant Level-------------------------------------------------------------- 
	   IF @arLevel=2
	   BEGIN
		 --STEP 1 - Insert data into AcceleratedVesting table
		 INSERT INTO AcceleratedVesting(AcceleratedVestingId,SchemeId,AcceleratedVestingDate,LastUpdatedBy,LastUpdatedOn)
								 values(@AccVestingId,@schemeID,@AccVestingDate,@LastUpdatedBy,GETDATE())
	         
		--STEP 2 - Update data into AcceleratedRemark table    
		 UPDATE AcceleratedRemarks SET ArIsShadow='N' WHERE ArAcceleratedVestingId=@AccVestingId AND ArIsShadow='Y'
	     
			 IF @ExPeriodStartAfter='V' -- if exercise period is linked to date of vesting
			  BEGIN
			  --STEP 3 - Update data into GrantLeg table 
			   UPDATE GrantLeg SET AcceleratedVestingDate=@AccVestingDate,
								   AcceleratedExpirayDate=DATEADD(MONTH,@ExPeriodOffset,@AccVestingDate),
								   FinalVestingDate =@AccVestingDate,
								   FinalExpirayDate= DATEADD(MONTH,@ExPeriodOffset,@AccVestingDate)
							 WHERE GrantRegistrationId= (select ArGrantRegid from AcceleratedRemarks where ArAcceleratedVestingId=@AccVestingId) 
							       AND FinalVestingDate>GETDATE()
			  END       
			 ELSE 
			  BEGIN
				UPDATE GrantLeg SET AcceleratedVestingDate=@AccVestingDate,   -- exercise period is linked to the date of grant
							   --   AcceleratedExpirayDate=
									FinalVestingDate = @AccVestingDate
							   --   FinalExpirayDate=''
							 WHERE GrantRegistrationId= (select ArGrantRegid from AcceleratedRemarks where ArAcceleratedVestingId=@AccVestingId)
							       AND FinalVestingDate>GETDATE()
			  END 
			  
		 --STEP 4 - Delete data from shAcceleratedVesting Table 		            
		 DELETE FROM ShAcceleratedVesting WHERE AcceleratedVestingId=@AccVestingId
	   END
	   --------------------------------------------------------------------Employee Level-----------------------------------------------------------
	   IF @arLevel=3
	   BEGIN
		--STEP 1 - Insert data into AcceleratedVesting table
		 INSERT INTO AcceleratedVesting(AcceleratedVestingId,SchemeId,AcceleratedVestingDate,LastUpdatedBy,LastUpdatedOn)
								 values(@AccVestingId,@schemeID,@AccVestingDate,@LastUpdatedBy,GETDATE())
	         
		--STEP 2 - Update data into AcceleratedRemark table    
		 UPDATE AcceleratedRemarks SET ArIsShadow='N' WHERE ArAcceleratedVestingId=@AccVestingId AND ArIsShadow='Y'
	     
			 IF @ExPeriodStartAfter='V' -- if exercise period is linked to date of vesting
			  BEGIN
			  --STEP 3 - Update data into GrantLeg table 
			   UPDATE GrantLeg SET AcceleratedVestingDate=@AccVestingDate,
								   AcceleratedExpirayDate=DATEADD(MONTH,@ExPeriodOffset,@AccVestingDate),
								   FinalVestingDate =@AccVestingDate,
								   FinalExpirayDate= DATEADD(MONTH,@ExPeriodOffset,@AccVestingDate)
							 WHERE GrantOptionId= (select ArGrantoptionid from AcceleratedRemarks where ArAcceleratedVestingId=@AccVestingId)
							       AND FinalVestingDate>GETDATE()
			  END       
			 ELSE 
			  BEGIN
				UPDATE GrantLeg SET AcceleratedVestingDate=@AccVestingDate,   -- exercise period is linked to the date of grant
							   --   AcceleratedExpirayDate=
									FinalVestingDate = @AccVestingDate
							   --   FinalExpirayDate=''
							WHERE GrantOptionId= (select ArGrantoptionid from AcceleratedRemarks where ArAcceleratedVestingId=@AccVestingId)
							      AND FinalVestingDate>GETDATE()
			  END 
			  
		 --STEP 4 - Delete data from shAcceleratedVesting Table 		            
		 DELETE FROM ShAcceleratedVesting WHERE AcceleratedVestingId=@AccVestingId
	   END
  END
  
  ELSE IF @Status='DisApprove' --For DisApprove
  BEGIN
   DELETE FROM ShAcceleratedVesting WHERE AcceleratedVestingId=@AccVestingId
   DELETE FROM AcceleratedRemarks WHERE ArAcceleratedVestingId = @AccVestingId
  END
  
END
GO
