USE [ASDF-Palace]
GO

create trigger delete_use_service
on UseService
after delete
as
begin
	PRINT N'DELETE USE SERVICE TRIGGER';
	declare @payment_id int
	declare @id int

	DECLARE DeleteUseServiceCursor CURSOR FOR
		SELECT nfc_id,payment_id FROM deleted
	
	OPEN DeleteUseServiceCursor
	FETCH NEXT FROM DeleteUseServiceCursor INTO @id, @payment_id
		
	while (@@FETCH_STATUS=0)
	begin

	--select @id=nfc_id,@payment_id=payment_id from deleted

	if exists (
		select * 
		from HasAccess as h, Spaces as s
		where @id = h.nfc_id and s.id = h.space_id and s.beds<>0 and GETDATE()<h.end_time
		) 
		begin
			RAISERROR ('Client still in hotel',0,1)
			rollback transaction
		end
		FETCH NEXT FROM DeleteUseServiceCursor INTO @id, @payment_id
	end
	CLOSE DeleteUseServiceCursor
	DEALLOCATE DeleteUseServiceCursor
end