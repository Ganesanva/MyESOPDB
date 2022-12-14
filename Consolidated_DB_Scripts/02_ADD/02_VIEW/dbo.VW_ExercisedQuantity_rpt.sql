/****** Object:  View [dbo].[VW_ExercisedQuantity_rpt]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_ExercisedQuantity_rpt]'))
EXEC dbo.sp_executesql @statement = N'
					CREATE VIEW [dbo].[VW_ExercisedQuantity_rpt]
						AS 
							SELECT	Exercised.ExercisedDate, 
									CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
										CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
											SUM(Exercised.ExercisedQuantity)
										ELSE 
											SUM(Exercised.SplitExercisedQuantity)
										END
									ELSE
										SUM(Exercised.BonusSplitExercisedQuantity)
									END AS ExercisedQuantity,
									GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, GrantLeg.VestingType, GrantLeg.Parent, GrantOptions.EmployeeId 
							FROM	GrantRegistration WITH (NOLOCK)
									INNER JOIN Scheme WITH (NOLOCK) ON GrantRegistration.SchemeId = Scheme.SchemeId 
									INNER JOIN GrantOptions WITH (NOLOCK) ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId 
									INNER JOIN GrantLeg WITH (NOLOCK) ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId 
									INNER JOIN Exercised WITH (NOLOCK) ON GrantLeg.ID = Exercised.GrantLegSerialNumber    
							GROUP BY Exercised.ExercisedDate, GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, Exercised.GrantLegSerialNumber, GrantLeg.VestingType, GrantLeg.Parent, GrantOptions.EmployeeId
                
' 
GO
