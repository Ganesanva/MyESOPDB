IF ( (Select name
	from sys.columns 
	where object_id = object_id('GrantAccMassUpload')
	and column_id in (  Select MAx(column_id)
						from sys.columns 
						where object_id = object_id('GrantAccMassUpload')
					))<>'TEMPLATE_NAME'

	)
Begin


	select *
	into GrantAccMassUpload_backup
	from GrantAccMassUpload


	ALter table GrantAccMassUpload
	add  [TEMPLATE_NAME_bk] [nvarchar](500) NULL

	Update GrantAccMassUpload
	set [TEMPLATE_NAME_bk] = [TEMPLATE_NAME]

	If not exists (
	Select GAMUID,TEMPLATE_NAME  from GrantAccMassUpload_backup
	except 
	Select GAMUID,TEMPLATE_NAME_bk  from GrantAccMassUpload
	)
	begin


		ALter table GrantAccMassUpload
		drop  column [TEMPLATE_NAME] 

		EXEC sp_rename 'GrantAccMassUpload.TEMPLATE_NAME_bk', 'TEMPLATE_NAME'; 

	    Drop table GrantAccMassUpload_backup

	end


end
