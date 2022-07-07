-- =============================================
-- Author:		Vidyadhar
-- Create date: 18-11-2021
-- Description:	Create VW_Cancellation_Year 
-- =============================================
IF OBJECT_ID('dbo.VW_Cancellation_Year', 'V') IS  NULL
BEGIN
Exec ('
CREATE   VIEW [dbo].[VW_Cancellation_Year]
as
SELECT DISTINCT YEAR(GrantDate) as CancellationYear
FROM CancellationDetails_rpt With(NOLOCK)
    ')

END
