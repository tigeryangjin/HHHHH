--1.��ѯ��־��Ϣ
select * from v$log;
select * from v$logfile;

--2.����������־�ļ�
alter database add logfile thread 1 group 4 ('/data/u01/oradata/bihappigo/redo04.log') size 256M; 
alter database add logfile thread 1 group 5 ('/data/u01/oradata/bihappigo/redo05.log') size 256M; 
alter database add logfile thread 1 group 6 ('/data/u01/oradata/bihappigo/redo06.log') size 256M; 
alter database add logfile thread 1 group 7 ('/data/u01/oradata/bihappigo/redo07.log') size 256M;

--3.ɾ��״̬ΪINACTIVE����־�ļ�
alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;

--4.ɾ�������ļ�

--5.�ؽ���־
alter database add logfile thread 1 group 1 ('/data/u01/oradata/bihappigo/redo01.log') size 256M; 
alter database add logfile thread 1 group 2 ('/data/u01/oradata/bihappigo/redo02.log') size 256M; 
alter database add logfile thread 1 group 3 ('/data/u01/oradata/bihappigo/redo03.log') size 256M;
