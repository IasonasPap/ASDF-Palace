USE [ASDF-Palace]
GO

create trigger update_service
on Services
after update
as
begin
	PRINT N'UPDATE SERVICE TRIGGER';
	declare @new_requires_registration as bit
	declare @old_requires_registration as bit
	declare @title as varchar(30)
	declare @service_id as int

	DECLARE UpdateServiceCursor CURSOR FOR
		SELECT d.requires_registration, i.requires_registration, d.title, d.id
		FROM deleted AS d, inserted AS i
		WHERE d.id=i.id
	
	OPEN UpdateServiceCursor
	FETCH NEXT FROM UpdateServiceCursor INTO @old_requires_registration, @new_requires_registration, @title, @service_id
		
	while (@@FETCH_STATUS=0)
	begin
		PRINT N'MESA STO LOOP'

		--select @new_requires_registration=requires_registration from inserted
		--select @old_requires_registration=requires_registration, @title=title, @service_id=id from deleted

		if(@title='Room')
		begin
			RAISERROR ('You can not update the Room Service at all',0,1)
			ROLLBACK TRANSACTION
		end
		else
		begin
			if(@old_requires_registration=1 and @new_requires_registration=0)
			begin
				delete from Subscribes where service_id=@service_id

				;DISABLE TRIGGER insert_has_access on HasAccess;

				insert into HasAccess(nfc_id,space_id,end_time)
				select nfc_id,space_id,end_time
				from (select nfc_id,end_time from HasAccess as h, Spaces as s where s.beds<>0 and h.space_id=s.id and GETDATE()<end_time) as new1,
					(select space_id from ServiceInSpace where service_id=@service_id) as new2

				;ENABLE TRIGGER insert_has_access on HasAccess;

			end

			if(@old_requires_registration=0 and @new_requires_registration=1)
			begin
				PRINT N'Delete some things from HasAccess'
				;DISABLE TRIGGER delete_has_access on HasAccess;
					delete from HasAccess where space_id in (select space_id from ServiceInSpace where service_id=@service_id)
				;ENABLE TRIGGER delete_has_access on HasAccess;
			end
		end
		FETCH NEXT FROM UpdateServiceCursor INTO @old_requires_registration, @new_requires_registration, @title, @service_id
	end
	CLOSE UpdateServiceCursor
	DEALLOCATE UpdateServiceCursor
	
end