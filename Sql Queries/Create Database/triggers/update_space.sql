USE [ASDF-Palace]
GO

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