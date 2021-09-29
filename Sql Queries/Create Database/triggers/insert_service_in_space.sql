USE [ASDF-Palace]
GO

create trigger insert_service_in_space
on ServiceInSpace
after insert
as
begin
	PRINT N'INSERT SERVICE IN SPACE TRIGGER';
	declare @beds as numeric(2,0)
	declare @space_id as int
	declare @service_id as int
	declare @requires_registration as bit
	declare @service_title as varchar(25)
	declare @space_title as varchar(20)

	DECLARE InsertServiceInSpaceCursor CURSOR FOR
		SELECT space_id,service_id FROM inserted
	
	OPEN InsertServiceInSpaceCursor
	FETCH NEXT FROM InsertServiceInSpaceCursor INTO @space_id,@service_id
		
	while (@@FETCH_STATUS=0)
	begin

		--select @space_id=space_id, @service_id=service_id from inserted
		select @beds=beds,@space_title=title from Spaces where id=@space_id
		select @service_title=title, @requires_registration=requires_registration from Services where id=@service_id

		if((@beds<>0 and @service_title<>'Room')
			or (@beds=0 and @service_title='Room')
			or (@space_title like 'Elevator%')
			or (@space_title like 'Corridor%')
		)
		begin
			RAISERROR ('Room Service should be attached to a Room Space',0,1) 
			rollback transaction
		end
		else
		begin
			if(@beds=0)
			begin
				if(@requires_registration=0)
				begin
					;DISABLE TRIGGER insert_has_access on HasAccess;
						insert into HasAccess(nfc_id,space_id,end_time)
						select nfc_id,@space_id,end_time
						from HasAccess as h, Spaces as s
						where s.id = h.space_id and s.beds<>0 and GETDATE()<h.end_time
					
					;ENABLE TRIGGER insert_has_access on HasAccess;
				end
				else
				begin
					;DISABLE TRIGGER insert_has_access on HasAccess;
						insert into HasAccess(nfc_id,space_id,end_time)
						select sub.nfc_id,@space_id,has.end_time
						from HasAccess as has, Subscribes as sub, Spaces as spa
						where sub.service_id=@service_id and sub.nfc_id=has.nfc_id and spa.id = has.space_id and spa.beds<>0 and GETDATE()<has.end_time
					;ENABLE TRIGGER insert_has_access on HasAccess;
				end
			end		
		end
		FETCH NEXT FROM InsertServiceInSpaceCursor INTO @space_id,@service_id
	end
	CLOSE InsertServiceInSpaceCursor
	DEALLOCATE InsertServiceInSpaceCursor
end