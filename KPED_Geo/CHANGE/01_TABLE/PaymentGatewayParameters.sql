IF ( (Select name
	from sys.columns 
	where object_id = object_id('PaymentGatewayParameters')
	and column_id in (  Select MAx(column_id)
						from sys.columns 
						where object_id = object_id('PaymentGatewayParameters')
					))<>'IS_TRANS_REVERSAL_MAIL_ENABLED'

	)
Begin

	select *
	into PaymentGatewayParameters_backup
	from PaymentGatewayParameters

	If not  exists (
							select column_id
							from sys.columns 
							where object_id = object_id('PaymentGatewayParameters')
							and name = 'BLOCK_HRS_bk'
	              ) 
	begin

	ALTER TABLE [dbo].PaymentGatewayParameters
    add  [BLOCK_HRS_bk]  INT

	end
	

		If not  exists (
							select column_id
							from sys.columns 
							where object_id = object_id('PaymentGatewayParameters')
							and name = 'IS_TRANS_REVERSAL_MAIL_ENABLED_bk'
	              ) 
	begin

	ALTER TABLE [dbo].PaymentGatewayParameters
    add  [IS_TRANS_REVERSAL_MAIL_ENABLED_bk]  CHAR (1) 

	end



	If  exists (
							select column_id
							from sys.columns 
							where object_id = object_id('PaymentGatewayParameters')
							and name = 'BLOCK_HRS_bk'
	              ) 
	begin

	Declare @text varchar(max)
	select @text =
	'Update PaymentGatewayParameters
	set [BLOCK_HRS_bk] = [BLOCK_HRS],
		[IS_TRANS_REVERSAL_MAIL_ENABLED_bk]=[IS_TRANS_REVERSAL_MAIL_ENABLED]'

		exec (@text)
	    
	end

	If not exists (
	Select [BLOCK_HRS],[IS_TRANS_REVERSAL_MAIL_ENABLED]  from PaymentGatewayParameters_backup
	except 
	Select [BLOCK_HRS_bk],[IS_TRANS_REVERSAL_MAIL_ENABLED_bk]  from PaymentGatewayParameters
	)
	begin

		Declare @defaultcons_name1 Varchar(max),@defaultcons_name2 Varchar(max)

	select @defaultcons_name1 = 'ALTER TABLE PaymentGatewayParameters
DROP CONSTRAINT ' +NAme 
	from sys.default_constraints 
	where parent_object_id = object_id('PaymentGatewayParameters')
	and parent_column_id in (		
							select column_id
							from sys.columns 
							where object_id = object_id('PaymentGatewayParameters')
							and name = 'BLOCK_HRS'
							) and type = 'D'

							select @defaultcons_name2 = 'ALTER TABLE PaymentGatewayParameters
DROP CONSTRAINT ' +NAme 
	from sys.default_constraints 
	where parent_object_id = object_id('PaymentGatewayParameters')
	and parent_column_id in (		
							select column_id
							from sys.columns 
							where object_id = object_id('PaymentGatewayParameters')
							and name = 'IS_TRANS_REVERSAL_MAIL_ENABLED'
							) and type = 'D'
--select @defaultcons_name1,@defaultcons_name2
exec (@defaultcons_name1)
exec (@defaultcons_name2)


		ALter table PaymentGatewayParameters
		drop  column [BLOCK_HRS] 

	
		ALter table PaymentGatewayParameters
		drop  column [IS_TRANS_REVERSAL_MAIL_ENABLED] 

		EXEC sp_rename 'PaymentGatewayParameters.BLOCK_HRS_bk', 'BLOCK_HRS';

	    EXEC sp_rename 'PaymentGatewayParameters.IS_TRANS_REVERSAL_MAIL_ENABLED_bk', 'IS_TRANS_REVERSAL_MAIL_ENABLED';

	    Drop table PaymentGatewayParameters_backup
		
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

	--Data patch for alredy existing records 
	If exists (select 'X' from PaymentGatewayParameters with(nolock) where BLOCK_HRS is null )
	begin

	Update PaymentGatewayParameters
	set BLOCK_HRS = 0
	where BLOCK_HRS is null

	end


	If exists (select 'X' from PaymentGatewayParameters with(nolock) where IS_TRANS_REVERSAL_MAIL_ENABLED is null )
	begin

	Update PaymentGatewayParameters
	set IS_TRANS_REVERSAL_MAIL_ENABLED = 0
	where IS_TRANS_REVERSAL_MAIL_ENABLED is null

	end


	end


end
