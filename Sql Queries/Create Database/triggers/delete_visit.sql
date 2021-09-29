USE [ASDF-Palace]
GO

create trigger delete_visit
on Visits
after delete
as
begin
	PRINT N'DELETE VISIT TRIGGER'
	declare @days as int
	declare @nfc_id as int
	declare @space_id as int
	declare @time as datetime

	DECLARE DeleteVisitCursor CURSOR FOR
		SELECT nfc_id,space_id,entry_time,DATEDIFF(day,exit_time,GETDATE())  FROM deleted
	
	OPEN DeleteVisitCursor
	FETCH NEXT FROM DeleteVisitCursor INTO @nfc_id,@space_id,@time,@days
		
	while (@@FETCH_STATUS=0)
		begin
		--select @nfc_id=nfc_id,@space_id=space_id, @time=entry_time, @days=DATEDIFF(day,exit_time,GETDATE()) from deleted

		if exists (
			select * 
			from HasAccess as h, Spaces as s
			where @nfc_id = h.nfc_id and s.id = h.space_id and s.beds<>0 and GETDATE()<h.end_time
			) 
			begin
			   RAISERROR ('Client still in hotel',0,1)
			   rollback transaction
			end
		else
		begin
			if (@days < 31)
			begin 
				RAISERROR ('Client made this visit less than 30 days ago',0,1)
				rollback transaction
				--delete from Visits where nfc_id = @nfc_id and space_id=@space_id and entry_time=@time
			end
		end
		FETCH NEXT FROM DeleteVisitCursor INTO @nfc_id,@space_id,@time,@days
	end
	CLOSE DeleteVisitCursor
	DEALLOCATE DeleteVisitCursor
end