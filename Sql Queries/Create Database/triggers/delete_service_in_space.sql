USE [ASDF-Palace]
GO

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