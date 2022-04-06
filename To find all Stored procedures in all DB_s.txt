CREATE TABLE #x(db SYSNAME, s SYSNAME, p SYSNAME);

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'INSERT #x SELECT ''' + name + ''',s.name, p.name
  FROM ' + QUOTENAME(name) + '.sys.schemas AS s
  INNER JOIN ' + QUOTENAME(name) + '.sys.procedures AS p
  ON p.schema_id = s.schema_id;
' FROM sys.databases WHERE database_id > 4

EXEC sp_executesql @sql;

SELECT db,s,p FROM #x ORDER BY db,s,p;

DROP TABLE #x;