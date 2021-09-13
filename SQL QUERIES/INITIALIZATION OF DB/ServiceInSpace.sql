USE [ASDF-Palace]
GO

INSERT INTO ServiceInSpace (space_id,service_id)
SELECT s.id,1
FROM Spaces as s
WHERE s.title Like 'Bar%'

INSERT INTO ServiceInSpace (space_id,service_id)
SELECT s.id,2
FROM Spaces as s
WHERE s.title Like 'Restaurant%'

INSERT INTO ServiceInSpace (space_id,service_id)
SELECT s.id,3
FROM Spaces as s
WHERE s.title Like 'Hair Salon%'

INSERT INTO ServiceInSpace (space_id,service_id)
SELECT s.id,4
FROM Spaces as s
WHERE s.title Like 'Gym%'

INSERT INTO ServiceInSpace (space_id,service_id)
SELECT s.id,5
FROM Spaces as s
WHERE s.title Like 'Room%'

INSERT INTO ServiceInSpace (space_id,service_id)
SELECT s.id,6
FROM Spaces as s
WHERE s.title Like 'Sauna%'

INSERT INTO ServiceInSpace (space_id,service_id)
SELECT s.id,7
FROM Spaces as s
WHERE s.title Like 'Meeting Room%'



--ALL IN ONE
INSERT INTO ServiceInSpace (space_id,service_id)
SELECT sp.id,se.id
FROM Services as se ,Spaces as sp
WHERE sp.title Like (se.title +'%')

