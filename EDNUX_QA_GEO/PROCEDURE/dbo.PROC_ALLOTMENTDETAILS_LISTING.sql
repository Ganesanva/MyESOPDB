/****** Object:  StoredProcedure [dbo].[PROC_ALLOTMENTDETAILS_LISTING]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_ALLOTMENTDETAILS_LISTING]
GO
/****** Object:  StoredProcedure [dbo].[PROC_ALLOTMENTDETAILS_LISTING]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_ALLOTMENTDETAILS_LISTING]
	@AllottmentDate DATETIME
AS	
BEGIN
			
			-- Create temp table for emp exercised details
			CREATE TABLE #EMP_TEMP_EXERCISED
				(			
					EmployeeID NVARCHAR(50), CountryName NVARCHAR(300), Sharesarised NUMERIC(18,2), SARExerciseAmount NUMERIC(18,2), ExercisedId NVARCHAR(50), EmployeeName NVARCHAR(100), 	GrantRegistrationId NVARCHAR(100), GrantOptionId NVARCHAR(100), GrantDate DATETIME, 
					ExercisedQuantity NUMERIC(18,2), SharesAlloted NUMERIC(18,2), ExercisedDate DATETIME, ExercisedPrice NUMERIC(18,2), SchemeTitle NVARCHAR(100), OptionRatioMultiplier NUMERIC(18,2), SchemeId NVARCHAR(100), OptionRatioDivisor NUMERIC(18,2), 
					SharesIssuedDate DATETIME, DateOfPayment DATETIME, Parent NVARCHAR(10), VestingDate DATETIME,ExpiryDate DATETIME NULL, GrantLegId NVARCHAR(10), FBTValue NUMERIC(18,2), Cash NVARCHAR(10), SAR_PerqValue NVARCHAR(20), FaceValue NVARCHAR(20), PerqstValue NVARCHAR(20), PerqstPayable NVARCHAR(20), 
					FMVPrice NVARCHAR(20), FBTdays NVARCHAR(10), TravelDays NVARCHAR(10), PaymentMode NVARCHAR(30), PerqTaxRate NVARCHAR(20), ExerciseNo NVARCHAR(50), Exercise_Amount NVARCHAR(20), Date_of_Payment DATETIME, Account_number NVARCHAR(50), ConfStatus NVARCHAR(50), 
					DateOfJoining DATETIME, DateOfTermination DATETIME, Department NVARCHAR(300), EmployeeDesignation NVARCHAR(300), Entity NVARCHAR(300), Grade NVARCHAR(300), Insider NVARCHAR(300), ReasonForTermination NVARCHAR(300), SBU NVARCHAR(300), ResidentialStatus NVARCHAR(300),
					Itcircle_Wardnumber NVARCHAR(300), DepositoryName NVARCHAR(100), DepositoryParticipatoryname NVARCHAR(100), ConfirmationDate DATETIME, NameAsperDpRecord NVARCHAR(100), EmployeeAddress NVARCHAR(300), EmployeeEmail NVARCHAR(100), 
					EmployeePhone NVARCHAR(100), Pan_Girnumber NVARCHAR(15), DematACType NVARCHAR(50), DpIdNumber NVARCHAR(50), ClientIdNumber NVARCHAR(50), Location NVARCHAR(300), 
					OptionGranted NVARCHAR(100), MarketPrice NUMERIC(18,2), IsSARApplied NVARCHAR(10), lotnumber VARCHAR(50)
				)	
			INSERT INTO #EMP_TEMP_EXERCISED 
				(
					EmployeeID, CountryName, Sharesarised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, GrantOptionId, GrantDate, 
					ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice, SchemeTitle, OptionRatioMultiplier, SchemeId, OptionRatioDivisor, 
					SharesIssuedDate, DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, FaceValue, PerqstValue, PerqstPayable, 
					FMVPrice, FBTdays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, Date_of_Payment, Account_number, ConfStatus, 
					DateOfJoining , DateOfTermination, Department, EmployeeDesignation, Entity, Grade, Insider, ReasonForTermination, SBU, ResidentialStatus,
					Itcircle_Wardnumber, DepositoryName, DepositoryParticipatoryname, ConfirmationDate, NameAsperDpRecord, EmployeeAddress, EmployeeEmail, 
					EmployeePhone, Pan_Girnumber, DematACType, DpIdNumber, ClientIdNumber, Location, lotnumber
				)
			  EXECUTE PROC_CRExerciseReport '1901-01-01', @AllottmentDate ,NULL
			
			-- Allotted share details
			CREATE TABLE #ALLOTTED_SHARE
			(
			  CurrentDate VARCHAR(13),
			  SchemeDisplay VARCHAR(8000),
			  SharesIssuedAgainstOptExercised NUMERIC(18),
			  FaceValue DECIMAL(18,2),
			  ExercisePricePerShare VARCHAR(5000),
			  PremiumPerShare VARCHAR(5000),
			  TotalExrAmtOptsExercised DECIMAL(18,2),
			  GrantDate VARCHAR(MAX)
			)
			
			DECLARE @Names VARCHAR(8000),@ExPrice VARCHAR(8000),@FaceValue DECIMAL(18,2),
			        @SharesIssuedAgainstOptExercised NUMERIC(18,0),@TotalExrAmtOptsExercised DECIMAL(18,2),@PremiumPerShare VARCHAR(500), @GrantDate VARCHAR(MAX)
			-- Scheme comma separated
			SELECT  @Names=COALESCE(@Names + ', ', '') +  
			TEMP.Name 
			FROM 
			 (
				 SELECT DISTINCT LS.Name 
				 FROM #EMP_TEMP_EXERCISED E
				 INNER JOIN ListingDocSchConcatenation LS ON E.SchemeId=LS.SchemeID 
				 WHERE CONVERT(DATE,E.SharesIssuedDate)=CONVERT(DATE,@AllottmentDate)
			 )TEMP
            
			--Getting face value
			SELECT @FaceValue= FaceVaue	FROM CompanyParameters
            
            -- Share allotment on allotment date
            SELECT @SharesIssuedAgainstOptExercised=SUM(SharesAlloted),@TotalExrAmtOptsExercised=SUM(CONVERT(DECIMAL(18,2),ISNULL(Exercise_Amount,0)))
            FROM #EMP_TEMP_EXERCISED E
            WHERE CONVERT(DATE,E.SharesIssuedDate)=CONVERT(DATE,@AllottmentDate)
            
			-- Comma separated exercise price
			SELECT  @ExPrice=COALESCE(@ExPrice + ', ', '') +  
			TEMP.ExPrice 
			FROM 
			 (
				 SELECT DISTINCT CONVERT(VARCHAR(5000),E.ExercisedPrice) AS ExPrice
				 FROM #EMP_TEMP_EXERCISED E
				 WHERE CONVERT(DATE,E.SharesIssuedDate)=CONVERT(DATE,@AllottmentDate)
			 )TEMP
            
            -- Comma separated (Exercise price � Face value) 
            SELECT  @PremiumPerShare=COALESCE(@PremiumPerShare + ', ', '') +  
			TEMP.PremimumShare 
			FROM 
			 (
				 SELECT DISTINCT CONVERT(VARCHAR(5000),(E.ExercisedPrice-@FaceValue)) AS PremimumShare
				 FROM #EMP_TEMP_EXERCISED E
				 WHERE CONVERT(DATE,E.SharesIssuedDate)=CONVERT(DATE,@AllottmentDate)
			 )TEMP
			 
			-- Comma separated grant date , created table for get order by value of grant date
			 CREATE TABLE #TempGrantDate
			  (
			    StrGrantDate VARCHAR(50),
			    GrantDate DateTime
			  )
			  INSERT #TempGrantDate(StrGrantDate,GrantDate)
		      SELECT DISTINCT (REPLACE(CONVERT(VARCHAR(15),E.GrantDate,106),' ','-')) AS GrantDate,E.GrantDate
			  FROM #EMP_TEMP_EXERCISED E
			  WHERE CONVERT(DATE,E.SharesIssuedDate)=CONVERT(DATE,@AllottmentDate)
			  ORDER BY E.GrantDate
			  SELECT @GrantDate=COALESCE(@GrantDate+', ','')+#TempGrantDate.StrGrantDate FROM #TempGrantDate
			 
			-- Insert value in allotted share details
            INSERT #ALLOTTED_SHARE(CurrentDate,SchemeDisplay,FaceValue,SharesIssuedAgainstOptExercised,TotalExrAmtOptsExercised, ExercisePricePerShare,PremiumPerShare,GrantDate)
							 VALUES
							  (REPLACE(CONVERT(VARCHAR(15), GETDATE(),106),' ','-'), @Names,@FaceValue,@SharesIssuedAgainstOptExercised,@TotalExrAmtOptsExercised,@ExPrice,@PremiumPerShare,@GrantDate)
            
            -- Get 1st Table
            SELECT (REPLACE(CONVERT(VARCHAR(15), @AllottmentDate,106),' ','-')) AS AllottmentDate, CurrentDate,REPLACE(SchemeDisplay,'�','''') AS SchemeDisplay,SharesIssuedAgainstOptExercised,FaceValue,ExercisePricePerShare,PremiumPerShare,TotalExrAmtOptsExercised,GrantDate
				   FROM #ALLOTTED_SHARE
				   
            -- Scheme wise allotted share details
            CREATE TABLE #SCH_RECONCILIATION_DETAILS
            (
				 SchemeDisplayName VARCHAR(500),
				 ShrIssuedAgainstOptExercised NUMERIC(18),
				 TotalEquShrsBeforeAllotment NUMERIC(18),
				 TotalEquShrTillAllotment NUMERIC(18),
				 OptionExercisedByNRIFN NUMERIC(18),
            )  
            
           INSERT  #SCH_RECONCILIATION_DETAILS (SchemeDisplayName,ShrIssuedAgainstOptExercised)  
           SELECT LS.Name,SUM(E.SharesAlloted) AS ShareAlloted
			FROM #EMP_TEMP_EXERCISED E
				 INNER JOIN ListingDocSchConcatenation LS ON E.SchemeId=LS.SchemeID
				 WHERE CONVERT(DATE,E.SharesIssuedDate)=CONVERT(DATE,@AllottmentDate)
				 GROUP BY LS.Name
				 
		    UPDATE  #SCH_RECONCILIATION_DETAILS SET TotalEquShrsBeforeAllotment=T.ShareAlloted,TotalEquShrTillAllotment=ISNULL(T.ShareAlloted,0)+ISNULL(ShrIssuedAgainstOptExercised,0)
			FROM
		    (
				SELECT S.SchemeDisplayName, SUM(ISNULL(E.SharesAlloted,0)) AS ShareAlloted
					FROM #EMP_TEMP_EXERCISED E
					 INNER JOIN ListingDocSchConcatenation LS ON E.SchemeId=LS.SchemeID
					 INNER JOIN #SCH_RECONCILIATION_DETAILS S ON LS.Name=S.SchemeDisplayName
					 WHERE CONVERT(DATE,E.SharesIssuedDate)< CONVERT(DATE,@AllottmentDate)
					 GROUP BY S.SchemeDisplayName
			)T
			WHERE #SCH_RECONCILIATION_DETAILS.SchemeDisplayName=T.SchemeDisplayName
			
			UPDATE  #SCH_RECONCILIATION_DETAILS SET OptionExercisedByNRIFN=T.ShareAlloted
			FROM
		    (
				 SELECT S.SchemeDisplayName, SUM(ISNULL(E.SharesAlloted,0)) AS ShareAlloted
					FROM #EMP_TEMP_EXERCISED E
					 INNER JOIN ListingDocSchConcatenation LS ON E.SchemeId=LS.SchemeID
					 INNER JOIN #SCH_RECONCILIATION_DETAILS S ON LS.Name=S.SchemeDisplayName
					 WHERE CONVERT(DATE,E.SharesIssuedDate)=CONVERT(DATE,@AllottmentDate) AND E.ResidentialStatus IN('Non Resident Indian','Foreign National')
					 GROUP BY S.SchemeDisplayName
			)T
			WHERE #SCH_RECONCILIATION_DETAILS.SchemeDisplayName=T.SchemeDisplayName
			
			
			-- Get 2nd Table
			SELECT SchemeDisplayName,ShrIssuedAgainstOptExercised,TotalEquShrTillAllotment,TotalEquShrsBeforeAllotment, ISNULL(OptionExercisedByNRIFN,0) AS OptionExercisedByNRIFN
				   FROM #SCH_RECONCILIATION_DETAILS
			-- Share allotted detmat details
		    CREATE TABLE #AOLLTED_SHR_DEMAT_DETAILS
				(
					DepositoryName VARCHAR(20),
					ResidentialStatus VARCHAR(50),
					DematACType VARCHAR(50),
					AllottetShares NUMERIC(18),
					UniqueEmpNo BIGINT
				)
		   INSERT #AOLLTED_SHR_DEMAT_DETAILS (DepositoryName,ResidentialStatus,DematACType,AllottetShares)
		   SELECT DepositoryName,ResidentialStatus,DematACType,SUM(SharesAlloted) AS AllotetShares
				FROM #EMP_TEMP_EXERCISED E
				WHERE CONVERT(DATE,E.SharesIssuedDate)=CONVERT(DATE,@AllottmentDate)
				GROUP BY DepositoryName,ResidentialStatus,DematACType
           
           UPDATE #AOLLTED_SHR_DEMAT_DETAILS SET UniqueEmpNo=TT.UniqueEmpNo
           FROM
           (   		
		        SELECT DISTINCT COUNT(EmployeeID) AS UniqueEmpNo,ResidentialStatus ,DematACType,DepositoryName
		 		FROM #EMP_TEMP_EXERCISED E
		 		WHERE CONVERT(DATE,E.SharesIssuedDate)=CONVERT(DATE,@AllottmentDate)
				GROUP BY DepositoryName,ResidentialStatus,DematACType
		   )TT
		   WHERE #AOLLTED_SHR_DEMAT_DETAILS.DematACType=TT.DematACType AND #AOLLTED_SHR_DEMAT_DETAILS.DepositoryName=TT.DepositoryName 
				 AND #AOLLTED_SHR_DEMAT_DETAILS.ResidentialStatus=TT.ResidentialStatus
		   
		   -- Get 3rd Table
		   SELECT DepositoryName,ResidentialStatus,DematACType,AllottetShares,UniqueEmpNo
				  FROM #AOLLTED_SHR_DEMAT_DETAILS 
END
GO
