IF  EXISTS (
				SELECT 'X'
				FROM SYS.INDEXES 
				WHERE  NAME = 'Exercised_GLseNo'
			  )
BEGIN
Drop index Exercised.Exercised_GLseNo
END
 