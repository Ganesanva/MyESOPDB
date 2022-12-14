/****** Object:  StoredProcedure [dbo].[PROC_GetPUPDataFromGrantLeg]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetPUPDataFromGrantLeg]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetPUPDataFromGrantLeg]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_GetPUPDataFromGrantLeg]
(
	@EmployeeId		VARCHAR(100) = NULL,
	@GrantOptionId	VARCHAR(100) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Query VARCHAR(MAX) = '',
			@WhereClause VARCHAR(MAX)
	
	SET @Query = ' SELECT	GL.ID,
							GOP.EmployeeId ,			
							GOP.GrantOptionId,
							GL.GrantLegId,
							GL.VestingType,
							GL.Parent,
							GL.IsPerfBased
					  FROM	GrantLeg GL
							INNER JOIN GrantOptions GOP
								ON GOP.GrantOptionId = GL.GrantOptionId 
							INNER JOIN Scheme Sch
								ON GOP.SchemeId = Sch.SchemeId AND Sch.IsPUPEnabled=1 and Sch.PUPExedPayoutProcess <>1 '
	IF(@EmployeeId IS NOT NULL AND @EmployeeId <> '---ALL---')
	BEGIN
		SET @WhereClause = 'WHERE GOP.EmployeeId='''+ @EmployeeId +''''
	END
	 
	IF(@GrantOptionId IS NOT NULL AND @GrantOptionId <> '---ALL---')
	BEGIN
		IF(@EmployeeId IS NULL OR @EmployeeId='' OR @EmployeeId = '---ALL---')
			BEGIN
			SET @WhereClause = 'WHERE GOP.GrantOptionId = '''+@GrantOptionId+''''
		END
		ELSE
			BEGIN
			SET @WhereClause = @WhereClause + ' AND GOP.GrantOptionId = '''+@GrantOptionId+''''
		END
	END
	 -- PRINT  @Query 	 PRINT @WhereClause
	EXEC (@Query +' '+@WhereClause)	 	 
	
	-- Reset SET NOCOUNT to OFF
	SET NOCOUNT OFF;
END
GO
