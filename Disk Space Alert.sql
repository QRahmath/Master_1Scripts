sp_configure 'show advanced options', 1
GO 
RECONFIGURE;
GO
sp_configure 'Ole Automation Procedures', 1
GO 
RECONFIGURE;
GO



SET NOCOUNT ON

DECLARE @hr int
DECLARE @fso int
DECLARE @drive char(1)
DECLARE @odrive int
DECLARE @TotalSize varchar(20)
DECLARE @MB bigint ; SET @MB = 1048576

CREATE TABLE #drives (
drive char(1) PRIMARY KEY,
FreeSpace int NULL,
TotalSize int NULL)

INSERT #drives(drive,FreeSpace) EXEC master.dbo.xp_fixeddrives

EXEC @hr=sp_OACreate 'Scripting.FileSystemObject',@fso OUT

IF @hr <> 0 EXEC sp_OAGetErrorInfo @fso

DECLARE dcur CURSOR LOCAL FAST_FORWARD
FOR SELECT drive from #drives
ORDER by drive

OPEN dcur
FETCH NEXT FROM dcur INTO @drive
WHILE @@FETCH_STATUS=0
BEGIN

EXEC @hr = sp_OAMethod @fso,'GetDrive', @odrive OUT, @drive

IF @hr <> 0 EXEC sp_OAGetErrorInfo @fso

EXEC @hr = sp_OAGetProperty @odrive,'TotalSize', @TotalSize OUT

IF @hr <> 0 EXEC sp_OAGetErrorInfo @odrive

UPDATE #drives
SET TotalSize=@TotalSize/@MB
WHERE drive=@drive

FETCH NEXT FROM dcur INTO @drive
END
CLOSE dcur
DEALLOCATE dcur

EXEC @hr=sp_OADestroy @fso

IF @hr <> 0 EXEC sp_OAGetErrorInfo @fso

SELECT drive,
FreeSpace as 'Free(MB)',
TotalSize as 'Total(MB)',
CAST((FreeSpace/(TotalSize*1.0))*100.0 as int) as 'Free(%)'
FROM #drives
ORDER BY drive

DROP TABLE #drives


GO
sp_configure 'Ole Automation Procedures', 0
GO 
RECONFIGURE;
GO
sp_configure 'show advanced options', 0
GO 
RECONFIGURE;
GO