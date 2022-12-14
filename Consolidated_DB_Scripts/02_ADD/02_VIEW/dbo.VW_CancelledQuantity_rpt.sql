/****** Object:  View [dbo].[VW_CancelledQuantity_rpt]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CancelledQuantity_rpt]'))
EXEC dbo.sp_executesql @statement = N'

					
					create VIEW [dbo].[VW_CancelledQuantity_rpt]
						AS 
					SELECT	Cancelled.CancelledDate, 
							CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
								CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
									SUM(Cancelled.CancelledQuantity)
								ELSE 
									SUM(Cancelled.SplitCancelledQuantity)
								END
							ELSE
								SUM(Cancelled.BonusSplitCancelledQuantity)
							END AS CancelledQuantity,
							GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, GrantLeg.VestingType, GrantLeg.IsPerfBased, ISNULL(PerformanceBasedGrant.LastUpdatedOn,NULL) AS PERF_LastUpdatedOn,
							ISNULL(PerformanceBasedGrant.NumberOfOptionsAvailable,0) AS PERF_NumberOfOptionsAvailable, ISNULL(PerformanceBasedGrant.CancelledQuantity,0) AS PERF_CancelledQuantity, ISNULL(PerformanceBasedGrant.NumberOfOptionsGranted,0) AS PERF_NumberOfOptionsGranted, GrantLeg.Parent,
							CASE 
							
							WHEN ((IsPerfBased = ''1'') AND (UPPER(GrantLeg.VestingType) = ''P'') AND (UPPER(''Unvested_Cancelled'') = ''UNVESTED_CANCELLED'')
									AND CONVERT(DATE,Cancelled.CancelledDate) >= CONVERT(DATE,''Feb  9 2017 12:00AM''))
									THEN
										(
											CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
												CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
													SUM(Cancelled.CancelledQuantity)
												ELSE 
													SUM(Cancelled.SplitCancelledQuantity)
												END
											ELSE
												SUM(Cancelled.BonusSplitCancelledQuantity)
											END
										) 					
								WHEN ((IsPerfBased = ''1'') AND (UPPER(GrantLeg.VestingType) = ''P'') AND (UPPER(''Unvested_Cancelled'') = ''VESTED_CANCELLED'')
									AND CONVERT(DATE,Cancelled.CancelledDate) >= CONVERT(DATE,''Feb  9 2017 12:00AM''))					
									THEN	 
										(
											''0''
										)								
								WHEN (CONVERT(DATE,cancelled.CancelledDate) < CONVERT(DATE,MAX(GrantLeg.FinalVestingDate))) 						
									THEN	 
										(
											CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
												CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
													SUM(Cancelled.CancelledQuantity)
												ELSE 
													SUM(Cancelled.SplitCancelledQuantity)
												END
											ELSE
												SUM(Cancelled.BonusSplitCancelledQuantity)
											END
										) 					
								 ELSE 0
							END AS UnVestedCancelled,
							
							CASE 
							WHEN ((IsPerfBased = ''1'') AND (UPPER(GrantLeg.VestingType) = ''P'') AND (UPPER(''Unvested_Cancelled'') = ''UNVESTED_CANCELLED'')
										AND CONVERT(DATE,Cancelled.CancelledDate) >= CONVERT(DATE,''Feb  9 2017 12:00AM''))
									THEN
										(
											''0''
										) 		
								WHEN ((IsPerfBased = ''1'') AND (UPPER(GrantLeg.VestingType) = ''P'') AND (UPPER(''Unvested_Cancelled'') = ''VESTED_CANCELLED'')
									AND CONVERT(DATE,Cancelled.CancelledDate) >= CONVERT(DATE,''Feb  9 2017 12:00AM''))
								  THEN
									(
										CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
											CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
												SUM(Cancelled.CancelledQuantity)
											ELSE 
												SUM(Cancelled.SplitCancelledQuantity)
											END
										ELSE
											SUM(Cancelled.BonusSplitCancelledQuantity)
										END
									)
								WHEN (cancelled.CancelledDate >= MAX(GrantLeg.FinalVestingDate))
								  THEN
									(
										CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
											CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
												SUM(Cancelled.CancelledQuantity)
											ELSE 
												SUM(Cancelled.SplitCancelledQuantity)
											END
										ELSE
											SUM(Cancelled.BonusSplitCancelledQuantity)
										END
									)	
									ELSE 0
							END AS VestedCancelled,
							GrantOptions.EmployeeId
					FROM	GrantRegistration 
							INNER JOIN Scheme ON GrantRegistration.SchemeId = Scheme.SchemeId 
							INNER JOIN GrantOptions ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId 
							INNER JOIN GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId 
							INNER JOIN Cancelled ON GrantLeg.ID = Cancelled.GrantLegSerialNumber
							LEFT OUTER JOIN PerformanceBasedGrant ON PerformanceBasedGrant.GrantLegID = GrantLeg.GrantLegId AND PerformanceBasedGrant.GrantOptionID = GrantLeg.GrantOptionId
						GROUP BY Cancelled.CancelledDate, GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, Cancelled.GrantLegSerialNumber, GrantLeg.VestingType, GrantLeg.IsPerfBased, PerformanceBasedGrant.LastUpdatedOn,PerformanceBasedGrant.NumberOfOptionsAvailable, PerformanceBasedGrant.CancelledQuantity, PerformanceBasedGrant.NumberOfOptionsGranted, GrantLeg.Parent, GrantOptions.EmployeeId
				
' 
GO
