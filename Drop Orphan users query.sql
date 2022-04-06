Create table #temptable (
 Formula varchar(500))

insert into #temptable (
 Formula)

exec sp_MSforeachdb '
use [?] if ''?'' 

not like ''%xyz%''


select ''use [?] '' +  ''
go'' + ''
drop user ['' + sdp.name + ''] '' from sys.database_principals sdp 
left join sys.server_principals ssp on sdp.sid = ssp.sid
where ssp.sid is null and sdp.type in (''S'',''U'',''G'')
and sdp.name not in (''guest'', ''INFORMATION_SCHEMA'', ''sys'',''NT AUTHORITY\Authenticated Users'',
''system_function_schema'', ''BROKER_USER'', ''dbo'')'


 select * from #temptable
 drop table #temptable