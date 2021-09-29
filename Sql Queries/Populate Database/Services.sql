USE [ASDF-Palace]
GO

--3 no subscription needed Spaces
INSERT INTO [dbo].[Services]
           ([title])
     VALUES
           ('Bar'),
		   
		   ('Restaurant'),
		   
		   ('Hair Salon');

--4 subscription needed Spaces
INSERT INTO [dbo].[Services]
           ([title]
           ,[requires_registration])
     VALUES

		   ('Gym',1),
		   
		   ('Room',1),
		   
		   ('Sauna',1),
		   
		   ('Meeting Room',1);
GO


