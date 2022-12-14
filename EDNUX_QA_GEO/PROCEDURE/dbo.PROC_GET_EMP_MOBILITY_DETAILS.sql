/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_MOBILITY_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMP_MOBILITY_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_MOBILITY_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EMP_MOBILITY_DETAILS]
	( 
		@Emp_ID NVARCHAR(50),
		@From_Date DATETIME,
		@To_Date DATETIME,
		@GrantDate DATETIME,
		@VestingDate DATETIME,
		@GrantLegSerialNo BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY		
		
			
			
			CREATE TABLE #TempCountry
			(
				EmpId VARCHAR(50),
				Country NVARCHAR(250),
				FromDate datetime,
				Todate DATETIME,
				GrantDate DATETIME,
				VestingDate DATETIME,
				GrantLegSerialNo BIGINT	
			)
			
			Insert into #TempCountry(EmpId,Country,FromDate,Todate,GrantDate,Vestingdate,GrantLegSerialNo)
			Select DISTINCT EmployeeId, CurrentDetails,CONVERT(datetime, FromDate),CONVERT(datetime,To_Date),GrantDate=@GrantDate,Vestingdate=@Vestingdate,GrantLegSerialNo=@GrantLegSerialNo
			From
			(
			
			--case 1
			SELECT TblFirst.EmployeeId, TblFirst.[Moved To] AS CurrentDetails,TblFirst.FromDate,TblFirst.To_Date,GrantDate=@GrantDate,Vestingdate=@Vestingdate,GrantLegSerialNo=@GrantLegSerialNo From (
			
			SELECT EmployeeId, CurrentDetails,	[From Date of Movement] AS FromDate,	[Moved To],
			( Select top 1 [From Date of Movement] FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD
			  WHERE EmployeeId=@Emp_ID AND UPPER(Field) =UPPER('Tax Identifier Country') 
					AND (CONVERT(date,[FromDate])<=CONVERT(date,@From_Date) ) AND FromDate is not null
			) AS To_Date

			FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD 
			WHERE EmployeeId=@Emp_ID AND UPPER(Field) =UPPER('Tax Identifier Country') 
			AND FromDate is null
			) As TblFirst
			Where 
			 CONVERT(date,[FromDate])<=CONVERT(date,@From_Date) AND  CONVERT(date,[To_date])>=CONVERT(date,@To_Date)
			Union All
			 --case 1 End
			 --case 2
			SELECT  EmployeeId, CurrentDetails, FromDate,	[From Date of Movement] AS To_Date,GrantDate=@GrantDate,Vestingdate=@Vestingdate,GrantLegSerialNo=@GrantLegSerialNo
			FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD 
			WHERE EmployeeId=@Emp_ID AND UPPER(Field) =UPPER('Tax Identifier Country')  
			AND  (CONVERT(date,[FromDate])>= CONVERT(date,@From_Date) And  CONVERT(date,[From Date of Movement])<=CONVERT(date,@To_Date))
			--case 2 End
			Union All
			-- Case 3 

			Select Top 1 EmployeeId, TblLast.[Moved To] As CurrentDetails,TblLast.FromDate,TblLast.To_Date,GrantDate=@GrantDate,Vestingdate=@Vestingdate,GrantLegSerialNo=@GrantLegSerialNo From (

			SELECT EmployeeId, CurrentDetails,	[From Date of Movement] AS FromDate,	[Moved To],

			--( Select Top 1  [From Date of Movement] FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD
			--  WHERE EmployeeId=@Emp_ID AND UPPER(Field) =UPPER('Tax Identifier Country') 
			--		AND (CONVERT(date,[From Date of Movement])<=CONVERT(date,@From_Date) ) AND FromDate is not null
			--		Order by [From Date of Movement] desc
			--) AS To_Date
			CASE WHEN (CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE, @FROM_DATE)) AND  (CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE, @TO_DATE)) THEN CONVERT(DATE, @TO_DATE) END AS TO_DATE

			FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD 
			WHERE EmployeeId=@Emp_ID AND UPPER(Field) =UPPER('Tax Identifier Country') 
			
			) As TblLast

			WHERE  ([FromDate] <= CASE WHEN TO_DATE IS NULL THEN CONVERT(DATE,@TO_DATE) ELSE TO_DATE END)	 
			ORDER BY [FromDate] DESC
			-- Case 3  End
			)	As MobilityTracking	
	
			--Select * from #TempCountry
			--order by FromDate 
			
			SELECT CM.ID,TC.EmpId, TC.Country,TC.FromDate,TC.Todate,TC.GrantDate,TC.Vestingdate,TC.GrantLegSerialNo
			FROM #TEMPCOUNTRY TC Inner Join CountryMaster CM On TC.Country=CM.CountryName			
			ORDER BY FromDate
	END TRY
	BEGIN CATCH
	--	ROLLBACK TRANSACTION
		select 'Error'
		RETURN 0
	END CATCH
		SET NOCOUNT OFF;
END

GO
