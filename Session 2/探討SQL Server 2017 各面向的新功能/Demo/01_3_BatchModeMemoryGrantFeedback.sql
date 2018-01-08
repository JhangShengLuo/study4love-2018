use WideWorldImportersDW
go
create proc FactOrderByLineageKey @LineageKey int
as
	select fo.[Order Key],fo.Description
	from fact.[Order] as fo
	inner hash join Dimension.[Stock Item] as si
	on fo.[Stock Item Key]=si.[Stock Item Key]
	where fo.[Lineage Key]=@LineageKey
	and si.[Lead Time Days]>0
	order by fo.[Stock Item Key], fo.[Order Date Key] desc
go
--�i�H��ө����洫����A�Ĥ@���|������~�A�ĤG���N�|���T
--�z�L��������p�e�A��ĵ�i�T���A�|���ϥ� tempdb ���X(spill)��ơA�ݾ�y Select �y�k�A�i�H�ݨ쵹���O���骺�q
exec FactOrderByLineageKey 8  --�ŦX�������� 0 ��

exec FactOrderByLineageKey 9  --�ŦX�������� 23 �U
