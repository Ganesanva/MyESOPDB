/****** Object:  StoredProcedure [dbo].[PROC_SendAlertWhenDiffInStkPrice]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SendAlertWhenDiffInStkPrice]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SendAlertWhenDiffInStkPrice]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
CREATE PROCEDURE [dbo].[PROC_SendAlertWhenDiffInStkPrice]
AS
BEGIN
      DECLARE @CUR                          CURSOR,
                  @DB_NAME                      VARCHAR(50),
                  @STR                          NVARCHAR(1000),
                  @PARAMETERS                   NVARCHAR(500),
                  @COUNT                        INT,
                  @MAX_PRICEDATE                DATE,
                  @ONELESS_MAX_PRICEDATE        DATE,
                  @N_CLOSEPRICE_MAXDATE         NUMERIC(18, 2),
                  @B_CLOSEPRICE_MAXDATE         NUMERIC(18, 2),
                  @N_CLOSEPRICE_ONELESS_MAXDATE NUMERIC(18, 2),
                  @B_CLOSEPRICE_ONELESS_MAXDATE NUMERIC(18, 2),
                  @N_FIVE_PERCENT_ONELESS_MAXDT NUMERIC(18, 2),
                  @B_FIVE_PERCENT_ONELESS_MAXDT NUMERIC(18, 2),
                  @N_DIFF_CLOSEPRICE            NUMERIC(18, 2),
                  @B_DIFF_CLOSEPRICE            NUMERIC(18, 2),
                  @B_LOWER                      NUMERIC(18, 2),
                  @B_UPPER                      NUMERIC(18, 2),
                  @N_LOWER                      NUMERIC(18, 2),
                  @N_UPPER                      NUMERIC(18, 2),
                  @LISTEDYN                     CHAR,
                  @bool                         CHAR,
                  @EMAIL_TO                     VARCHAR(256),
                  @max_MsgId                                Numeric(18,0),
                  @subject                            varchar(100)

      SET @CUR= CURSOR forward_only
      FOR SELECT name
            FROM   sys.databases
            WHERE  database_id > 4
            ORDER  BY name

      OPEN @CUR

      FETCH next FROM @CUR INTO @DB_NAME

      WHILE @@FETCH_STATUS = 0
        BEGIN
              --------------------------CHECKS IF COMPANY PARAMETERS TABLE IS PRESENT IN THE DATABASE AND LISTEDYN =Y-----------------------------------------------------------------------------------------
              SET @STR =N'SELECT @COUNT= COUNT(*) FROM ' + @DB_NAME
                              + '..COMPANYPARAMETERS'
              SET @PARAMETERS=N'@COUNT INT OUTPUT'

              EXEC Sp_executesql
                  @STR,
                  @PARAMETERS,
                  @COUNT output

              --PRINT @COUNT
              SET @PARAMETERS=N'@LISTEDYN CHAR OUTPUT'
              SET @STR=N'SELECT @LISTEDYN= LISTEDYN FROM '
                           + @DB_NAME + '..COMPANYPARAMETERS'

              EXECUTE Sp_executesql
                  @STR,
                  @PARAMETERS,
                  @LISTEDYN output

              --PRINT @LISTEDYN+' '+CONVERT(VARCHAR,@COUNT)+' '+@DB_NAME
              IF ( @COUNT = 1
                     AND @LISTEDYN = 'Y' )
                  BEGIN
                        SET @STR=N'SET @MAX_PRICEDATE=( SELECT TOP 1 PRICEDATE FROM '
                                     + @DB_NAME
                                     + '..FMVSHAREPRICES ORDER BY PRICEDATE DESC)'
                        SET @PARAMETERS=N'@MAX_PRICEDATE DATE OUTPUT'

                        EXECUTE Sp_executesql
                          @STR,
                          @PARAMETERS,
                          @MAX_PRICEDATE output

                        --PRINT CONVERT(VARCHAR, @MAX_PRICEDATE) + ' MAX_DATE ' + @DB_NAME

                        SET @STR=N'SET @ONELESS_MAX_PRICEDATE=(SELECT TOP 1 PRICEDATE FROM '
                                     + @DB_NAME
                                     +
      '..FMVSHAREPRICES WHERE CONVERT(VARCHAR,PRICEDATE,127)<(SELECT TOP 1 SUBSTRING(CONVERT(VARCHAR,PRICEDATE,127),0,11) FROM '
                   + @DB_NAME
                   + '..FMVSHAREPRICES ORDER BY PRICEDATE DESC)ORDER BY PRICEDATE DESC)'
            SET @PARAMETERS=N'@ONELESS_MAX_PRICEDATE DATE OUTPUT'

            EXECUTE Sp_executesql
              @STR,
              @PARAMETERS,
              @ONELESS_MAX_PRICEDATE output

            --PRINT CONVERT(VARCHAR, @ONELESS_MAX_PRICEDATE)+ ' ONE_LESS ' + @DB_NAME

            IF ( CONVERT(VARCHAR, @MAX_PRICEDATE, 103) =
                   CONVERT(VARCHAR, Getdate(), 103) )
              BEGIN
            
                    SET @PARAMETERS=N'@EMAIL_TO VARCHAR(256) OUTPUT'
                    SET @STR= 'SELECT @EMAIL_TO= COMPANYEMAILID FROM '
                                    + @DB_NAME + '..COMPANYMASTER'

                    EXEC Sp_executesql
                        @STR,
                        @PARAMETERS,
                        @EMAIL_TO output

                    --PRINT @EMAIL_TO
                
              

                    SET @PARAMETERS=
                    N'@MAX_PRICEDATE DATETIME,@N_CLOSEPRICE_MAXDATE NUMERIC(18,2) OUTPUT'
                    SET @STR='SELECT @N_CLOSEPRICE_MAXDATE =CLOSEPRICE FROM '
                                 + @DB_NAME
                                 +
      '..FMVSHAREPRICES WHERE PRICEDATE=@MAX_PRICEDATE AND STOCKEXCHANGE=''N'''

      EXEC Sp_executesql
        @STR,
        @PARAMETERS,
        @MAX_PRICEDATE,
        @N_CLOSEPRICE_MAXDATE output

      --PRINT convert(varchar,@N_CLOSEPRICE_MAXDATE)+' @N_CLOSEPRICE_MAXDATE '
      SET @PARAMETERS=
      N'@MAX_PRICEDATE DATETIME,@B_CLOSEPRICE_MAXDATE NUMERIC(18,2) OUTPUT'
      SET @STR='SELECT @B_CLOSEPRICE_MAXDATE =CLOSEPRICE FROM '
                   + @DB_NAME
                   +'..FMVSHAREPRICES WHERE PRICEDATE=@MAX_PRICEDATE AND STOCKEXCHANGE=''B'''

      EXEC Sp_executesql
        @STR,
        @PARAMETERS,
        @MAX_PRICEDATE,
        @B_CLOSEPRICE_MAXDATE output

      --PRINT @B_CLOSEPRICE_MAXDATE
      SET @PARAMETERS=
      N'@ONELESS_MAX_PRICEDATE DATETIME,@N_CLOSEPRICE_ONELESS_MAXDATE NUMERIC(18,2) OUTPUT'
      SET @STR=N'SELECT @N_CLOSEPRICE_ONELESS_MAXDATE =CLOSEPRICE FROM '
               + @DB_NAME
               +'..FMVSHAREPRICES WHERE PRICEDATE=@ONELESS_MAX_PRICEDATE AND STOCKEXCHANGE=''N'''

      EXEC Sp_executesql
      @STR,
      @PARAMETERS,
      @ONELESS_MAX_PRICEDATE,
      @N_CLOSEPRICE_ONELESS_MAXDATE output

      --PRINT convert(varchar,@N_CLOSEPRICE_ONELESS_MAXDATE)+'  @N_CLOSEPRICE_ONELESS_MAXDATE'
      SET @PARAMETERS=
      N'@ONELESS_MAX_PRICEDATE DATETIME,@B_CLOSEPRICE_ONELESS_MAXDATE NUMERIC(18,2) OUTPUT'
      SET @STR='SELECT @B_CLOSEPRICE_ONELESS_MAXDATE =CLOSEPRICE FROM '
               + @DB_NAME
               +'..FMVSHAREPRICES WHERE PRICEDATE=@ONELESS_MAX_PRICEDATE AND STOCKEXCHANGE=''B'''

      EXEC Sp_executesql
      @STR,
      @PARAMETERS,
      @ONELESS_MAX_PRICEDATE,
      @B_CLOSEPRICE_ONELESS_MAXDATE output

      --PRINT convert(varchar,@B_CLOSEPRICE_ONELESS_MAXDATE)+'  @B_CLOSEPRICE_ONELESS_MAXDATE'
      SELECT @N_DIFF_CLOSEPRICE = (@N_CLOSEPRICE_MAXDATE - @N_CLOSEPRICE_ONELESS_MAXDATE)

      SELECT @B_DIFF_CLOSEPRICE = (@B_CLOSEPRICE_MAXDATE - @B_CLOSEPRICE_ONELESS_MAXDATE)

      SET @N_FIVE_PERCENT_ONELESS_MAXDT=0.05 * @N_CLOSEPRICE_ONELESS_MAXDATE
      SET @B_FIVE_PERCENT_ONELESS_MAXDT=0.05 * @B_CLOSEPRICE_ONELESS_MAXDATE
      SET @N_DIFF_CLOSEPRICE=Abs(@N_DIFF_CLOSEPRICE)
      SET @B_DIFF_CLOSEPRICE=Abs(@B_DIFF_CLOSEPRICE)
      SET @N_UPPER= (@N_CLOSEPRICE_ONELESS_MAXDATE + @N_FIVE_PERCENT_ONELESS_MAXDT)
      SET @N_LOWER= (@N_CLOSEPRICE_ONELESS_MAXDATE - @N_FIVE_PERCENT_ONELESS_MAXDT)
      SET @B_UPPER= (@B_CLOSEPRICE_ONELESS_MAXDATE + @B_FIVE_PERCENT_ONELESS_MAXDT)
      SET @B_LOWER= (@B_CLOSEPRICE_ONELESS_MAXDATE - @B_FIVE_PERCENT_ONELESS_MAXDT)

      --PRINT CONVERT(VARCHAR, @N_CLOSEPRICE_MAXDATE)+ '  @N_CLOSEPRICE_MAXDATE'

      --PRINT CONVERT (VARCHAR, @N_LOWER) + ' @N_LOWER '

      --PRINT CONVERT(VARCHAR, @N_UPPER) + ' @N_UPPER '

      --PRINT CONVERT(VARCHAR, @B_CLOSEPRICE_MAXDATE)+ '   @B_CLOSEPRICE_MAXDATE'

      --PRINT CONVERT(VARCHAR, @B_UPPER) + '  @B_UPPER'

      --PRINT CONVERT(VARCHAR, @B_lower) + '  @B_lower'

      ------------------------------------------------------------------------------------      
      IF ( @B_CLOSEPRICE_MAXDATE <= @B_LOWER
            OR @B_CLOSEPRICE_MAXDATE >= @B_UPPER )
       AND ( @N_CLOSEPRICE_MAXDATE <= @N_LOWER
                  OR @N_CLOSEPRICE_MAXDATE >= @N_UPPER )
      SET @bool=1

      ELSE IF ( @N_CLOSEPRICE_MAXDATE <= @N_LOWER
            OR @N_CLOSEPRICE_MAXDATE >= @N_UPPER )
      SET @bool=1
      ELSE IF @B_CLOSEPRICE_MAXDATE <= @B_LOWER
        OR @B_CLOSEPRICE_MAXDATE >= @B_UPPER
      SET @bool=1

      IF ( @bool = 1 )
      BEGIN
                          select  @max_MsgId= MAX(messageid) from mailerdb..mailspool
                          select @subject= convert(varchar,GETDATE(),103)+' : '+@DB_NAME+' : ' +' Difference in closing stockprice is more than 5%.'
      --print @max_msgid
            INSERT INTO mailerdb..mailspool(MessageID, [From], [To], [Subject], [Description], Attachment1, Attachment2, Attachment3, Attachment4, MailSentOn,
											Cc, enablereadreceipt, deliveryNotify, Bcc )
            SELECT   @max_MsgId+1,  'esopit@esopdirect.com',
                     @EMAIL_TO,
                     @subject,
                     CASE
                         WHEN ( @B_CLOSEPRICE_MAXDATE <= @B_LOWER
                                     OR @B_CLOSEPRICE_MAXDATE >= @B_UPPER )
                                AND ( @N_CLOSEPRICE_MAXDATE <= @N_LOWER
                                           OR @N_CLOSEPRICE_MAXDATE >= @N_UPPER ) THEN
                         'Hello,<br><br>

      There is more than 5% difference between closing  stock price of NSE and BSE.
      <br><br>

      Thanks<br>
      ESOP Direct'
                         WHEN ( @N_CLOSEPRICE_MAXDATE <= @N_LOWER
                                     OR @N_CLOSEPRICE_MAXDATE >= @N_UPPER ) THEN
                         'Hello,<br><br>

      There is more than 5% difference between closing  stock price of NSE.
      <br><br>

      Thanks<br>
      ESOP Direct'
                         WHEN ( @B_CLOSEPRICE_MAXDATE <= @B_LOWER
                                     OR @B_CLOSEPRICE_MAXDATE >= @B_UPPER ) THEN
                         'Hello,<br><br>

      There is more than 5% difference between closing  stock price of BSE.
      <br><br>

      Thanks<br>
      ESOP Direct'
                         ELSE NULL
                     END,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL
                
             

            SET @bool=0
         set @max_MsgId=null 
      END
      --select * from mailerdb..mailspool                                                 -------------------------------------------------------------------------------------                    
      END
      END

            SET @COUNT=NULL

            FETCH next FROM @CUR INTO @DB_NAME
      END 
END
GO
