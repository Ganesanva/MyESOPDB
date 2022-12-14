/****** Object:  View [dbo].[VW_Live]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_Live]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Vidyadhar
-- Create date: 18-11-2021
-- Description:	Create VW_Live
-- =============================================

CREATE   VIEW [dbo].[VW_Live]
as
SELECT 
''Scheme Name''			as ''Scheme Name''			
,''Employee Id''			as ''Employee Id''			
,''Employee Name''		as ''Employee Name''		
,''Status''				as ''Status''				
,''Grant Date''			as ''Grant Date''			
,''Grant Leg Id''			as ''Grant Leg Id''			
,''Grant Registration Id''as ''Grant Registration Id''
,''Grant Option Id''		as ''Grant Option Id''		
,''Options Granted''		as ''Options Granted''		
,''Vesting Type''			as ''Vesting Type''			
,''Vesting Date''			as ''Vesting Date''			
,''Expiry Date''			as ''Expiry Date''			
,''Exercise Price''		as ''Exercise Price''		
,''Options Vested''		as ''Options Vested''		
,''Pending For Approval''	as ''Pending For Approval''	
,''Options UnVested''		as ''Options UnVested''		
,''Options Exercised''	as ''Options Exercised''	
,''Options Cancelled''	as ''Options Cancelled''	
,''Options Lapsed''		as ''Options Lapsed''		
,''Unvested Cancelled''	as ''Unvested Cancelled''	
,''Vested Cancelled''		as ''Vested Cancelled''		
,''ToDate''				as ''ToDate''		
, 0						as ID

' 
GO
