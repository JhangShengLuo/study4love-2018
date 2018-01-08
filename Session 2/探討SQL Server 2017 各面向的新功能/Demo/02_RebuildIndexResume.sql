--���� Recovery Mode �O Simple�BBulk Load�BFull ���i�H
use Northwind
/*
create table tbBig(PK bigint identity primary key,
c1 nvarchar(100) default('Hello Index'),
CreateDate datetime2(3) default(sysdatetime()),
)
go
insert tbBig default values
go

--���ͤ@�d���ʸU������
insert tbBig(c1) select c1 from tbBig
go 24

insert tbBig(c1) values('hi')

create index idx on tbBig(c1)
go
*/
--�W�L�@���������~�T��
/*
�T�� 3643�A�h�� 16�A���A 1�A�� 21
�@�~���g�L�ɶ��w�W�L���w�����@�~���ɶ��W���C�Ӱ���w����C
���z���w�g�����C
�T�� 596�A�h�� 21�A���A 1�A�� 20
�u�@���q���M�����A�A�L�k�~�����C
�T�� 0�A�h�� 20�A���A 0�A�� 20
�b�ثe���R�O�W�o���Y�����~�C�p�G�����󵲪G�A�������˱�C
*/
ALTER INDEX idx ON tbBig 
REBUILD WITH (RESUMABLE = ON, ONLINE = ON, MAX_DURATION=1, maxdop=1);


-------------------------------------------------
--�b�t�@���s���W����A���_���ޫظm�A�|�屼��U
--���b���檺�o���s��
/*
�T�� 1219�A�h�� 16�A���A 1�A�� 18
�z���u�@���q�w�g�]�����u���v�� DDL �@�~�Ӥ��_�s�u�C
�T�� 1219�A�h�� 16�A���A 1�A�� 18
�z���u�@���q�w�g�]�����u���v�� DDL �@�~�Ӥ��_�s�u�C
�T�� 596�A�h�� 21�A���A 1�A�� 17
�u�@���q���M�����A�A�L�k�~�����C
�T�� 0�A�h�� 20�A���A 0�A�� 17
�b�ثe���R�O�W�o���Y�����~�C�p�G�����󵲪G�A�������˱�C
*/
ALTER INDEX idx ON tbBig PAUSE;

select * from sys.dm_db_log_stats(db_id('northwind'))

--�i�H�M���������
backup log northwind to disk='nul'

--���ޫؤ@�b�ɡA�ק��Ƥ��e�A����خɡA�ܧ�O�_�i�J
insert tbBig(c1) select top 100000 c1 from tbBig
insert tbBig(c1) values('New Data123')


 SELECT total_execution_time, percent_complete, page_count, *
	FROM  sys.index_resumable_operations;

select * from sysindexes where id= OBJECT_ID('tbBig')

--��������ި̵M�i�H�ΡA���@�b�����޷|���� data file ���Ŷ�
select * from tbBig where c1='hi'
--�¯��ޤ]�����s

select * from tbBig where c1='New Data123'

select max(pk) from tbBig


--�qlog_truncation_holdup_reason�l�׬O Nothing�A�ݰ_�Ӧ��G���v�T��������C
--���q active_log_size_mb �M active_vlf_count ������j�ݰ_�ӡA�B recovery mode �O simple�A���ݧ��������޷|�y���L�k����������
select log_truncation_holdup_reason,* from sys.dm_db_log_stats(db_id('Northwind'))


--����1������۰ʰ���
ALTER INDEX idx ON tbBig 
RESUME WITH (MAX_DURATION = 1 );

--���ޫؤ@�b�ɡA�ק��Ƥ��e�A����خɡA�ܧ�O�_�i�J...��M�n�i�� :)
select * from tbBig where c1='New Data123'

--���ؤ@�b������
ALTER INDEX idx ON tbBig 
abort;

