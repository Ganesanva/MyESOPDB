IF  EXISTS (
				SELECT 'X'
				FROM SYS.INDEXES 
				WHERE  NAME = 'Scheme_MIT_ID'
			  )
BEGIN
Drop index Scheme.Scheme_MIT_ID
END

