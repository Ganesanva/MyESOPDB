IF   OBJECT_ID('USP_SCRIPT_INDEX') IS NOT NULL 
BEGIN
 Drop  Proc usp_script_index
END 
go 
Create procedure usp_script_index @dbname sysname
as
--usp_script_index 'EDNUX_QA_Live'
declare @SchemaName varchar(100)
declare @TableName varchar(256)
declare @IndexName varchar(256)
declare @ColumnName varchar(100)
declare @is_unique varchar(100)
declare @IndexTypeDesc varchar(100)
declare @FileGroupName varchar(100)
declare @is_disabled varchar(100)
declare @IndexOptions varchar(max)
declare @IndexColumnId int
declare @IsDescendingKey int 
declare @IsIncludedColumn int
declare @TSQLScripCreationIndex nvarchar(max)
declare @TSQLScripDisableIndex nvarchar(max)

 IF DB_ID(@dbname) IS NULL  /*Validate the database name exists*/
       BEGIN
       RAISERROR('Invalid Database Name passed',16,1)
       RETURN
       END

set nocount on 

create table #tbls (
sch_name sysname,
tbl_name sysname,
index_name sysname,
unique_flag varchar(20),
type_desc varchar(20),
indexoptions varchar(500),
is_disabled int,
fileGroupName sysname
)

DECLARE @dynsql nvarchar(max)  
declare @dynsql2 nvarchar(max)

 /*Use QUOTENAME to correctly escape any special characters*/
SET @dynsql = N'insert #tbls select 
schema_name(t.schema_id) [sch_name], 
t.name as tbl_name, 
ix.name as index_name,
 case when ix.is_unique = 1 then ''UNIQUE '' else '''' END as unique_flag
 , ix.type_desc,
 case when ix.is_padded=1 then ''PAD_INDEX = ON, '' else ''PAD_INDEX = OFF, '' end
 + case when ix.allow_page_locks=1 then ''ALLOW_PAGE_LOCKS = ON, '' else ''ALLOW_PAGE_LOCKS = OFF, '' end
 + case when ix.allow_row_locks=1 then  ''ALLOW_ROW_LOCKS = ON, '' else ''ALLOW_ROW_LOCKS = OFF, '' end
 + case when INDEXPROPERTY(t.object_id, ix.name, ''IsStatistics'') = 1 then ''STATISTICS_NORECOMPUTE = ON, '' 
 else ''STATISTICS_NORECOMPUTE = OFF, '' end
 + case when ix.ignore_dup_key=1 then ''IGNORE_DUP_KEY = ON, '' else ''IGNORE_DUP_KEY = OFF, '' end
 + ''SORT_IN_TEMPDB = OFF, FILLFACTOR ='' + CAST(case  when ix.fill_factor = 0 then 100 else ix.fill_factor end AS VARCHAR(3)) AS IndexOptions
 , ix.is_disabled , FILEGROUP_NAME(ix.data_space_id) FileGroupName
 from ' + @dbname +'.sys.tables t 
 inner join ' + @dbname +'.sys.indexes ix on t.object_id=ix.object_id
 where ix.type>0 and ix.is_primary_key=0 and ix.is_unique_constraint=0 
 and t.is_ms_shipped=0 and t.name<>''sysdiagrams''
 order by schema_name(t.schema_id), t.name, ix.name'

 exec sp_executesql @dynsql

print 'use '+ @dbname + char(10) +'go' +char(10) 

declare CursorIndex cursor for select sch_name, tbl_name, index_name,unique_flag, type_desc, indexoptions,is_disabled,fileGroupName from #tbls

open CursorIndex
fetch next from CursorIndex into  @SchemaName, @TableName, @IndexName, @is_unique, @IndexTypeDesc, @IndexOptions,@is_disabled, @FileGroupName

while (@@fetch_status=0)
begin
 declare @IndexColumns varchar(max)
 declare @IncludedColumns varchar(max)

 set @IndexColumns=''
 set @IncludedColumns=''

 create table #cols
(
    column_name sysname,
    is_descending_key int,
    is_included_column int
)

 SET @dynsql2 = N' insert #cols
  select col.name as column_name, ixc.is_descending_key, ixc.is_included_column
  from '+ @dbname + '.sys.tables tb 
  inner join ' +@dbname +'.sys.indexes ix on tb.object_id=ix.object_id
  inner join ' +@dbname +'.sys.index_columns ixc on ix.object_id=ixc.object_id and ix.index_id= ixc.index_id
  inner join ' +@dbname +'.sys.columns col on ixc.object_id =col.object_id  and ixc.column_id=col.column_id
  where ix.type>0 and (ix.is_primary_key=0 or ix.is_unique_constraint=0)
  and schema_name(tb.schema_id)=''' + @SchemaName + ''' and tb.name= ''' + @TableName + ''' and ix.name=''' + @IndexName + ''' order by ixc.index_column_id '

 --print @dynsql2
 exec sp_executesql @dynsql2

 declare CursorIndexColumn cursor for select column_name,is_descending_key,is_included_column from #cols

 open CursorIndexColumn 
 fetch next from CursorIndexColumn into  @ColumnName, @IsDescendingKey, @IsIncludedColumn

 while (@@fetch_status=0)
 begin
  if @IsIncludedColumn=0 
   set @IndexColumns=@IndexColumns + @ColumnName  + case when @IsDescendingKey=1  then ' DESC, ' else  ' ASC, ' end
  else 
   set @IncludedColumns=@IncludedColumns  + @ColumnName  +', ' 

  fetch next from CursorIndexColumn into @ColumnName, @IsDescendingKey, @IsIncludedColumn
 end

 drop table #cols
 close CursorIndexColumn
 deallocate CursorIndexColumn

 set @IndexColumns = substring(@IndexColumns, 1, len(@IndexColumns)-1)
 set @IncludedColumns = case when len(@IncludedColumns) >0 then substring(@IncludedColumns, 1, len(@IncludedColumns)-1) else '' end
 --  print @IndexColumns
 --  print @IncludedColumns

 set @TSQLScripCreationIndex =''
 set @TSQLScripDisableIndex =''
 set @TSQLScripCreationIndex='
 IF NOT EXISTS (
SELECT ''X''
FROM SYS.INDEXES 
WHERE  NAME = '''+@IndexName+'''
 )
 BEGIN
 CREATE '+ @is_unique  +@IndexTypeDesc + ' INDEX ' +QUOTENAME(@IndexName)+' ON ' + QUOTENAME(@SchemaName) +'.'+ QUOTENAME(@TableName)+ '('+@IndexColumns+') '+ 
  case when len(@IncludedColumns)>0 then CHAR(13) +'INCLUDE (' + @IncludedColumns+ ')' else '' end + CHAR(13)+'WITH (' + @IndexOptions+ ') ON ' + QUOTENAME(@FileGroupName) + 
  ' END;'  

 if @is_disabled=1 
  set  @TSQLScripDisableIndex=  CHAR(13) +'ALTER INDEX ' +QUOTENAME(@IndexName) + ' ON ' + QUOTENAME(@SchemaName) +'.'+ QUOTENAME(@TableName) + ' DISABLE;' + CHAR(13) 

 print @TSQLScripCreationIndex
 print @TSQLScripDisableIndex

 fetch next from CursorIndex into  @SchemaName, @TableName, @IndexName, @is_unique, @IndexTypeDesc, @IndexOptions,@is_disabled, @FileGroupName

end
close CursorIndex
deallocate CursorIndex
drop table #tbls

 --EXEC sp_executesql @TSQLScripCreationIndex;
 --EXEC sp_executesql @TSQLScripDisableIndex;

go
