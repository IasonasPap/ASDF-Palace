USE [ASDF-Palace]
GO

create table Clients (
	nfc_id int identity(1,1) primary key,
	first_name varchar(30) not null,
	last_name varchar(40) not null,
	birthday date,
	identification_number varchar(15),
	identification_type varchar(8),
	identification_issue_authority varchar(30),
	check (identification_type in ('Passport','Id card','Ταυτότητα','Διαβατήριο'))
)

create table Services (
	id int identity(1,1) primary key,
	title varchar(30) not null unique,
	requires_registration bit default (0)
)

create table Emails (
	nfc_id int foreign key references Clients(nfc_id) on delete cascade,
	email varchar(30),
	primary key (nfc_id,email)
)

create table Phones (
	nfc_id int foreign key references Clients(nfc_id) on delete cascade,
	phone varchar(20),
	primary key (nfc_id,phone)
)

create table Spaces (
	id int identity(1,1) primary key,
	title varchar(30),
	beds numeric(2,0) default(0),
	location varchar(30) not null unique
)

create table Subscribes (
	nfc_id int references Clients(nfc_id) on delete cascade,
	service_id int references Services(id) on delete cascade,
	subscription_time datetime default(GETDATE()),
	primary key (nfc_id,service_id)
)

create table Visits (
	nfc_id int references Clients(nfc_id) on delete cascade,
	space_id int references Spaces(id) on delete cascade,	
	entry_time datetime,
	exit_time datetime,
	primary key (space_id,nfc_id,entry_time),
	check (entry_time < exit_time)
)

create table HasAccess (
	nfc_id int references Clients(nfc_id) on delete cascade,
	space_id int references Spaces(id) on delete cascade,
	start_time datetime default(GETDATE()),
	end_time datetime not null,
	check (start_time < end_time),
	primary key (nfc_id,space_id)
)

create table Payments (
	id int identity(1,1) primary key,
	description varchar(40),
	cost int,
	payment_time datetime default(GETDATE())
)

create table UseService (
	nfc_id int references Clients(nfc_id) on delete cascade,
	service_id int references Services(id) on delete set null,
	payment_id int references Payments(id) on delete cascade,
	primary key (payment_id)
)

create table ServiceInSpace (
	space_id int references Spaces(id) on delete cascade,
	service_id int references Services(id) on delete cascade,
	primary key (space_id)
)

drop table Emails
drop table Phones
drop table Visits
drop table ServiceInSpace
drop table Subscribes
drop table HasAccess
drop table UseService
drop table Payments
drop table Clients
drop table Services
drop table Spaces