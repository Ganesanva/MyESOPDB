/****** Object:  StoredProcedure [dbo].[Insert_DeferredCashGrantValue]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Insert_DeferredCashGrantValue]
GO
/****** Object:  StoredProcedure [dbo].[Insert_DeferredCashGrantValue]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Insert_DeferredCashGrantValue]    
AS    
BEGIN    

DECLARE  
		@Id VARCHAR(50),
		@CashgrantId  VARCHAR(50),
	    @Action CHAR(1) ,
		@PayoutTranchId INT ,
		@EmployeeId NVARCHAR(20)  ,
		@EmployeeNAme NVARCHAR(50)  ,
		@SchemeName NVARCHAR(500)  ,
		@GrantFinancialYear NVARCHAR(50)  ,	
		@GrantID 	NVARCHAR(50)   ,
		@GrantDate DATETIME  ,	
		@GrantAmount	NUMERIC(22, 2)  ,
		@Currency VARCHAR(100) ,
		@PayOutdueDate  DATETIME  ,
		@PayOutDistribution NUMERIC(22, 2)  ,
		@PayOutCategory  NVARCHAR(50) ,
		@GrossPayoutAmount  NUMERIC(22, 2)  ,
		@TaxDeducted NUMERIC(22, 2)  ,
		@NetPayoutAmount  NUMERIC(22, 2)  ,
	    @PayOutDate  DATETIME  ,
		@PayOutRevesion NUMERIC(22, 2)  ,
		@DateOfRevision  DATETIME  ,
		@ReasoForRevision NVARCHAR(50)  ,
        @CREATED_BY NVARCHAR(100) = null ,
		@CREATED_ON DATETIME ,
		@UPDATED_BY NVARCHAR(100)= null  ,
		@UPDATED_ON DATETIME  ,		
	    @QueryExecutionON DATETIME ,
        @StatusType CHAR(1) ,
        @Remark NVARCHAR(50)  ,
      @DEFER_ACTION VARCHAR(50)
	,@LOGQUERY  NVARCHAR(3000) 
	,@QUERY NVARCHAR(3000)
   ,@updateQUERY  NVARCHAR(3000) 


SET @QUERY =     
'INSERT INTO DeferredCashGrant     
 (    
  Action,	PayoutTranchId,	EmployeeId	,EmployeeNAme,	SchemeName,	GrantFinancialYear	,GrantID,	GrantDate,	GrantAmount	,Currency	,PayOutdueDate	,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,	TaxDeducted,	NetPayoutAmount,	PayOutDate,	PayOutRevesion	,DateOfRevision	,ReasoForRevision
  ,CREATED_ON,UPDATED_ON,CREATED_BY,UPDATED_BY
    
 )     
 (    
  SELECT Action,PayoutTranchId,	EmployeeId	,EmployeeNAme,	SchemeName,	GrantFinancialYear	,GrantID,	GrantDate,	GrantAmount	,Currency	,PayOutdueDate	,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,	TaxDeducted,	NetPayoutAmount,	PayOutDate,	PayOutRevesion	,DateOfRevision	,ReasoForRevision
  ,GETDATE(),GETDATE(),
''Admin'',''Admin'' FROM TempDeferredCashGrant  WHERE Id= '   
 

	DECLARE DEFER_DTA_CURSOR CURSOR FOR  SELECT Id,CashgrantId,[Action],PayoutTranchId,	EmployeeId	,EmployeeNAme,	SchemeName,	GrantFinancialYear	,GrantID,	GrantDate,	GrantAmount	,Currency	,PayOutdueDate	,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,	TaxDeducted,	NetPayoutAmount,	PayOutDate,	PayOutRevesion	,DateOfRevision	,ReasoForRevision
	FROM TempDeferredCashGrant

	print 1
	OPEN DEFER_DTA_CURSOR     
    
	FETCH NEXT FROM DEFER_DTA_CURSOR INTO @ID,@CashgrantId ,@ACTION, @PayoutTranchId,	@EmployeeId	,@EmployeeNAme,@SchemeName,	@GrantFinancialYear	,@GrantID,	@GrantDate,@GrantAmount,@Currency	,@PayOutdueDate	,@PayOutDistribution	,@PayOutCategory	,@GrossPayoutAmount,	@TaxDeducted,@NetPayoutAmount,	@PayOutDate,	@PayOutRevesion	,@DateOfRevision	,@ReasoForRevision
	print 6
	WHILE (@@FETCH_STATUS = 0)    
	BEGIN     
	 
	 SET @DEFER_ACTION = (SELECT TOP 1 [Action]  FROM DeferredCashGrant WHERE EmployeeId = @EmployeeId AND Id = @CashgrantId ) 
	 --(SELECT TOP 1 [Action]  FROM DeferredCashGrant WHERE EmployeeId = @EmployeeId and GrantID =@GrantID ORDER BY UPDATED_ON DESC  )    
     print 999999999999
	 SET @DEFER_ACTION = (ISNULL(@DEFER_ACTION,'NA')) 
    
	 print 2
	 PRINT @DEFER_ACTION
	 print @ACTION 
     print 3


	 IF((@DEFER_ACTION ='NA') AND (@ACTION = 'A'))    
	 BEGIN  
	 print @Id
	 print @QUERY  
		    EXEC ( @QUERY + @Id + ')' )     
		  SET @LOGQUERY = 'UPDATE TempDeferredCashGrant SET STATUSTYPE=''Y'',QueryExecutionON=GETDATE(), REMARK=''SUCCESSFUL'' where Id='+ @Id +''    
		  EXEC (@LOGQUERY)    
	 END     
	 ELSE IF((@ACTION = 'E'))    
	 BEGIN    
		  SET @LOGQUERY =  'UPDATE TempDeferredCashGrant SET STATUSTYPE =''N'',QueryExecutionON=GETDATE(), Remark=''Please enter correct action code'' Where Id='+@Id+''    
		  EXEC (@LOGQUERY)    
	 END    
	 ELSE    
	 BEGIN 
	 print 66
		  SET @LOGQUERY =  'UPDATE TempDeferredCashGrant SET STATUSTYPE =''N'',QueryExecutionON=GETDATE(), Remark=''Please enter correct action code'' Where Id='+@Id+''    
		  EXEC (@LOGQUERY)    
	 END  
	 
	 print 777
	 --A    
	 IF(@ACTION = 'A')    
	 BEGIN    
	 IF ((@DEFER_ACTION = 'A') OR (@DEFER_ACTION = 'E'))     
	 BEGIN   
	 
	   PRINT 'Data Already Exists for Employee with Action = "' + @DEFER_ACTION + '"'   

		   SET @LOGQUERY = 'UPDATE TempDeferredCashGrant SET STATUSTYPE =''N'',QueryExecutionON=GETDATE(), Remark=''Data Already Exists for Employee with Action ="' + @DEFER_ACTION + '"'' Where Id='+@Id+''    
		   EXEC (@LOGQUERY)       
	 END     
	 ELSE IF (@DEFER_ACTION = 'D')    
	 BEGIN    
	 print 6786876
	   EXEC (@QUERY + @DEFER_ACTION + ')')       
	   SET @LOGQUERY = 'UPDATE TempDeferredCashGrant SET STATUSTYPE=''Y'',QueryExecutionON=GETDATE(), REMARK=''SUCCESSFUL'' where Id='+@Id+''    
	   EXEC (@LOGQUERY)    
	 END     
	 END    
      
	  ---E or ---D    
	  ELSE IF ((@ACTION = 'E') OR (@ACTION = 'D'))    
	  BEGIN   
	  
	  print 767
	  IF ((@DEFER_ACTION = 'A') OR (@DEFER_ACTION = 'E'))     
	  BEGIN    

			SET @updateQUERY  = 'UPDATE DeferredCashGrant SET  Action = '''+@Action+''',	PayoutTranchId = '+ CONVERT(varchar, @PayoutTranchId)+',SchemeName = '''+ @SchemeName +'''	,		
			
			GrantFinancialYear  = '''+@GrantFinancialYear +'''	,GrantID = '''+@GrantID +''',	GrantDate = ''' +CONVERT(varchar, @GrantDate)+''',	GrantAmount = '+CONVERT(VARCHAR,@GrantAmount)+'	,Currency = '''+@Currency+'''	,PayOutdueDate = '''+CONVERT(varchar, @PayOutdueDate)+'''	,PayOutDistribution = '+ CONVERT(VARCHAR,@PayOutDistribution)+'	
			,PayOutCategory	  = '''+@PayOutCategory +''',GrossPayoutAmount  = '+CONVERT(VARCHAR, @GrossPayoutAmount) +',	TaxDeducted  = '+CONVERT(VARCHAR, @TaxDeducted )+',	NetPayoutAmount  = '+CONVERT(VARCHAR, @NetPayoutAmount)+',	PayOutDate  = '''+CONVERT(varchar,@PayOutDate )+''',	PayOutRevesion  = '+CONVERT(VARCHAR, @PayOutRevesion) +'	,DateOfRevision	  = '''+CONVERT(varchar, @DateOfRevision )+''',ReasoForRevision  = '''+@ReasoForRevision +'''			
			WHERE Id='+@CashgrantId+'' 
			 
		
			EXEC (@updateQUERY)
			SET @LOGQUERY = 'UPDATE TempDeferredCashGrant SET STATUSTYPE=''Y'',QueryExecutionON=GETDATE(), REMARK=''SUCCESSFUL'' where Id='+@Id+''    
			EXEC (@LOGQUERY)       
	  END    
	  ELSE IF (@DEFER_ACTION = 'D')    
	  BEGIN    
	   PRINT 'Data won''t be deleted as Action exists is of type = D'    
		   SET @LOGQUERY =  'UPDATE TempDeferredCashGrant SET STATUSTYPE =''N'',QueryExecutionON=GETDATE(), Remark=''Please enter correct action code'' Where Id='+@Id+''    
		   EXEC (@LOGQUERY)    
		   --  SET @LOGQUERY = 'Delete from DeferredCashGrant  where Id='+@Id+' '   
	   EXEC (@LOGQUERY)    


	   --SET @RESULT = 'Data won''t be deleted as Action exists is of type = D'    
	  END       
	  END    
      
	 FETCH NEXT FROM DEFER_DTA_CURSOR INTO  @ID,@CashgrantId, @ACTION, @PayoutTranchId,	@EmployeeId	,@EmployeeNAme,@SchemeName,	@GrantFinancialYear	,@GrantID,	@GrantDate,@GrantAmount,@Currency	,@PayOutdueDate	,@PayOutDistribution	,@PayOutCategory	,@GrossPayoutAmount,	@TaxDeducted,@NetPayoutAmount,	@PayOutDate,	@PayOutRevesion	,@DateOfRevision	,@ReasoForRevision

	END    
 
	CLOSE DEFER_DTA_CURSOR       
	DEALLOCATE DEFER_DTA_CURSOR     
    
	SELECT  Row_number() over (order by Id) as Id, Action,	PayoutTranchId,	EmployeeId	,EmployeeNAme,	SchemeName,	GrantFinancialYear	,GrantID,	GrantDate,	GrantAmount	,Currency	,PayOutdueDate	,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,	TaxDeducted,	NetPayoutAmount,	PayOutDate,	PayOutRevesion	,DateOfRevision	,ReasoForRevision  
	   , CASE WHEN StatusType='N' THEN 'Fail' WHEN StatusType='Y' THEN 'Successful'     
		 END StatusType    ,Remark,[Action]
	FROM TempDeferredCashGrant    
	WHERE StatusType='N'    
      
END 
GO
