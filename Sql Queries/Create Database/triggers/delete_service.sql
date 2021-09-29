USE [ASDF-Palace]
GO

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