USE [ASDF-Palace]
GO

--subscribe in ROOM Service
INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id])
SELECT c.nfc_id,5
FROM Clients as c
WHERE c.nfc_id<>2 AND c.nfc_id<>10 AND c.nfc_id<>16 AND c.nfc_id<>22 AND c.nfc_id<>36

--subscribe in GYM Service 13 Clients
INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id])
SELECT c.nfc_id,4
FROM Clients as c
WHERE (YEAR(c.birthday) between 1990 and 2000) or 
	(YEAR(c.birthday) between 1970 and 1976)

--subscribe in SAUNA Service 25 Clients
INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id])
SELECT c.nfc_id,6
FROM Clients as c
WHERE (YEAR(c.birthday) between 1957 and 2003)

--subscribe in MEETING ROOM Service 10 Clients
INSERT INTO [dbo].[Subscribes] ([nfc_id],[service_id])
SELECT c.nfc_id,7
FROM Clients as c
WHERE (YEAR(c.birthday) between 1941 and 1953) or 
	(YEAR(c.birthday) between 1962 and 1971)