--�[�� modified_extent_page_count
backup database northwind to disk='nul'

select * from sys.dm_db_file_space_usage
go

--select into ��S�w FG
ALTER DATABASE Northwind ADD FILEGROUP FG2;
ALTER DATABASE Northwind
ADD FILE
(
NAME='FG2_Data',
FILENAME = 'C:\temp\nwind_Data1.ndf'
)
TO FILEGROUP FG2;
GO
SELECT * INTO t ON FG2 from customers
go

use tempdb
create table t(c1 int primary key,c2 nvarchar(10))
go
--MAXERRORS �w�]�O 10
BULK INSERT t FROM 'C:\temp\test.csv'
/*
Msg 4861, Level 16, State 1, Line 24
�L�k�j�q���J�A�]���ɮ� "C:\temp\bulkinsertError.log" �L�k�}�ҡC�@�~�t�ο��~�X 80(�ɮצs�b�C)�C
Msg 4861, Level 16, State 1, Line 24
�L�k�j�q���J�A�]���ɮ� "C:\temp\bulkinsertError.log.Error.Txt" �L�k�}�ҡC�@�~�t�ο��~�X 80(�ɮצs�b�C)�C
*/
WITH (FORMAT = 'CSV',ERRORFILE='C:\temp\bulkinsertError.log'  --�Y�]�w�F errorfile �h�L�k�g�J�|�ɭP���
--,MAXERRORS=0
); 
go
select * from t
truncate table t
