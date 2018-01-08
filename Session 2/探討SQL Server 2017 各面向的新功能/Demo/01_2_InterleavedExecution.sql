USE [WideWorldImportersDW]
GO

alter function dbo.OrderByKey(@OrderKey int)
RETURNS @retOrderss TABLE 
(
	[Order Key] [bigint], 
	[Customer Key] [int],
	[WWI Backorder ID] [int] ,
	[Description] [nvarchar](100) ,
	[Package] [nvarchar](50) ,
	[Quantity] [int] ,
	[Unit Price] [decimal](18, 2),
	[Tax Rate] [decimal](18, 3) ,
	[Total Excluding Tax] [decimal](18, 2) ,
	[Tax Amount] [decimal](18, 2) ,
	[Total Including Tax] [decimal](18, 2) ,
	[Lineage Key] [int]
)
AS
BEGIN
   INSERT @retOrderss
   SELECT  [Order Key],[Customer Key],[WWI Backorder ID],
	[Description],[Package],[Quantity],
	[Unit Price],[Tax Rate],[Total Excluding Tax],
	[Tax Amount] [decimal],[Total Including Tax],
	[Lineage Key]
   from Fact.[Order] where [Order Key]>@OrderKey
   INSERT @retOrderss
   SELECT  [Order Key],[Customer Key],[WWI Backorder ID],
	[Description],[Package],[Quantity],
	[Unit Price],[Tax Rate],[Total Excluding Tax],
	[Tax Amount] [decimal],[Total Including Tax],
	[Lineage Key]
   from Fact.[Order] where [Order Key]>@OrderKey
   RETURN
END
GO

--�z�L�Y�ɬd�߲έp����[��A�ѩ�w���h���ƪ�Ȩ�ƪ��^�Ǭ����O 100
--�]���PŪ���n�w�]�ᤩ���O����A�H�Ψϥ� nestloop join
ALTER DATABASE [WideWorldImportersDW] SET COMPATIBILITY_LEVEL = 130
go
select c.Customer,sum(o.Quantity) from dbo.OrderByKey(1) o join 
[Dimension].[Customer] c on o.[Customer Key]=c.[Customer Key]
group by c.Customer
go

--�z�L Interleaved Execution�A���D��Ʀ^�Ǫ����ƫ᭫�s��M����p�e
--�i�H���T�a�ϥ� Merge Join �H�ΰt�m�O����
ALTER DATABASE [WideWorldImportersDW] SET COMPATIBILITY_LEVEL = 140

select c.Customer,sum(o.Quantity) from dbo.OrderByKey(1) o join 
[Dimension].[Customer] c on o.[Customer Key]=c.[Customer Key]
group by c.Customer

