USE [ASDF-Palace]
GO

create trigger update_service_in_space
on ServiceInSpace
after update
as
begin
	PRINT N'UPDATE SERVICE IN SPACE TRIGGER'
	declare @beds as numeric(2,0)
	declare @space_id as int
	declare @before_service as int
	declare @now_service as int
	declare @now_requires_registration as bit
	declare @before_requires_registration as bit
	declare @service_title as varchar(25)
	declare @space_title as varchar(20)

	if (1<(select count(*) from inserted))
	begin 
		rollback transaction
		RAISERROR ('Make only a single update ',0,1)
	end

	select @space_id=space_id, @now_service=service_id from inserted
	select @before_service=service_id from deleted

	select @beds=beds,@space_title=title from Spaces where id=@space_id
	select @service_title=title, @now_requires_registration=requires_registration from Services where id=@now_service
	select @before_requires_registration=requires_registration from Services where id=@before_service

	if((@beds<>0) or (@space_title like 'Elevator%') or (@space_title like 'Corridor%'))
	begin
		RAISERROR ('Room Service should be attached to a Room Space ',0,1) 
		rollback transaction
	end
	else
	begin
		if(@before_requires_registration=1 and @now_requires_registration=0)
		begin
			insert into HasAccess(nfc_id,space_id,end_time)
			select h.nfc_id,@space_id,end_time
			from HasAccess as h, Spaces as s
			where s.id = h.space_id and s.beds<>0 and GETDATE()<h.end_time
				and (h.nfc_id not in (select has.nfc_id from HasAccess as has where space_id=@space_id))
		end

		if(@before_requires_registration=0 and @now_requires_registration=1)
		begin
			delete from HasAccess
			where space_id=@space_id and nfc_id not in (select s.nfc_id from Subscribes as s where @now_service=service_id)
		end
		
		if(@before_requires_registration=1 and @now_requires_registration=1)
		begin
			delete from HasAccess where space_id=@space_id

			insert into HasAccess(nfc_id,space_id,end_time)
			select h.nfc_id,@space_id,end_time
			from HasAccess as h, Spaces as s
			where s.id = h.space_id and s.beds<>0 and GETDATE()<h.end_time
				and (h.nfc_id in (select s.nfc_id from Subscribes as s where @now_service=service_id))
		end		
	end
end