
If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ApprovedAccleratedVesting'
			and CONSTRAINT_NAME = 'FK_ApproveAccleratedVesting_AcceleratedVesting'
			)
begin
ALTER TABLE ApprovedAccleratedVesting
CHECK CONSTRAINT FK_ApproveAccleratedVesting_AcceleratedVesting;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ApprovedAccleratedVesting'
			and CONSTRAINT_NAME = 'FK_ApproveAccleratedVesting_GrantLeg'
			)
begin
ALTER TABLE ApprovedAccleratedVesting
CHECK CONSTRAINT FK_ApproveAccleratedVesting_GrantLeg;
end