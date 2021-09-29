USE [ASDF-Palace]
GO
---------------------------------------------------------CLIENTS TRIGGERS--------------------------------------------------------------------


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


------------------------------------------------SERVICES TRIGGERS---------------------------------------------------------------------------

----------update a Service: if requires registration column is changed----------------------
--drop trigger update_service
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

----------dont delete ROOM Service and update the UseAccess table---------
--drop trigger delete_service
create trigger delete_service
on Services
instead of delete
as
begin
	PRINT N'DELETE SERVICE TRIGGER'

	declare @service_title varchar(25)
	declare @id int

	DECLARE DeleteServiceCursor CURSOR FOR
		SELECT id,title FROM deleted
	
	OPEN DeleteServiceCursor
	FETCH NEXT FROM DeleteServiceCursor INTO @id,@service_title
	
		
	while (@@FETCH_STATUS=0)
	begin

		if ( @service_title = 'Room')
		begin
			RAISERROR ('Cannot delete Room Service',0,1)
		end
		else
		begin
		;DISABLE TRIGGER delete_has_access on HasAccess;
			delete from HasAccess where space_id in (
				select space_id
				from ServiceInSpace
				where service_id = @id
			)
		;ENABLE TRIGGER delete_has_access on HasAccess;
		
			delete from Services where id=@id
		end
		FETCH NEXT FROM DeleteServiceCursor INTO @id, @service_title
	end
	CLOSE DeleteServiceCursor
	DEALLOCATE DeleteServiceCursor
end


------------------------------------------------SUBSCRIBES TRIGGERS-------------------------------------------------------------------------

---------delete Subscribtion---------------
--drop trigger delete_subscription
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

---------new Subscribtion IF NEEDED and fill UseAccess table------------
--drop trigger insert_subscription
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
			set @cursor_exit=1
			rollback transaction
			RAISERROR ('Service does not need subscription or client has not subscribed to Room Service',0,1)
		end
		else
		begin
			if((@service_title<>'Room' and exists (select * from HasAccess as h, Spaces as s where s.beds<>0 and s.id=h.space_id and nfc_id=@nfc_id and GETDATE()<end_time and GETDATE()>start_time))
			or 
			(@service_title<>'Room' and exists (select * from HasAccess as h, Spaces as s where s.beds<>0 and s.id=h.space_id and nfc_id=@nfc_id) and 1 in (select populate_db from Populate)))
			begin
				select @end_time=end_time from HasAccess as h, Spaces as s where s.beds<>0 and s.id=h.space_id and nfc_id=@nfc_id
				
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
				if(@service_title<>'Room')
				begin
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
end

------------------------------------------------SPACES TRIGGERS-------------------------------------------------

----------convert a space into a Room or a Room into a general Space etc--------------
--drop trigger update_space
create trigger update_space
on Spaces
instead of update
as
begin
	PRINT N'UPDATE SPACE TRIGGER'
	declare @oldBeds numeric(2,0)
	declare @newBeds numeric(2,0)
	declare @space int
	declare @title varchar(20)
	declare @location varchar(30)

	DECLARE UpdateSpaceCursor CURSOR FOR
		SELECT d.id, d.beds, i.title, i.beds, i.location 
		FROM inserted as i, deleted as d 
		WHERE i.id=d.id
	
	OPEN UpdateSpaceCursor
	FETCH NEXT FROM UpdateSpaceCursor INTO @space,@oldBeds, @title, @newBeds, @location
		
	while (@@FETCH_STATUS=0)
	begin

		--select @space=id,@oldBeds=beds from deleted
		--select @title=title,@newBeds=beds,@location=location from inserted

		if exists (select * from Visits where space_id=@space and DATEDIFF(day,exit_time,GETDATE())<31)
		begin
			RAISERROR ('A visit was made in this space in less than 31 days ago',0,1)
		end
		else
		begin
			if (@oldBeds=0 and @newBeds<>0)
			begin
				delete from Spaces where id=@space

				insert into Spaces(title,beds,location) values(@title,@newBeds,@location)

				insert into ServiceInSpace (space_id,service_id)
				select @space,id from Services where title='Room'
			end

			if (@oldBeds<>0 and @newBeds=0)
			begin
				if exists (
					select * 
					from HasAccess as h
					where @space=h.space_id and GETDATE()<h.end_time
					) 
					begin
						RAISERROR ('A client is using this room',0,1)
					end
				else
				begin
					delete from Spaces where id=@space
					insert into Spaces(title,beds,location) values(@title,@newBeds,@location)
				end
			end
		end
		FETCH NEXT FROM UpdateSpaceCursor INTO @space,@oldBeds, @title, @newBeds, @location
	end
	CLOSE UpdateSpaceCursor
	DEALLOCATE UpdateSpaceCursor
end

----------delete a space--------------
--drop trigger delete_space 
create trigger delete_space
on Spaces
instead of delete
as
begin
	PRINT N'DELETE SPACE TRIGGER';
	declare @beds numeric(2,0)
	declare @space int

	DECLARE DeleteSpaceCursor CURSOR FOR
		SELECT id,beds FROM deleted
	
	OPEN DeleteSpaceCursor
	FETCH NEXT FROM DeleteSpaceCursor INTO @space,@beds
		
	while (@@FETCH_STATUS=0)
		begin

		if exists (select * from Visits where space_id=@space and DATEDIFF(day,exit_time,GETDATE())<31)
		begin
			RAISERROR ('A visit was made in this space in less than 31 days ago',0,1)
		end
		else
		begin
			if (@beds<>0)
			begin
				if exists (
					select * 
					from HasAccess as h
					where @space=h.space_id and GETDATE()<h.end_time
					) 
					begin
					   RAISERROR ('A client is using this room',0,1)
					end
				else
					begin
						delete from Spaces where @space=id
					end
			end
			else
			begin
				delete from Spaces where @space=id
			end
		end
		FETCH NEXT FROM DeleteSpaceCursor INTO @space,@beds
	end
	CLOSE DeleteSpaceCursor
	DEALLOCATE DeleteSpaceCursor	
end


----------------------------------------------VISITS TRIGGERS------------------------------------------------------

----------delete Visit: check if the client has left 31 or more days before--------------
--drop trigger delete_visit
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


-------------------------------------------PAYMENTS TRIGGERS-------------------------------------------------------

---------delete Payment---------------
--drop trigger delete_payment
create trigger delete_payment
on Payments
after delete
as
begin
	PRINT N'DELETE PAYMENT TRIGGER'
	declare @payment_id int
	declare @id int

	DECLARE DeletePaymentCursor CURSOR FOR
		SELECT id FROM deleted
	
	OPEN DeletePaymentCursor
	FETCH NEXT FROM DeletePaymentCursor INTO @payment_id
		
	while (@@FETCH_STATUS=0)
	begin

		select @id=nfc_id from UseService where payment_id=@payment_id

		if exists (
			select * 
			from HasAccess as h, Spaces as s
			where @id = h.nfc_id and s.id = h.space_id and s.beds<>0 and GETDATE()<h.end_time
			) 
			begin
			rollback
				RAISERROR ('Client still in hotel',0,1)
			end
		FETCH NEXT FROM DeletePaymentCursor INTO @payment_id
	end
	CLOSE DeletePaymentCursor
	DEALLOCATE DeletePaymentCursor
end


-------------------------------------------USE SERVICE TRIGGERS-------------------------------------------------------

---------delete UseService---------------
--drop trigger delete_use_service
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


-------------------------------------------SERVICE IN SPACE TRIGGERS-------------------------------------------------------

----------delete a Service from a Space (DELETE)--------------
--drop trigger delete_service_in_space
create trigger delete_service_in_space
on ServiceInSpace
after delete
as
begin
	PRINT N'DELETE SERVICE IN SPACE TRIGGER';
	declare @space_id as int
	declare @beds as numeric(2,0)

	DECLARE DeleteServiceInSpaceCursor CURSOR FOR
		SELECT space_id FROM deleted
	
	OPEN DeleteServiceInSpaceCursor
	FETCH NEXT FROM DeleteServiceInSpaceCursor INTO @space_id
		
	while (@@FETCH_STATUS=0)
	begin

	--select @space_id=space_id from deleted
	select @beds=beds from Spaces where id=@space_id

	if @beds<>0 and exists (
		select * 
		from HasAccess as h
		where @space_id=h.space_id and GETDATE()<h.end_time
		) 
		begin
			RAISERROR ('A client is using this room',0,1) 
			rollback transaction
		end
	else
		begin
			delete from HasAccess where space_id=@space_id
		end
		FETCH NEXT FROM DeleteServiceInSpaceCursor INTO @space_id
	end
	CLOSE DeleteServiceInSpaceCursor
	DEALLOCATE DeleteServiceInSpaceCursor
end


----------give a Space to another Service (UPDATE)--------------
--drop trigger update_service_in_space
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

----------attach a Space to a Service (INSERT)--------------
--drop trigger insert_service_in_space
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


---------------------------------------------------HAS ACCESS TRIGGERS-------------------------------------------------

--------------delete from HasAccess--------------
--drop trigger delete_has_access
create trigger delete_has_access
on HasAccess
after delete
as
begin
	PRINT N'DELETE HAS ACCESS TRIGGER';
	declare @end_time as datetime
	declare @start_time as datetime
	declare @beds as numeric(2,0)
	declare @space_id as int
	declare @nfc_id as int

	DECLARE DeleteHasAccessCursor CURSOR FOR
		SELECT nfc_id,start_time, end_time,space_id FROM deleted
	
	OPEN DeleteHasAccessCursor
	FETCH NEXT FROM DeleteHasAccessCursor INTO @nfc_id,@start_time, @end_time,@space_id
		
	while (@@FETCH_STATUS=0)
	begin
		--select @nfc_id=nfc_id,@start_time=start_time, @end_time=end_time,@space_id=space_id from deleted
		select @beds=beds from Spaces where @space_id=id

		if (@beds=0 or (GETDATE()<@end_time and GETDATE()>@start_time))
		begin
			RAISERROR ('A client is using this room or you are not allowed to delete this record',0,1) 
			rollback transaction
		end
		else
		begin
			PRINT N'Make the necessary deletes from HasAccess'
			delete from HasAccess where @nfc_id=nfc_id
		end
		FETCH NEXT FROM DeleteHasAccessCursor INTO @nfc_id,@start_time, @end_time,@space_id
	end
	CLOSE DeleteHasAccessCursor
	DEALLOCATE DeleteHasAccessCursor

end

--------------insert into HasAccess (only access to a room can be inserted explicitly)--------------
--drop trigger insert_has_access
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


--------------update HasAccess--------------
--drop trigger update_has_access
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


------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
/*
drop trigger delete_client
drop trigger update_service
drop trigger delete_service
drop trigger delete_subscription
drop trigger insert_subscription
drop trigger update_space
drop trigger delete_space
drop trigger delete_visit
drop trigger delete_payment
drop trigger delete_use_service
drop trigger delete_service_in_space
drop trigger update_service_in_space
drop trigger insert_service_in_space
drop trigger delete_has_access
drop trigger insert_has_access
drop trigger update_has_access
*/
