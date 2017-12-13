DECLARE
  V_OUTPUT_FILE UTL_FILE.FILE_TYPE;
  V_FILE_NAME   VARCHAR2(50);
BEGIN

  /*ͳһ�ļ�����*/
  V_FILE_NAME := 'ODSPV_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.txt';
  --DBMS_OUTPUT.put_line(V_OUTPUT_FILE);
  /*���ļ�*/
  V_OUTPUT_FILE := UTL_FILE.fopen('LOG_TEST', V_FILE_NAME, 'W');

  /*д��title*/
  UTL_FILE.PUT_LINE(V_OUTPUT_FILE,
                    'ID,VID,MID,V,T,HMSC,HMMD,HMPL,HMKW,HMCI,URL,QUERY,AGENT,IP,CREATEON,A,VER,P,ISPROCESSED');

  /*ѭ������ȡ��Ҫ����������*/
  FOR I IN (SELECT A.ID,
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
              FROM ODSHAPPIGO.ODS_PAGEVIEW A
             WHERE ROWNUM <= 100) LOOP
  
    /*����������д���ļ�*/
    UTL_FILE.PUT_LINE(V_OUTPUT_FILE,
                      I.ID || ',' || I.VID || ',' || I.MID || ',' || I.V || ',' || I.T || ',' ||
                      I.HMSC || ',' || I.HMMD || ',' || I.HMPL || ',' ||
                      I.HMKW || ',' || I.HMCI || ',' || I.URL || ',' ||
                      I.QUERY || ',' || I.AGENT || ',' || I.IP || ',' ||
                      I.CREATEON || ',' || I.A || ',' || I.VER || ',' || I.P || ',' ||
                      I.ISPROCESSED);
  END LOOP;

  /*�ر��ļ�*/
  UTL_FILE.FCLOSE(V_OUTPUT_FILE);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
