# CREATE DATABASE

## Create tables

Run the script in the 'create tables.sql' file.

There is an extra Table called "Populate" which is used only for the proccess of populating the database for the first time

## Create triggers

Run separately every script in the 'Create Database/triggers' folder (except the 'all triggers.sql' file) or 
use the 'Create Database/triggers/all triggers.sql' and by selecting one trigger at a time click o n "Execute"

## Create views

Run separately every script in the 'Create Database/views' folder (except the 'all views.sql' file) or 
use the 'Create Database/views/all views.sql' and by selecting one trigger at a time click on "Execute"

## Create indexes

!!!!! Create the givven indexes after you populate the database !!!!!

Run the scripts in the 'Create Database/indexes/create indexes.sql' file.




# POPULATE DATABASE

!!!!!!! IT IS RECOMMENDED YOU EXECUTE EACH FILE IN THE GIVEN ORDER !!!!!!!!!

Execute each file in the 'Populate Database' folder in the below order:
1. Clients.sql
2. Services.sql
3. Spaces.sql
4. ServiceInSpace.sql
5. Visits.sql
6. SubscribeToRoomService.sql
7. HasAccessToRoom.sql
8. SubscribeToOtherServices.sql
9. Payments.sql
10. UseService.sql

In the end run this command :

`UPDATE Populate SET populate_db=0 WHERE populate_db=1`