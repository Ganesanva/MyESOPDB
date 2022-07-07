If exists (
select * from sys.columns where object_id = object_id('GrantAccMassUpload') and name = 'TEMPLATEVestingTypeNAME'
)
BEGIN
ALTER TABLE [dbo].[GrantAccMassUpload]
ALTER COLUMN    [TEMPLATE_NAME]   NVARCHAR (500)  NULL
END


