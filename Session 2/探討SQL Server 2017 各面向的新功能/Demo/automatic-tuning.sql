use northwind
go
drop table if exists flgp; 
create table flgp (
       type int,
       name nvarchar(200),
       index ncci nonclustered columnstore (type),
       index ix_type(type)
);
insert into flgp(type, name)
values (1, 'Single');
go
insert into flgp(type, name) select TOP 999999 2 as type, o.name
from sys.objects, sys.all_columns o;
go

select * from sys.dm_exec_cached_plans
--�M���򥻸�Ʈw�������֨�
ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE; 
go
--�n���լݨ� Hash aggregate�A�Y�O Stream Aggreage �N�A�[����
--�N��ڤ�� CPU �Ӯɪ��p�A�o���G���|����n...�ҥH�o�� Demo �|����...
EXECUTE sp_executesql @stmt = N'SELECT COUNT(*) FROM flgp WHERE type = @type', @params = N'@type int', @type = 2
GO 30

ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE; 
go
EXECUTE sp_executesql @stmt = N'SELECT COUNT(*) FROM flgp WHERE type = @type', @params = N'@type int', @type = 1
go

EXECUTE sp_executesql @stmt = N'SELECT COUNT(*) FROM flgp WHERE type = @type', @params = N'@type int', @type = 2
GO 15

SELECT reason, score,
 script = JSON_VALUE(details, '$.implementationDetails.script'),
 planForceDetails.[query_id],
 planForceDetails.[new plan_id],
 planForceDetails.[recommended plan_id],
 estimated_gain = (regressedPlanExecutionCount+recommendedPlanExecutionCount)*(regressedPlanCpuTimeAverage-recommendedPlanCpuTimeAverage)/1000000,
 error_prone = IIF(regressedPlanErrorCount>recommendedPlanErrorCount, 'YES','NO')
 FROM sys.dm_db_tuning_recommendations
     CROSS APPLY OPENJSON (Details, '$.planForceDetails')
                 WITH ( [query_id] int '$.queryId',
                        [new plan_id] int '$.regressedPlanId',
                        [recommended plan_id] int '$.recommendedPlanId',
                        regressedPlanErrorCount int,
                        recommendedPlanErrorCount int,
                        regressedPlanExecutionCount int,
                        regressedPlanCpuTimeAverage float,
                        recommendedPlanExecutionCount int,
                        recommendedPlanCpuTimeAverage float ) as planForceDetails;

ALTER DATABASE current
      SET AUTOMATIC_TUNING ( FORCE_LAST_GOOD_PLAN = OFF ); 




