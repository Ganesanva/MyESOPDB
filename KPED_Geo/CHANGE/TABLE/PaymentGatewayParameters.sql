If exists 
(
select 'X' from sys.columns where object_id = object_id('PaymentGatewayParameters')
and name ='BLOCK_HRS'
)
BEGIN

ALTER TABLE [dbo].PaymentGatewayParameters
ALTER COLUMN [BLOCK_HRS]  INT 

END


IF NOT EXISTS (
select 'X' 
from sys.default_constraints 
where parent_object_id = object_id('PaymentGatewayParameters')
and parent_column_id in (		
						select column_id
						from sys.columns 
						where object_id = object_id('PaymentGatewayParameters')
						and name = 'BLOCK_HRS'
						) and type = 'D'
)
BEGIN
ALTER TABLE [dbo].[PaymentGatewayParameters] ADD  DEFAULT ((0)) FOR [BLOCK_HRS]
END
GO

If exists 
(
select 'X' from sys.columns where object_id = object_id('PaymentGatewayParameters')
and name ='IS_TRANS_REVERSAL_MAIL_ENABLED'
)
BEGIN

ALTER TABLE [dbo].PaymentGatewayParameters
ALTER COLUMN [IS_TRANS_REVERSAL_MAIL_ENABLED]  CHAR (1)   

END


IF NOT EXISTS (select 'X' 
from sys.default_constraints 
where parent_object_id = object_id('PaymentGatewayParameters')
and parent_column_id in (		
						select column_id
						from sys.columns 
						where object_id = object_id('PaymentGatewayParameters')
						and name = 'IS_TRANS_REVERSAL_MAIL_ENABLED'
						) and type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentGatewayParameters] ADD  DEFAULT ((0)) FOR [IS_TRANS_REVERSAL_MAIL_ENABLED]
END
GO


--Data patch for alredy existing records 
If exists (select 'X' from PaymentGatewayParameters with(nolock) where BLOCK_HRS is null )
begin

Update PaymentGatewayParameters
set BLOCK_HRS = 0
where BLOCK_HRS is null

end
go

If exists (select 'X' from PaymentGatewayParameters with(nolock) where IS_TRANS_REVERSAL_MAIL_ENABLED is null )
begin

Update PaymentGatewayParameters
set IS_TRANS_REVERSAL_MAIL_ENABLED = 0
where IS_TRANS_REVERSAL_MAIL_ENABLED is null

end
go

