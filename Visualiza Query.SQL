DECLARE @sqltext VARBINARY(128), @id bigint

set @id = 0 -- Colocar o ID da Conexão, veja executando o comando sp_who2


SELECT @sqltext = sql_handle
FROM sys.sysprocesses
WHERE spid = @id               
SELECT TEXT
FROM sys.dm_exec_sql_text(@sqltext)
