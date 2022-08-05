

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='tempPerqstTaxExceptionRule'
			and CONSTRAINT_NAME = 'FK__tempPerqs__Emplo__231F2AE2'
			)
begin
ALTER TABLE tempPerqstTaxExceptionRule
drop CONSTRAINT FK__tempPerqs__Emplo__231F2AE2;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='tempPerqstTaxExceptionRule'
			and CONSTRAINT_NAME = 'FK__tempPerqs__Emplo__65E11278'
			)
begin
ALTER TABLE tempPerqstTaxExceptionRule
drop CONSTRAINT FK__tempPerqs__Emplo__65E11278;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='tempPerqstTaxExceptionRule'
			and CONSTRAINT_NAME = 'FK__tempPerqs__Grant__66D536B1'
			)
begin
ALTER TABLE tempPerqstTaxExceptionRule
drop CONSTRAINT FK__tempPerqs__Grant__66D536B1;
end

If Not exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='tempPerqstTaxExceptionRule'
			and CONSTRAINT_type = 'FOREIGN KEY'
			)
begin

ALTER TABLE tempPerqstTaxExceptionRule
ADD  FOREIGN KEY ([Employeeid]) REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])

ALTER TABLE tempPerqstTaxExceptionRule
ADD FOREIGN KEY ([Employeeid]) REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])

ALTER TABLE tempPerqstTaxExceptionRule
ADD FOREIGN KEY ([Grantoptionid]) REFERENCES [dbo].[GrantOptions] ([GrantOptionId])
end
 
 
If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='tempPerqstTaxExceptionRule'
			and CONSTRAINT_NAME = 'FK__tempPerqs__Emplo__1A69E950'
			)
begin
ALTER TABLE tempPerqstTaxExceptionRule
CHECK CONSTRAINT FK__tempPerqs__Emplo__1A69E950;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='tempPerqstTaxExceptionRule'
			and CONSTRAINT_NAME = 'FK__tempPerqs__Emplo__56B3DD81'
			)
begin
ALTER TABLE tempPerqstTaxExceptionRule
CHECK CONSTRAINT FK__tempPerqs__Emplo__56B3DD81;
end

