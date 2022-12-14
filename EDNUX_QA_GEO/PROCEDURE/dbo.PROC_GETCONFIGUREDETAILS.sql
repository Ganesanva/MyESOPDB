/****** Object:  StoredProcedure [dbo].[PROC_GETCONFIGUREDETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETCONFIGUREDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETCONFIGUREDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GETCONFIGUREDETAILS] 
(
	@MIT_ID INT=Null
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        Id, 
        EmployeeField,        
        (CASE WHEN ISEDIT = '1' THEN 
            CASE WHEN ISNULL(DISPLAY_NAME,'') = '' THEN 
                EmployeeField 
            ELSE 
                DISPLAY_NAME 
            END 
        ELSE 
            EmployeeField 
        END) AS DisplayName,
        DISPLAY_NAME,
        Check_ToEmp,
        Check_ToExercise,
        check_Own,
        check_Funding, 
        Datafield,
        check_SellAll, 
        check_SellPartial,
        Check_exercise,
        ADS_check_Own,
        ADS_check_Funding, 
        ADS_check_SellAll, 
        ADS_check_SellPartial,
        ADS_Check_exercise,
        ISNULL(ISEDIT,0) AS ISEDIT,
        ExerciseNow_Field_Show,
		reConfirmation
    FROM 
        ConfigurePersonalDetails 
    WHERE
        MIT_ID Is Null AND    
        EmployeeField NOT IN ('OneTimeUpdate','MultipleUpdate','AllAtOneGo','UpdateInParts','IsRequired','IsMandatory') ORDER BY ID

    SET NOCOUNT OFF;
END
GO
