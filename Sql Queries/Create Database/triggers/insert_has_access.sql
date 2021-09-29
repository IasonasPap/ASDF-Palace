USE [ASDF-Palace]
GO

create trigger insert_has_access
on HasAccess
after insert
as
begin
	PRINT N'INSERT HAS ACCESS TRIGGER'
	declare @space_id as int
	declare @end_time as datetime
	declare @start_time as datetime
	declare @beds as numeric(2,0)
	declare @nfc_id as int
	declare @location as varchar(30)
	declare @floor as varchar(1)
	declare @direction as varchar(5)
	declare @cursor_exit as bit = 0

	--select @nfc_id=nfc_id,@space_id=space_id,@start_time=start_time, @end_time=end_time from inserted
	--select @beds=beds,@location=location from Spaces where @space_id=id
	
	DECLARE HasAccessCursor CURSOR FOR
		SELECT nfc_id, space_id, start_time, end_time FROM inserted
	
	OPEN HasAccessCursor
	FETCH NEXT FROM HasAccessCursor INTO @nfc_id, @space_id, @start_time, @end_time
		
	while (@@FETCH_STATUS=0 and @cursor_exit=0)
	begin
		select @beds=beds,@location=location from Spaces where @space_id=id
	
		select @floor = SUBSTRING(@location,1,1)
		select @direction = RIGHT(@location,1)
		--if the client is not subscribed to Room Service or already has access to a room ROLLBACK
		if (@beds=0
			or exists (select * from HasAccess,Spaces where nfc_id=@nfc_id and space_id=id and beds<>0 and id<>@space_id and GETDATE()<end_time)
			or not exists (select nfc_id from Subscribes, Services where nfc_id=@nfc_id and id=service_id and title='Room')
			or @beds < (select count(*) from HasAccess,Spaces where space_id=id and beds<>0 and id=@space_id and GETDATE()<end_time)
			)
		begin
			if(@beds < (select count(*) from HasAccess,Spaces where space_id=id and beds<>0 and id=@space_id and GETDATE()<end_time))
			begin
				PRINT N'NOT ENOUGH SPACE IN ROOM'
			end
			PRINT N'inside has insert into has access problem'
			set @cursor_exit=1
			rollback
			RAISERROR ('No subscription to this service or room registry already exists',0,1) 
		end
		else
		begin
			if exists (select * from HasAccess,Spaces where nfc_id=@nfc_id and space_id=id and beds<>0 and id<>@space_id and GETDATE()>end_time)
			begin
				delete from HasAccess where nfc_id=@nfc_id and space_id<>@space_id
			end

			insert into HasAccess(nfc_id,space_id,start_time,end_time)
			select @nfc_id, space_id,@start_time, @end_time from ServiceInSpace,Services where id=service_id and requires_registration=0
		
			insert into HasAccess(nfc_id,space_id,start_time,end_time)
			select @nfc_id, id,@start_time, @end_time from Spaces where @floor=SUBSTRING(location,1,1) and (title like 'Elevator%' or (title like 'Corridor%' and @direction=RIGHT(location,1)))
		end

		FETCH NEXT FROM HasAccessCursor INTO @nfc_id, @space_id, @start_time, @end_time 
	end
	CLOSE HasAccessCursor
	DEALLOCATE HasAccessCursor
end