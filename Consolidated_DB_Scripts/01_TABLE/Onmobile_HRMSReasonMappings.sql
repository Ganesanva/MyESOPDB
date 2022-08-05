

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='HRMSReasonMappings'
			and CONSTRAINT_NAME = 'FK__HRMSReaso__Reaso__7DB89C09'
			)
begin
ALTER TABLE HRMSReasonMappings
drop CONSTRAINT FK__HRMSReaso__Reaso__7DB89C09;
end

If Not exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='HRMSReasonMappings'
			and CONSTRAINT_type = 'FOREIGN KEY'
			)
begin

ALTER TABLE HRMSReasonMappings
ADD  FOREIGN KEY (ReasonForTermination)
    REFERENCES [dbo].[ReasonForTermination] ([ID]);
end
