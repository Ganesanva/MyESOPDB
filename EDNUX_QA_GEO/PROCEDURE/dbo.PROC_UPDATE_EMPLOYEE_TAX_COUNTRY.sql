/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_EMPLOYEE_TAX_COUNTRY]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_EMPLOYEE_TAX_COUNTRY]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_EMPLOYEE_TAX_COUNTRY]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_UPDATE_EMPLOYEE_TAX_COUNTRY]
	-- Add the parameters for the stored procedure here
	(
			@UpdatedBy     AS VARCHAR(50),
			@MobilityDataTable   TYPE_DELETE_MOBILITY_DATA_TABLE READONLY,			
			@MESSAGE_OUT   AS VARCHAR(50) OUTPUT
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
	
	
	        IF EXISTS(SELECT * FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD  WHERE EmployeeId=@EmployeeId AND Field = @Field AND [From Date of Movement] = @FromDate)
	        BEGIN
	             DECLARE @Date NVARCHAR(50)
	             DECLARE @country NVARCHAR(50)
		         
	             SELECT @Date = FromDate FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD  
		         WHERE EmployeeId=@EmployeeId AND Field = @Field AND [From Date of Movement] = @FromDate
		         
		         SELECT @country =  [Moved To] FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD  
		         WHERE EmployeeId=@EmployeeId AND Field = @Field AND [From Date of Movement] = @Date
		 
		         UPDATE EmployeeMaster SET  LastUpdatedBy=@UpdatedBy,LastUpdatedOn=GETDATE(), TAX_IDENTIFIER_COUNTRY=(SELECT ID FROM CountryMaster WHERE CountryName=@country) where EmployeeID=@EmployeeId                
	            
				 SET @MESSAGE_OUT = '1'
	        END
	        ELSE
	        BEGIN
	                SET @MESSAGE_OUT = '0'
	        END
			
    SET @MIN_Record = @MIN_Record + 1;
    END	

    if @@ERROR <> 0
    BEGIN
    SET @MESSAGE_OUT = 'Error'
    END
	
END  
GO
