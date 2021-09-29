USE [ASDF-Palace]
GO

create trigger delete_subscription
on Subscribes
after delete
as
begin
	PRINT N'DELETE SUBSCRIPTION TRIGGER'
	declare @nfc_id int
	declare @service_id int
	declare @service_title varchar(30)

	DECLARE DeleteSubscriptionCursor CURSOR FOR
		SELECT nfc_id,service_id FROM deleted
	
	OPEN DeleteSubscriptionCursor
	FETCH NEXT FROM DeleteSubscriptionCursor INTO @nfc_id,@service_id
	
		
	while (@@FETCH_STATUS=0)
	begin

		--select @nfc_id=nfc_id,@service_id=service_id from deleted
		select @service_title=title from Services where id=@service_id

		if (@service_title='Room')
			begin
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
						delete from HasAccess where nfc_id=@nfc_id
					end
			end
		else
		begin
			;DISABLE TRIGGER delete_has_access on HasAccess;
			delete from HasAccess where nfc_id=@nfc_id and space_id in (
				select space_id
				from ServiceInSpace
				where service_id = @service_id
			)
			;ENABLE TRIGGER delete_has_access on HasAccess;
		end
		FETCH NEXT FROM DeleteSubscriptionCursor INTO @nfc_id,@service_id
	end
	CLOSE DeleteSubscriptionCursor
	DEALLOCATE DeleteSubscriptionCursor
end
