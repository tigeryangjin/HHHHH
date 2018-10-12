--1.查询日志信息
select * from v$log;
select * from v$logfile;

--2.新增重做日志文件
alter database add logfile thread 1 group 4 ('/data/u01/oradata/bihappigo/redo04.log') size 256M; 
alter database add logfile thread 1 group 5 ('/data/u01/oradata/bihappigo/redo05.log') size 256M; 
alter database add logfile thread 1 group 6 ('/data/u01/oradata/bihappigo/redo06.log') size 256M; 
alter database add logfile thread 1 group 7 ('/data/u01/oradata/bihappigo/redo07.log') size 256M;

--3.删除状态为INACTIVE的日志文件
alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;

--4.删除物理文件

--5.重建日志
alter database add logfile thread 1 group 1 ('/data/u01/oradata/bihappigo/redo01.log') size 256M; 
alter database add logfile thread 1 group 2 ('/data/u01/oradata/bihappigo/redo02.log') size 256M; 
alter database add logfile thread 1 group 3 ('/data/u01/oradata/bihappigo/redo03.log') size 256M;
