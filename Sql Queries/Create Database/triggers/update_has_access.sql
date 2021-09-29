USE [ASDF-Palace]
GO

create trigger update_has_access
on HasAccess
after update
as
begin
	PRINT N'UPDATE HAS ACCESS TRIGGER'
	declare @old_space_id as int
	declare @new_space_id as int
	declare @old_beds as numeric(2,0)
	declare @new_beds as numeric(2,0)
	
	declare @old_end_time as datetime
	declare @new_end_time as datetime
	declare @nfc_id as int

	declare @floor as varchar(1)
	declare @direction as varchar(5)

	select @nfc_id=nfc_id, @old_end_time=end_time, @old_space_id=space_id from deleted
	select @nfc_id=nfc_id, @new_end_time=end_time, @new_space_id=space_id from inserted

	select @new_beds=beds,@floor = SUBSTRING(location,1,1),@direction = RIGHT(location,1) from Spaces where @new_space_id=id
	select @old_beds=beds from Spaces where @old_space_id=id

	--always only one or zero rows with a room will exist for every client
	if (UPDATE(nfc_id) or 1<(select count(*) from inserted))
	begin
		rollback transaction
		RAISERROR ('Make a new insert',0,1) 
	end
	else
	begin
		if(not UPDATE(space_id) and UPDATE(end_time))
		begin
			update HasAccess
			set end_time=@new_end_time
			where nfc_id=@nfc_id
		end

		if(UPDATE(space_id))
		begin
			if(@old_beds=0 or @new_beds=0 or GETDATE() > @old_end_time)
			begin
				RAISERROR ('Make a new insert',0,1) 
				rollback transaction
			end
			else
			begin
				if @new_beds < (select count(*) from HasAccess where space_id=@new_space_id)
				begin
					RAISERROR ('This room is full',0,1) 
					rollback transaction
				end
				else
				begin
					update HasAccess
					set end_time=@new_end_time
					where nfc_id=@nfc_id

					delete 
					from HasAccess 
					where nfc_id=@nfc_id and space_id in (select id from Spaces where title like 'Corridor%' or title like 'Elevator%') 

					insert into HasAccess(nfc_id,space_id,end_time)
					select @nfc_id, id, @new_end_time 
					from Spaces 
					where @floor=SUBSTRING(location,1,1) and (title like 'Elevator%' or (title like 'Corridor%' and @direction=RIGHT(location,1))) 
				end
			end

		end
	end

end