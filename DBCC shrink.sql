use CUSTOMER367
declare @exec_stmt varchar (500),
@databasename varchar (500),
 @LogicalFile varchar (500),
 @NewFileSize  nvarchar(50)


 set @databasename = 'customer367'
 set @LogicalFile ='customer367'

 SET @NewFileSize = (SELECT [Size]/128 FROM dbo.Sysfiles WHERE [name] = @LogicalFile)?- 1

set @exec_stmt = (' USE ' + quotename(@databasename, N'[') + ??N' DBCC SHRINKFILE ' + '(N' + '''' + @LogicalFile +'''' + ', ' + @NewFileSize + ') ') ????
exec (@exec_stmt)
go 2




use CUSTOMER367
declare
 @LogicalFile varchar (500),
 @NewFileSize  nvarchar(50)
  set @LogicalFile ='customer367'
   SET @NewFileSize = (SELECT [Size]/128 FROM dbo.Sysfiles WHERE [name] = @LogicalFile)?- 1

??exec ('DBCC SHRINKFILE ' + '(N' + '''' + @LogicalFile +'''' + ', ' + @NewFileSize + ')')
go 2



