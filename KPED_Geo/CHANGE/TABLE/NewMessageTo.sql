If exists 
(
select 'X' from sys.columns where object_id = object_id('NewMessageTo') and name = 'Description'
and max_length=4000
)
BEGIN
ALTER TABLE [dbo].MailMessages
ALTER COLUMN  [Description]   VARCHAR (MAX) NULL
END
