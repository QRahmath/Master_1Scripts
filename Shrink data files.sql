DECLARE @FileSize bigint,
@LogicalFile nvarchar(50),
@TargetFileSize bigint,
@NewFileSize nvarchar(50),
@IncrementSize bigint,
@databasename VARCHAR(1000),
@sqlcmd varchar (1000),
@exec_stmt varchar(1000)

DECLARE db_cursor CURSOR FOR

SELECT [DatabaseName],
	[Logical File Name],
      [TargetFileSize ],
      [Increment Size]
  FROM [master].[dbo].[Shrink data Files]

  OPEN db_cursor
FETCH NEXT FROM db_cursor
INTO @databasename,@LogicalFile,@TargetFileSize,@IncrementSize

WHILE @@FETCH_STATUS = 0
begin

set @FileSize = (select [Actual Used file Size] from [master].[dbo].[Shrink data Files] where [Logical File Name] = @LogicalFile)

SET @FileSize = (SELECT [Size]/128 FROM dbo.Sysfiles WHERE [name] = @LogicalFile)


set @exec_stmt = (' USE ' + quotename(@databasename, N'[') +   N' DBCC SHRINKFILE ' + '(N' + '''' + @LogicalFile +'''' + ', ' + @NewFileSize + ') ')  


SET @NewFileSize = @FileSize - @IncrementSize


while @FileSize > @TargetFileSize

begin

BEGIN

SEt @exec_stmt = (' USE ' + quotename(@databasename, N'[') +   N'DBCC SHRINKFILE ' + '(N' + '''' + @LogicalFile +'''' + ', ' + @NewFileSize + ') ')            
 print @exec_stmt
END
end
end

SET @FileSize = (SELECT [Size]/128 FROM dbo.Sysfiles WHERE [name] = @LogicalFile)
   
SET @NewFileSize = @FileSize - @IncrementSize

END

FETCH NEXT FROM db_cursor
INTO @databasename,@LogicalFile,@TargetFileSize,@IncrementSize
print @exec_stmt

END
GO

CLOSE db_cursor

DEALLOCATE db_cursor


