
If exists (
select 'X'
from sys.triggers 
where name = 'TRIG_UPDATE_CANCELLATION_REASON'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].TRIG_UPDATE_CANCELLATION_REASON
ON [dbo].Cancelled
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='Cancelled'
			and CONSTRAINT_NAME = 'FK_Cancelled_GrantLeg'
			)
begin
ALTER TABLE Cancelled
CHECK CONSTRAINT FK_Cancelled_GrantLeg;
end
