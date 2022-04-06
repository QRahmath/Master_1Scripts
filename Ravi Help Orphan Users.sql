CREATE TABLE #badUsers(
DBName VARCHAR(100),
name VARCHAR(1000)
)

DECLARE @DB_Name varchar(100) 
DECLARE @Command nvarchar(2000)

DECLARE database_cursor CURSOR FOR 

SELECT name 
FROM MASTER.sys.sysdatabases
--where name not in ('master','msdb','model','tempdb')

OPEN database_cursor

FETCH NEXT FROM database_cursor INTO @DB_Name

WHILE @@FETCH_STATUS = 0 
BEGIN 
 Select @Command = 'use [' + '' + @DB_Name + '' + ']
 select u.name from master..syslogins l right join 
    sysusers u on l.sid = u.sid 
    where l.sid is null and issqlrole <> 1 and isapprole <> 1   

and (u.name <> ''INFORMATION_SCHEMA''
and u.name <> ''guest''
   and u.name <> ''system_function_schema''
   and u.name <> ''NT AUTHORITY\Authenticated Users''
   and u.name <> ''dbo''
   and u.name <>''BROKER_USER''
	and u.name <> ''sys'')'


INSERT INTO #badUsers(name)

exec sp_executesql @Command

-- This is what RAvi Wrote ************
Update #badUsers
Set DBName  =  @DB_Name
Where DBName is null

-- This is what RAvi Wrote ************

     FETCH NEXT FROM database_cursor INTO @DB_Name 
END

CLOSE database_cursor 
DEALLOCATE database_cursor

select * from #badUsers

drop table #badUsers