/****** Object:  StoredProcedure [dbo].[Proc_ExerciseSetings]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_ExerciseSetings]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ExerciseSetings]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Created By  :	Kishor 
	Created On 	:	10/Aug/2017
	Description :   This procedure is used to get the exercise setting from exercise payment mode	
*/
CREATE PROCEDURE [dbo].[Proc_ExerciseSetings]
 
    @MIT_ID INT,
	@PaymentMode NVARCHAR(50)
	 
AS
BEGIN
   SET NOCOUNT ON; 
   
   SELECT TRUSTGENSHARETRANSLIST,PAYMENTMODE FROM ExerciseProcessSetting 
   WHERE MIT_ID=@MIT_ID AND PaymentMode=@PaymentMode

   SET NOCOUNT OFF;
END
GO
