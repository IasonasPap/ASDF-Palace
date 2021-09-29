USE [ASDF-Palace]
GO

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