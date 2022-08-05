

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='PerqstTaxExceptionRule'
			and CONSTRAINT_NAME = 'FK__PerqstTax__Emplo__60283922'
			)
begin
ALTER TABLE PerqstTaxExceptionRule
drop CONSTRAINT FK__PerqstTax__Emplo__60283922;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='PerqstTaxExceptionRule'
			and CONSTRAINT_NAME = 'FK__PerqstTax__Grant__611C5D5B'
			)
begin
ALTER TABLE PerqstTaxExceptionRule
drop CONSTRAINT FK__PerqstTax__Grant__611C5D5B;
end

If Not exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='PerqstTaxExceptionRule'
			and CONSTRAINT_type = 'FOREIGN KEY'
			)
begin

ALTER TABLE PerqstTaxExceptionRule
ADD  FOREIGN KEY ([Employeeid])
    REFERENCES [dbo].[EmployeeMaster] ([EmployeeID]);


ALTER TABLE PerqstTaxExceptionRule
ADD  FOREIGN KEY ([Grantoptionid])
    REFERENCES [dbo].[GrantOptions] ([GrantOptionId]);
end
 