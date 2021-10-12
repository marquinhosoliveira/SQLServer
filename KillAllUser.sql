USE [master];

DECLARE @kill varchar(8000) = '';  
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
FROM sys.dm_exec_sessions
-- DBNAME coloque o nome do database para que seja derrubado todos os usuários de um database
WHERE database_id  = db_id('DBNAME')
 
EXEC(@kill);
