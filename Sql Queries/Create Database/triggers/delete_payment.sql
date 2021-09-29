USE [ASDF-Palace]
GO

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