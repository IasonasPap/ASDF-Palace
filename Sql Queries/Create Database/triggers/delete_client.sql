USE [ASDF-Palace]
GO

----------delete Client: check if the client has left 31 or more days before--------------
--drop trigger delete_client;
create trigger delete_client
on Clients
instead of delete
as
begin
	PRINT N'DELETE CLIENT TRIGGER'
	declare @days as int
	declare @nfc_id as int

	DECLARE DeleteClientCursor CURSOR FOR
		SELECT nfc_id FROM deleted
	
	OPEN DeleteClientCursor
	FETCH NEXT FROM DeleteClientCursor INTO @nfc_id
		
	while (@@FETCH_STATUS=0)
	begin

		if exists (
			select * 
			from HasAccess as h, Spaces as s
			where @nfc_id = h.nfc_id and s.id = h.space_id and s.beds<>0 and GETDATE()<h.end_time and GETDATE()>h.start_time
			) 
			begin
			   RAISERROR ('Client still in hotel',0,1) 
			end
		else
		begin
			select @days= DATEDIFF(day,MAX(v.exit_time),GETDATE())
			from Visits as v
			where @nfc_id = v.nfc_id

			if (@days > 30 or @days is null)
			begin	
				delete from Clients where nfc_id = @nfc_id
			end
			else 
				RAISERROR ('Client left the hotel less than 30 days ago',0,1)
		end
		FETCH NEXT FROM DeleteClientCursor INTO @nfc_id
	end
	CLOSE DeleteClientCursor
	DEALLOCATE DeleteClientCursor
end;