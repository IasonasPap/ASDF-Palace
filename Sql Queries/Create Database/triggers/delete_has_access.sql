USE [ASDF-Palace]
GO

create trigger delete_has_access
on HasAccess
after delete
as
begin
	PRINT N'DELETE HAS ACCESS TRIGGER';
	declare @end_time as datetime
	declare @start_time as datetime
	declare @beds as numeric(2,0)
	declare @space_id as int
	declare @nfc_id as int

	DECLARE DeleteHasAccessCursor CURSOR FOR
		SELECT nfc_id,start_time, end_time,space_id FROM deleted
	
	OPEN DeleteHasAccessCursor
	FETCH NEXT FROM DeleteHasAccessCursor INTO @nfc_id,@start_time, @end_time,@space_id
		
	while (@@FETCH_STATUS=0)
	begin
		--select @nfc_id=nfc_id,@start_time=start_time, @end_time=end_time,@space_id=space_id from deleted
		select @beds=beds from Spaces where @space_id=id

		if (@beds=0 or (GETDATE()<@end_time and GETDATE()>@start_time))
		begin
			RAISERROR ('A client is using this room or you are not allowed to delete this record',0,1) 
			rollback transaction
		end
		else
		begin
			PRINT N'Make the necessary deletes from HasAccess'
			delete from HasAccess where @nfc_id=nfc_id
		end
		FETCH NEXT FROM DeleteHasAccessCursor INTO @nfc_id,@start_time, @end_time,@space_id
	end
	CLOSE DeleteHasAccessCursor
	DEALLOCATE DeleteHasAccessCursor

end