USE [ASDF-Palace]
GO

create view number_of_sales_per_service as
select title, count(payment_id) as 'number of sales'
from Services, UseService
where service_id=id
group by title

/*
create view sum_of_sales_per_service as
select title, sum(cost) as 'total pay'
from Services as s, UseService as u, Payments as p 
where service_id=s.id and payment_id=p.id and u.nfc_id=p.nfc_id
group by title

create view full_sales_per_service as
select p.nfc_id, title, description, cost 
from Services as s, UseService as u, Payments as p
where service_id=s.id and payment_id=p.id and u.nfc_id=p.nfc_id
*/


create view clients_info as
select first_name,last_name, email, phone
from Clients as c, Emails as e, Phones as p
where c.nfc_id=e.nfc_id and c.nfc_id=p.nfc_id and email in (select top 1 email from Emails where nfc_id= c.nfc_id) and phone in (select top 1 phone from Phones where nfc_id= c.nfc_id)
