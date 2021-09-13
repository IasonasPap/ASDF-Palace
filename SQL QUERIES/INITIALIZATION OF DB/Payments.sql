USE [ASDF-Palace]
GO

--ROOM PAYMENTS
INSERT INTO [dbo].[Payments]
           ([description],[cost])
     VALUES
           ('Room1',200),
		   ('Room3',60),
		   ('Room4',400),
		   ('Room5',250),
		   ('Room6',180),
		   ('Room7',200),
		   ('Room8',90),
		   ('Room9',240),
		   ('Room11',390),
		   ('Room12',440),

		   ('Room13',1000),
		   ('Room14',130),
		   ('Room15',120),
		   ('Room17',180),
		   ('Room18',230),
		   ('Room19',320),
		   ('Room20',310),
		   ('Room21',370),
		   ('Room23',430),
		   ('Room24',420),

		   ('Room25',480),
		   ('Room26',500),
		   ('Room27',600),
		   ('Room28',510),
		   ('Room29',220),
		   ('Room30',250),
		   ('Room31',200),
		   ('Room32',100),
		   ('Room33',280),
		   ('Room34',245)
GO

--SERVICES PAYMENTS
INSERT INTO [dbo].[Payments]
           ([description],[cost])
     VALUES
           ('Gym',200),
		   ('Gym',60),
		   ('Gym',400),
		   ('Gym',250),
		   ('Sauna',180),
		   ('Sauna',200),
		   ('Sauna',90),
		   ('Meeting Room',240),
		   ('Meeting Room',390),
		   ('Meeting Room',440),

		   ('Gym',1000),
		   ('Gym',130),
		   ('Gym',120),
		   ('Sauna',180),
		   ('Sauna',230),
		   ('Sauna',320),
		   ('Sauna',310),
		   ('Meeting Room',370),
		   ('Meeting Room',430),
		   ('Meeting Room',420),

		   ('Gym',480),
		   ('Gym',500),
		   ('Gym',600),
		   ('Sauna',510),
		   ('Sauna',220),
		   ('Meeting Room',200),
		   ('Meeting Room',100)
GO
