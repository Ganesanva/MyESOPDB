Declare @i varchar(10) = NULL

SELECT @i = 'X' 
FROM sys.triggers
where name = 'TrgDeleteDynamicTables' 


IF @i is null
begin
exec('
CREATE TRIGGER [dbo].[TrgDeleteDynamicTables]
   ON  [dbo].[GrantLeg]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE 
	@TOTAL_ROWS AS INT, 
	@ROW_NUNMER AS INT,
	@TABLE_NAME AS VARCHAR(100)
	
	SELECT ROW_NUMBER()OVER (ORDER BY NAME) AS SR_NO, NAME INTO #DYNAMIC_REPORT FROM SYS.TABLES WHERE NAME LIKE ''DYNAMIC_REPORT%''
	 
	SET @ROW_NUNMER = 1
	SELECT @TOTAL_ROWS = COUNT(NAME) FROM #DYNAMIC_REPORT

	WHILE @ROW_NUNMER <= @TOTAL_ROWS
	BEGIN
		SELECT @TABLE_NAME = NAME FROM #DYNAMIC_REPORT WHERE SR_NO = @ROW_NUNMER
		
		EXEC (''DROP TABLE '' + @TABLE_NAME)
		          
		SET @ROW_NUNMER = @ROW_NUNMER + 1
	END
	
	SET NOCOUNT OFF;

END')

end
go 
If exists (SELECT 'X' 
FROM sys.triggers
where name = 'TrgDeleteDynamicTables' 
and is_disabled  = 1 )
begin 
exec ('
Enable TRIGGER [dbo].[TrgDeleteDynamicTables]
ON [dbo].[GrantLeg]')

end
