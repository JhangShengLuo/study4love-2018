--ALTER DATABASE [WideWorldImportersDW] SET COMPATIBILITY_LEVEL = 130
--ALTER DATABASE [WideWorldImportersDW] SET COMPATIBILITY_LEVEL = 140
--�z�L�]�t�Y�ɬd�߲έp��Ƨe�{�������p�e�A�i�H��� SQL Server 2016 �M 2017 ��Ӫ����C2017 �~���۾A���p��
use [WideWorldImportersDW]
go
SELECT  [fo].[Order Key], [si].[Lead Time Days],
[fo].[Quantity]
FROM    [Fact].[Order] AS [fo]
INNER JOIN [Dimension].[Stock Item] AS [si]
       ON [fo].[Stock Item Key] = [si].[Stock Item Key]
WHERE   [fo].[Quantity] = 360;
go

SELECT  [fo].[Order Key], [si].[Lead Time Days],
[fo].[Quantity]
FROM    [Fact].[Order] AS [fo]
INNER JOIN [Dimension].[Stock Item] AS [si]
       ON [fo].[Stock Item Key] = [si].[Stock Item Key]
WHERE   [fo].[Quantity] = 361;

/*
select quantity,count(*) from  [Fact].[Order]
group by quantity
order by 2
update Fact.[Order] set quantity=361 where [Order key]=702
*/
