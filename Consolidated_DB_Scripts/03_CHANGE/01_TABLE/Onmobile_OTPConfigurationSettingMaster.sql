


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='OTPConfigurationSettingMaster'
			and CONSTRAINT_NAME = 'FK__OTPConfig__OTPCo__2B7A0922'
			)
begin
ALTER TABLE OTPConfigurationSettingMaster
drop CONSTRAINT FK__OTPConfig__OTPCo__2B7A0922;
end

If Not exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='OTPConfigurationSettingMaster'
			and CONSTRAINT_type = 'FOREIGN KEY'
			)
begin

ALTER TABLE OTPConfigurationSettingMaster
ADD  FOREIGN KEY ([OTPConfigurationTypeID])
    REFERENCES [dbo].[OTPConfigurationTypeMaster] ([OTPConfigurationTypeID]);
end
 