--ִ��UTL_FILE����Ȩ������DW_USER
grant execute on UTL_FILE to DW_USER;
--�ڷ������ϴ�������Ŀ¼ 
CREATE OR REPLACE DIRECTORY LOG_TEST AS '/home/yangjin/log/';
--Ŀ¼Ȩ����Ȩ���û�
GRANT READ,WRITE ON DIRECTORY LOG_TEST TO DW_USER;
GRANT READ,WRITE ON DIRECTORY LOG_TEST TO PUBLIC;

SELECT * FROM DBA_DIRECTORIES;

--������ͼ
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
