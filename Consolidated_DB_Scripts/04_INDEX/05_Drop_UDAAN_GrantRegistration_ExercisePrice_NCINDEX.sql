IF  EXISTS (
				SELECT 'X'
				FROM SYS.INDEXES 
				WHERE  NAME = 'GrantRegistration_ExercisePrice_NCINDEX'
			  )
BEGIN
Drop index GrantRegistration.GrantRegistration_ExercisePrice_NCINDEX
END


 