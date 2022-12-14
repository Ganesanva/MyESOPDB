/****** Object:  View [dbo].[VW_UnApprovedQuantity_rpt]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_UnApprovedQuantity_rpt]'))
EXEC dbo.sp_executesql @statement = N'					
					CREATE VIEW [dbo].[VW_UnApprovedQuantity_rpt]
						AS 
							SELECT	ShExercisedOptions.ExerciseDate, 
									CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
										CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
											SUM(ShExercisedOptions.ExercisedQuantity)
										ELSE 
											SUM(ShExercisedOptions.SplitExercisedQuantity)
										END
									ELSE
										SUM(ShExercisedOptions.BonusSplitExercisedQuantity)
									END AS ExerciseQuantity,
									GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, GrantLeg.VestingType, GrantLeg.Parent, GrantOptions.EmployeeId 
							FROM	GrantRegistration  WITH (NOLOCK)
									INNER JOIN Scheme WITH (NOLOCK) ON GrantRegistration.SchemeId = Scheme.SchemeId 
									INNER JOIN GrantOptions WITH (NOLOCK) ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId 
									INNER JOIN GrantLeg WITH (NOLOCK) ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId 
									INNER JOIN ShExercisedOptions WITH (NOLOCK) ON GrantLeg.ID = ShExercisedOptions.GrantLegSerialNumber    
							GROUP BY ShExercisedOptions.ExerciseDate, GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, ShExercisedOptions.GrantLegSerialNumber, GrantLeg.VestingType, GrantLeg.Parent, GrantOptions.EmployeeId 
				
' 
GO
