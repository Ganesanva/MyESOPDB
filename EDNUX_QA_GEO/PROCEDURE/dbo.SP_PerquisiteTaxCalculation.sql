/****** Object:  StoredProcedure [dbo].[SP_PerquisiteTaxCalculation]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_PerquisiteTaxCalculation]
GO
/****** Object:  StoredProcedure [dbo].[SP_PerquisiteTaxCalculation]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_PerquisiteTaxCalculation] 
	@EmployeeId VARCHAR(20) ,
  	@GrantOption_id VARCHAR(100),
  	@ExerciseNo numeric (10)= NULL
AS 
BEGIN 
	
	SET nocount ON; 

    DECLARE @GrantOptionId VARCHAR(100) 
    DECLARE @Action CHAR ,@LastUpdatedOn DateTime
    DECLARE @RowNum INT 
    DECLARE @MinId INT, @MaxId INT 
	
	CREATE TABLE #tempTaxPram
	(
		Idt				INT IDENTITY (1, 1),
		EMPLOYEEID		VARCHAR(20) ,
		GRANTOPTIONID	VARCHAR(100) ,
		PERQTAXRULE		CHAR(1),
		CALCPERQVAL		CHAR(1),
		CALCPERQTAX		CHAR(1),
		CALCPERQPARAM	CHAR(1),
		PERQTAXTARE		NUMERIC(18,6),
	)

	CREATE TABLE #tempgrantoptions
	(
		Idt           INT IDENTITY (1,1),
		GRANTOPTIONID VARCHAR(100)
	)

	IF @GrantOption_id != ''
	BEGIN
		--Print(@GrantOption_id)
		INSERT INTO #tempgrantoptions (GRANTOPTIONID) values (@GrantOption_id)
	END
	ELSE
	BEGIN
		INSERT INTO #tempgrantoptions (GRANTOPTIONID) 
		(SELECT DISTINCT( GRANTOPTIONID ) AS GRANTOPTIONID 
		FROM   GrantOptions 
		WHERE  EmployeeId = @EmployeeId) 
	END

	SELECT @MinId = Min(Idt), @MaxId = Max(Idt) FROM   #tempgrantoptions

	PRINT 'MINID--' 
	PRINT  @MinId;
	PRINT 'MAXID--' 
	PRINT  @MaxId;
	
  	WHILE (@MinId <= @MaxId)
    BEGIN 
    
		SELECT @GrantOptionId=Grantoptionid from #tempgrantoptions where Idt=@MinId
        IF EXISTS (SELECT 1 
                   FROM   PerqstTaxExceptionRule 
                   WHERE  ( Grantoptionid = @GrantOptionId ) 
                          AND ( Employeeid = @EmployeeId )) 
          -- If grant available in PerqstTaxExceptionRule rule table  
          BEGIN 
          PRINT 'Grant' + @GrantOptionId
              SELECT TOP 1 @Action = Action ,@LastUpdatedOn=LastUpdatedOn
              FROM   PerqstTaxExceptionRule 
              WHERE  ( Grantoptionid = @GrantOptionId ) 
                     AND ( Employeeid = @EmployeeId ) 
              ORDER  BY LastUpdatedOn DESC 

			  Print 'Action' + @Action
              IF( ( @Action = 'A' ) 
                   OR ( @Action = 'E' ) ) 
                BEGIN 
                print 'PTER'
                INSERT INTO #tempTaxPram (EMPLOYEEID,GRANTOPTIONID,PERQTAXRULE,CALCPERQVAL,CALCPERQTAX,PERQTAXTARE)
                (
                
                    SELECT  PTER.Employeeid,
						    PTER.Grantoptionid,
						    'G'                AS PerqRuleType, 
                             PTER.PerqValue     AS calPerqValue, 
                             PTER.PerqTax       AS calPerqTax, 
                             dbo.FN_PQ_TAX_ROUNDING(Perq_tax_rate) AS PerqTax
                    FROM   PerqstTaxExceptionRule AS PTER 
                    WHERE  PTER.Grantoptionid = @GrantOptionId AND  PTER.Employeeid = @EmployeeId AND  PTER.Action = @Action AND PTER.LastUpdatedOn=@LastUpdatedOn)
                END 
              ELSE 
                BEGIN 
                PRINT 'Comp' + @GrantOptionId
                INSERT INTO #tempTaxPram (EMPLOYEEID,GRANTOPTIONID,PERQTAXRULE,CALCPERQVAL,CALCPERQTAX,PERQTAXTARE)
                    EXEC Sp_perquisitetaxfromcompanyparameter @EmployeeId ,@GrantOptionId, @ExerciseNo
                END 
          END 
        ELSE 
          BEGIN 
               PRINT 'Comp' + @GrantOptionId
          INSERT INTO #tempTaxPram (EMPLOYEEID,GRANTOPTIONID,PERQTAXRULE,CALCPERQVAL,CALCPERQTAX,PERQTAXTARE)
              EXEC dbo.Sp_perquisitetaxfromcompanyparameter @EmployeeId ,@GrantOptionId,@ExerciseNo
          END 

        SET @MinId=@MinId + 1; 
    END 
   
    UPDATE 
		#tempTaxPram  
	SET CALCPERQPARAM =  CASE WHEN (CALCPERQVAL='Y') and (CALCPERQTAX='Y') THEN 'B'
							  WHEN (CALCPERQVAL='Y') and (CALCPERQTAX='N' OR CALCPERQTAX IS NULL ) THEN 'V' ELSE 'F' END   

	SELECT Idt,EMPLOYEEID,GRANTOPTIONID,PERQTAXRULE,CALCPERQVAL,CALCPERQTAX,CALCPERQPARAM,dbo.FN_PQ_TAX_ROUNDING(PERQTAXTARE)AS PERQTAXTARE from #tempTaxPram
	
	IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_PERQTAXCALCULATION')
		DROP TABLE TEMP_PERQTAXCALCULATION

	SELECT * INTO TEMP_PERQTAXCALCULATION FROM #tempTaxPram
END
GO
