use master
go

--�]�wSQL Server�i�H�Ұʰ���.NET �Ҽ��g������
--�w�]���ҰʡA�A�i�H���U����A���L�k����
exec sp_configure 'show advanced options',1
reconfigure
exec sp_configure 'clr enabled',1
reconfigure
--�w�]�O�Ұʪ�
exec sp_configure 'clr strict security'

--���vñ���L�A���j���W�٪��ե�i�H external access�Bunsafe ���覡����A�ȥ��b context db=master
CREATE ASYMMETRIC KEY SQLCLRTestKey FROM EXECUTABLE FILE = 'C:\SQL2017\Demo\SQLCLRDemo\bin\Debug\SQLCLRDemo.dll'   
CREATE LOGIN SQLCLRTestLogin FROM ASYMMETRIC KEY SQLCLRTestKey   
GRANT UNSAFE ASSEMBLY TO SQLCLRTestLogin; -- EXTERNAL ACCESS
go

use Northwind

--�N Assembly �[�J�� SQL Server
--�٬O�ݭn�]�w permission_set
CREATE ASSEMBLY SQLCLRDemo FROM 'C:\SQL2017\Demo\SQLCLRDemo\bin\Debug\SQLCLRDemo.dll' 
WITH PERMISSION_SET=unsafe
GO

--�إߤ@�ӦW�� RetrieveRSS ���w�s�{��
CREATE FUNCTION [dbo].[EventLog]
(@logname NVARCHAR (MAX) NULL)
RETURNS 
     TABLE (
        [timeWritten] DATETIME        NULL,
        [message]     NVARCHAR (MAX) NULL,
        [category]    NVARCHAR (256)  NULL,
        [instanceID]  BIGINT          NULL)
AS
 EXTERNAL NAME SQLCLRDemo.[UserDefinedFunctions].[InitMethod]
GO

select�@top(10)  * from [dbo].EventLog(N'Application')
go
--���Ӹ�Ʈw�� .NET ����i�H�s�� SQL Server ���~���귽
--ALTER DATABASE db SET TRUSTWORTHY ON
drop function dbo.EventLog
drop assembly SQLCLRDemo
go
use master
go
drop login SQLCLRTestLogin
drop asymmetric key SQLCLRTestKey

