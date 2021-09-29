USE [ASDF-Palace]
GO

CREATE INDEX idx_access_time
ON HasAccess (start_time,end_time);

CREATE INDEX idx_room
ON Spaces (beds);

CREATE INDEX idx_location
ON Spaces (location);

CREATE INDEX idx_title
ON Spaces (title);
