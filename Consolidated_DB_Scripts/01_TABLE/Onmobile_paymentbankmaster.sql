

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='paymentbankmaster'
			and CONSTRAINT_NAME = 'FK__paymentba__TCMID__4A23E96A'
			)
begin
ALTER TABLE paymentbankmaster
drop CONSTRAINT FK__paymentba__TCMID__4A23E96A;
end

If Not exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='paymentbankmaster'
			and CONSTRAINT_type = 'FOREIGN KEY'
			)
begin

ALTER TABLE paymentbankmaster
ADD  FOREIGN KEY ([TCMID])
    REFERENCES [dbo].[TRANSACTION_COST_METHOD_MASTER] ([TCMID]);
end