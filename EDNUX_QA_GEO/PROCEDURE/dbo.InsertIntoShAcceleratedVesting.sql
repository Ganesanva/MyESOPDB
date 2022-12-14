/****** Object:  StoredProcedure [dbo].[InsertIntoShAcceleratedVesting]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[InsertIntoShAcceleratedVesting]
GO
/****** Object:  StoredProcedure [dbo].[InsertIntoShAcceleratedVesting]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================================
-- Author      :  omprakash katre                                                                      -
-- Description :  This procedure will enter recored into ShAcceleratedVesting and AcceleratedRemarks   -
--                After performing accelerated vesting at scheme,grant and employee levels.            -
-- Note        :  SchemeLevel=1, GrantLevel=2  EmployeeLevel =3                                        -
-- =====================================================================================================

CREATE PROCEDURE [dbo].[InsertIntoShAcceleratedVesting]
   @AcceleratedType varchar(20),
   @AcceleratedVestingDate datetime,
   @LastUpdatedBy varchar(20),
   @AcceleratedVestingId int,
   @SchemeId VARCHAR(20),
   @GrantDate datetime=NULL,
   @GrantRegId varchar(20)=NULL,
   @GrantoptionId varchar(100)=NULL,
   @EmployeeId varchar(20)=NULL,
   @Remarks varchar(100)
AS
BEGIN
    -- SchemeLevel
    IF(@AcceleratedType ='schemeLevel')
    BEGIN
	  INSERT INTO ShAcceleratedVesting 
	          VALUES(@AcceleratedVestingDate,@LastUpdatedBy,GETDATE(),@SchemeId,@AcceleratedVestingId)
	  INSERT INTO AcceleratedRemarks
	          VALUES(@AcceleratedVestingId,@GrantDate,@GrantRegId,@EmployeeId,@GrantoptionId,@Remarks,'Y',1)
	END
	
	--GrantLevel
    IF(@AcceleratedType ='grantLevel')
    BEGIN
	  INSERT INTO ShAcceleratedVesting 
	          VALUES(@AcceleratedVestingDate,@LastUpdatedBy,GETDATE(),@SchemeId,@AcceleratedVestingId)
	  INSERT INTO AcceleratedRemarks
	           VALUES(@AcceleratedVestingId,@GrantDate,@GrantRegId,@EmployeeId,@GrantoptionId,@Remarks,'Y',2)
	END
	
	--Employee Level
	IF(@AcceleratedType ='employeeLevel')
    BEGIN
	  INSERT INTO ShAcceleratedVesting 
	          VALUES(@AcceleratedVestingDate,@LastUpdatedBy,GETDATE(),(select SchemeId from GrantOptions where GrantOptionId=@GrantoptionId),@AcceleratedVestingId)
	  INSERT INTO AcceleratedRemarks
	            VALUES(@AcceleratedVestingId,@GrantDate,@GrantRegId,@EmployeeId,@GrantoptionId,@Remarks,'Y',3)
   END	            
END
GO
