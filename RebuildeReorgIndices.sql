 declare @tableName nvarchar(500) 
declare @indexName nvarchar(500) 
declare @indexType nvarchar(55) 
declare @percentFragment decimal(11,2) 
 
declare FragmentedTableList cursor for 
 SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName, 
   ind.name AS IndexName, indexstats.index_type_desc AS IndexType, 
   indexstats.avg_fragmentation_in_percent 
 FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
   INNER JOIN sys.indexes ind ON ind.object_id = indexstats.object_id 
        AND ind.index_id = indexstats.index_id 
  WHERE 
   indexstats.avg_fragmentation_in_percent > 5 
  AND ind.Name is not null 
  ORDER BY indexstats.avg_fragmentation_in_percent DESC 
 
    OPEN FragmentedTableList 
    FETCH NEXT FROM FragmentedTableList  
    INTO @tableName, @indexName, @indexType, @percentFragment 
 
    WHILE @@FETCH_STATUS = 0 
    BEGIN 
      print 'Processando ' + @indexName + ' da tabela ' + @tableName + ' no qual é ' + cast(@percentFragment as nvarchar(50)) + ' fragmentado' 
       
      if(@percentFragment >= 30) 
      BEGIN 
            EXEC( 'ALTER INDEX ' +  @indexName + ' ON ' + @tableName + ' REBUILD; ') 
       print 'Finalizado a  Rebuild' + @indexName + ' da tabela ' + @tableName 
      END 
      ELSE if(@percentFragment < 30)
      BEGIN 
         EXEC( 'ALTER INDEX ' +  @indexName + ' ON ' + @tableName + ' REORGANIZE;') 
        print 'Finalizado Reorganize ' + @indexName + ' da tabela ' + @tableName 
      END
      else 
      BEGIN
        print 'Nada realizado ' + @indexName + ' da tabela ' + @tableName 
      END  
      FETCH NEXT FROM FragmentedTableList  
        INTO @tableName, @indexName, @indexType, @percentFragment 
    END 
    CLOSE FragmentedTableList 
    DEALLOCATE FragmentedTableList
