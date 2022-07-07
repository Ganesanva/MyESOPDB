
If exists 
(
select 'X'
from sys.triggers 
where name = 'TRG_AfterInsertUserMaster'
)
BEGIN
 Drop trigger dbo.TRG_AfterInsertUserMaster
END

