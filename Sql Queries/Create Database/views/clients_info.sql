USE [ASDF-Palace]
GO

create view clients_info as
select first_name,last_name, email, phone
from Clients as c, Emails as e, Phones as p
where c.nfc_id=e.nfc_id and c.nfc_id=p.nfc_id and email in (select top 1 email from Emails where nfc_id= c.nfc_id) and phone in (select top 1 phone from Phones where nfc_id= c.nfc_id)
