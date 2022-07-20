If exists 
(
select 'X' from sys.columns where object_id = object_id('MailMessages') and name = 'MailBody'
and max_length=5000
)
BEGIN
ALTER TABLE [dbo].MailMessages
ALTER COLUMN   [MailBody]    VARCHAR (MAX) NULL
END
