 

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='UserLoginOTPDetails'
			and CONSTRAINT_NAME = 'FK__UserLogin__OTPCo__322706B1'
			)
begin
ALTER TABLE UserLoginOTPDetails
drop CONSTRAINT FK__UserLogin__OTPCo__322706B1;
end

If Not exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='UserLoginOTPDetails'
			and CONSTRAINT_type = 'FOREIGN KEY'
			)
begin

ALTER TABLE UserLoginOTPDetails
ADD      FOREIGN KEY ([OTPConfigurationSettingMasterID]) REFERENCES [dbo].[OTPConfigurationSettingMaster] ([OTPConfigurationSettingMasterID]);
end
 
 