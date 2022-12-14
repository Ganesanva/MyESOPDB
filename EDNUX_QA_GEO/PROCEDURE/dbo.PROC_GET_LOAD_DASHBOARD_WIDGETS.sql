/****** Object:  StoredProcedure [dbo].[PROC_GET_LOAD_DASHBOARD_WIDGETS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_LOAD_DASHBOARD_WIDGETS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_LOAD_DASHBOARD_WIDGETS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_LOAD_DASHBOARD_WIDGETS]
@USER_ID NVARCHAR(20),
@DASHBOARD_TYPE INT
AS
BEGIN
	----Create No of Canvas for My Wealth report=No of Applicable Instruments
	
	DECLARE @ITERATOR INT
	DECLARE @INSTRUMENT_COUNT INT
	DECLARE @STR_CHART_CANVAS VARCHAR(MAX)
	DECLARE @ColSize INT
	SET @USER_ID=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@USER_ID AND Deleted=0)
	--SELECT @INSTRUMENT_COUNT=COUNT(MIT_ID) FROM COMPANY_INSTRUMENT_MAPPING where IS_ENABLED = 1;
	SELECT @INSTRUMENT_COUNT = COUNT(DISTINCT CIM.MIT_ID) FROM GrantLeg AS GL
                    INNER JOIN GrantOptions AS GOP ON GL.GrantOptionId = GOP.GrantOptionId
                    INNER JOIN SCHEME AS SC on SC.SchemeId = GL.SchemeId
                    INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON CIM.MIT_ID = SC.MIT_ID
                    INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = GOP.EmployeeId
                    WHERE CIM.IS_ENABLED = 1 AND  EM.EmployeeId = @USER_ID

	IF @INSTRUMENT_COUNT=1
	BEGIN
		SET @INSTRUMENT_COUNT=2
	END
	IF @INSTRUMENT_COUNT=4
	BEGIN
		SET @INSTRUMENT_COUNT=2
	END
	SET @ITERATOR = 0
	SET @STR_CHART_CANVAS='';
	SET @ColSize=12/@INSTRUMENT_COUNT;
		WHILE (@ITERATOR < @INSTRUMENT_COUNT)
		BEGIN
			SET @STR_CHART_CANVAS =@STR_CHART_CANVAS+'<div class="col-sm-'+CAST(@ColSize AS VARCHAR)+'"><canvas id="chart-donut'+CAST(@ITERATOR AS VARCHAR)+'"'+'width="171px" height="171px" class="chartjs-render-monitor"></canvas></div>'

			SET @ITERATOR = @ITERATOR + 1
		END 
		
	---END OF MY WEALTH REPORT
	---Create Link Button for TO-DO Report
		DECLARE @ToDoLinks NVARCHAR(MAX)
		SELECT @ToDoLinks=dbo.FN_GET_LINK_BY_CONTROL_MASTER_ID(17,@USER_ID) 
	---END OF TO-DO REPORT
	
	---CREATE LINKS FOR QUICK PICKS
		DECLARE @QuickPicks NVARCHAR(MAX)
		SELECT @QuickPicks=dbo.FN_GET_LINK_BY_CONTROL_MASTER_ID(18,@USER_ID) 
	---END OF QUICK PICKS
	
	---CREATE POST QUERY
	DECLARE @PostQuery NVARCHAR(MAX)
		SET @PostQuery='<div class="table-responsive"><table class="table table-nobordered"><tbody><tr><td>Subject</td><td><input id="txtSubject" type="text" class="form-control" /></td></tr><tr><td>Comment</td><td><textarea class="form-control" id="CommentTextArea" rows="4"></textarea></td></tr><tr><td><div class="form-group"><label for="selphoto" class="col-sm-2 control-label">Select a File to upload:</label></td><td><div class="file-loading"><input id="input-ficons-3" name="input-ficons-3[]" multiple type="file"></div></div></div></div></td></tr><tr><td colspan="2"><input id="btnSubmit" type="submit" class="btn btn-primary" onclick="Save();" value="Submit Query"/></td></tr></tbody></table></div>'
	---END OF POST QUERY
	
	---CREATE TOP LEFT/RIGHT BANNER
	
	DECLARE @CompanyID NVARCHAR(20)
	
	SELECT @CompanyID=CompanyID FROM CompanyMaster
	
	PRINT @CompanyID
	---END OF TOP LEFT/RIGHT BANNER
	DECLARE @IS_EGRANTS_ENABLED AS CHAR(1)
	SET @IS_EGRANTS_ENABLED = (SELECT IS_EGRANTS_ENABLED FROM CompanyMaster)
	
	SELECT *
	FROM
	(
		SELECT DCM.CONTROL_MASTER_ID AS id,
		CASE WHEN DDSW.X IS NULL THEN DCM.X ELSE DDSW.X END AS x,
		CASE WHEN DDSW.Y IS NULL THEN DCM.Y ELSE DDSW.Y END AS y,
		CASE WHEN DDSW.WIDTH IS NULL THEN DCM.WIDTH ELSE DDSW.WIDTH END AS width,
		CASE WHEN DDSW.HEIGHT IS NULL THEN DCM.HEIGHT ELSE DDSW.HEIGHT END AS height,
		CASE WHEN DCM.CONTROL_MASTER_ID=12 THEN REPLACE(ISNULL(DCM.WIDGET_HTML_CONTENT,''),'@STR_CHART_CANVAS',@STR_CHART_CANVAS)
			 WHEN DCM.CONTROL_MASTER_ID=17 THEN REPLACE(ISNULL(DCM.WIDGET_HTML_CONTENT,''),'@ToDoLinks',@ToDoLinks)
			 WHEN DCM.CONTROL_MASTER_ID=18 THEN REPLACE(ISNULL(DCM.WIDGET_HTML_CONTENT,''),'@QuickPicks',@QuickPicks)
			 WHEN DCM.CONTROL_MASTER_ID=19 THEN REPLACE(ISNULL(DCM.WIDGET_HTML_CONTENT,''),'@PostQuery',@PostQuery)
			 WHEN DCM.CONTROL_MASTER_ID=13 OR DCM.CONTROL_MASTER_ID=14 THEN REPLACE(ISNULL(DCM.WIDGET_HTML_CONTENT,''),'@CompanyID',@CompanyID)
			 ELSE DCM.WIDGET_HTML_CONTENT
		END AS content
		FROM DASHBOARD_CONTROLS_MASTER DCM
		LEFT JOIN DASHBOARD_DASHBOARD_SAVE_WIDGET_POSITION DDSW ON DCM.CONTROL_MASTER_ID=DDSW.CONTROL_MASTER_ID
		WHERE DCM.WIDGET_ID IN
		(
			SELECT WIDGET_ID FROM DASHBOARD_DASHBOARD_WIDGET_TYPE WHERE ISNULL(IsActive,0)=1 AND LTRIM(RTRIM(UPPER(WIDGET_TYPE)))<>'OGA STATUS'
			UNION 
			SELECT WIDGET_ID FROM DASHBOARD_DASHBOARD_WIDGET_TYPE WHERE ISNULL(IsActive,0)=1 AND LTRIM(RTRIM(UPPER(WIDGET_TYPE)))='OGA STATUS' AND @IS_EGRANTS_ENABLED=1
		)
		AND DASHBOARD_TYPE=@DASHBOARD_TYPE
	)TEMP WHERE TEMP.x IS NOT NULL
	
END
GO
