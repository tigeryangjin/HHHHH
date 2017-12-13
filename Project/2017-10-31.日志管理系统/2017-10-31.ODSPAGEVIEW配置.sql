--执行UTL_FILE包的权限授予DW_USER
grant execute on UTL_FILE to DW_USER;
--在服务器上创建导出目录 
CREATE OR REPLACE DIRECTORY LOG_TEST AS '/home/yangjin/log/';
--目录权限授权给用户
GRANT READ,WRITE ON DIRECTORY LOG_TEST TO DW_USER;
GRANT READ,WRITE ON DIRECTORY LOG_TEST TO PUBLIC;

SELECT * FROM DBA_DIRECTORIES;

--创建视图
CREATE OR REPLACE VIEW ODS_PAGEVIEW_V AS
SELECT A.ID,
       A.VID,
       A.MID,
       A.V,
       A.T,
       A.HMSC,
       A.HMMD,
       A.HMPL,
       A.HMKW,
       A.HMCI,
       A.URL,
       A.QUERY,
       A.AGENT,
       A.IP,
       A.CREATEON,
       A.A,
       A.VER,
       A.P,
       A.ISPROCESSED
  FROM ODSHAPPIGO.ODS_PAGEVIEW A;
