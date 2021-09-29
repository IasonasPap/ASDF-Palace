USE [ASDF-Palace]
GO

create trigger insert_subscription
on Subscribes
after insert
as
begin
	PRINT N'INSERT SUBSCRIPTION TRIGGER'
	declare @registration_needed int
	declare @service_id int
	declare @nfc_id int
	declare @service_title varchar(25)
	declare @end_time datetime
	declare @start_time datetime
	declare @subscription_time datetime
	declare @cursor_exit bit=0

	DECLARE InsertSubscriptionCursor CURSOR FOR
		SELECT subscription_time, service_id, nfc_id FROM inserted
	
	OPEN InsertSubscriptionCursor
	FETCH NEXT FROM InsertSubscriptionCursor INTO @subscription_time,@service_id, @nfc_id
	
	PRINT @subscription_time
		
	while (@@FETCH_STATUS=0 and @cursor_exit=0)
	begin
		--select @start_time=subscription_time,@service_id=service_id, @nfc_id=nfc_id from inserted

		select @service_title=title, @registration_needed=requires_registration 
		from Services
		where id=@service_id

		--if the service doesn't need registration or the client has not subscribed to Room Service ROLLBACK THE INSERT
		if (@registration_needed=0
			or (@service_title<>'Room' and not exists (select * from Subscribes as su, Services as se where @nfc_id=su.nfc_id and su.service_id=se.id and se.title='Room'))
		) 
		begin
			PRINT N'OUT111111'
			set @cursor_exit=1
			rollback transaction
			RAISERROR ('Service does not need subscription or client has not subscribed to Room Service',0,1)
		end
		else
		begin
			PRINT N'OUT22222'
			if((@service_title<>'Room' and exists (select * from HasAccess as h, Spaces as s where s.beds<>0 and s.id=h.space_id and nfc_id=@nfc_id and GETDATE()<end_time and GETDATE()>start_time))
			or 
			(@service_title<>'Room' and exists (select * from HasAccess as h, Spaces as s where s.beds<>0 and s.id=h.space_id and nfc_id=@nfc_id) and 1 in (select populate_db from Populate)))
			begin
				PRINT N'OUT33333'
				select @end_time=end_time from HasAccess as h, Spaces as s where s.beds<>0 and s.id=h.space_id and nfc_id=@nfc_id
				PRINT(@nfc_id)
				PRINT(@service_title)
				PRINT(@subscription_time)
				PRINT(@end_time)
				;
				DISABLE TRIGGER insert_has_access on HasAccess;

				insert into HasAccess(nfc_id,space_id,start_time,end_time)
				select @nfc_id,space_id,@subscription_time,@end_time
				from ServiceInSpace
				where service_id=@service_id
				;
				ENABLE trigger insert_has_access on HasAccess;
			end
			else
			begin
				PRINT N'OUT4444444'
				if(@service_title<>'Room')
				begin
					PRINT N'OUT55555'
					set @cursor_exit=1
					rollback transaction
					RAISERROR ('Choose a room first',0,1)
				end
			end
		end
		FETCH NEXT FROM InsertSubscriptionCursor INTO @subscription_time,@service_id, @nfc_id
	end
	CLOSE InsertSubscriptionCursor
	DEALLOCATE InsertSubscriptionCursor
	PRINT N'OUT66666'
end