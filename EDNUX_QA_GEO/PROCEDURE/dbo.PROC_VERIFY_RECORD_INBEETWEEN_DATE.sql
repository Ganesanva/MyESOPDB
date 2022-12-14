/****** Object:  StoredProcedure [dbo].[PROC_VERIFY_RECORD_INBEETWEEN_DATE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_VERIFY_RECORD_INBEETWEEN_DATE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_VERIFY_RECORD_INBEETWEEN_DATE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_VERIFY_RECORD_INBEETWEEN_DATE]
	-- Add the parameters for the stored procedure here
	(			
			@MobilityDataTable   TYPE_DELETE_MOBILITY_DATA_TABLE READONLY,
			@MESSAGE_OUT         NVARCHAR(100) OUT
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE 
	@Field               AS NVARCHAR(50),			
	@EmployeeId          AS NVARCHAR(50),			
	@FromDate            AS Date,
	@DateOfMovement      AS NVARCHAR(150),
	@RecordCount         INT,
	@Count               INT


	DECLARE @MIN_Record INT;
	DECLARE @MAX_Record INT;
	SELECT @MIN_Record=MIN(X.RowNumber), @MAX_Record=MAX(X.RowNumber)
	FROM
	(
		SELECT ROW_NUMBER() OVER(ORDER BY EmployeeID) AS RowNumber, * FROM @MobilityDataTable
	)X
	
    WHILE (@MIN_Record <= @MAX_Record)  
    BEGIN          
        
		 
	SELECT @Field =Field, @EmployeeId = EmployeeId  ,@FromDate = FromDate
	FROM
	(
		SELECT ROW_NUMBER() OVER(ORDER BY EmployeeID) AS RowNumber, * FROM @MobilityDataTable
	)X WHERE X.RowNumber=@MIN_Record
	
	
	SET @DateOfMovement = null;
	SET @Count=0;
	SELECT top(1) @DateOfMovement=Format([From Date of Movement],'dd-MMM-yyyy'),@Count=COUNT(SRNO) 
	FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD  
	WHERE EmployeeId=@EmployeeId 
	AND Field =@Field AND [From Date of Movement] > convert(date,@FromDate, 126) 	    
	group by Format([From Date of Movement],'dd-MMM-yyyy')
	order by Format([From Date of Movement],'dd-MMM-yyyy') Asc	
	  
	   IF @Count > 0
	   BEGIN	     
	        IF NOT EXISTS(SELECT * FROM @MobilityDataTable  WHERE EmployeeId=@EmployeeId AND Field =@Field AND FromDate = @DateOfMovement)
	        BEGIN	      		  
	   		    SET @MESSAGE_OUT = @EmployeeId
		        BREAK;			   
	   	    End
	        ELSE
	        BEGIN
	              SET @MESSAGE_OUT='1'
	        END	   	  
       END
	ELSE
	BEGIN
	        SET @MESSAGE_OUT='1'
	END
	   

	SET @MIN_Record = @MIN_Record + 1;
	END	
	if @@ERROR <> 0
	BEGIN
	SET @MESSAGE_OUT = 'Error'
	END
	
END  
GO
