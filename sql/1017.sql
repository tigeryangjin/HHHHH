MERGE /*+APPEND*/
INTO (SELECT ROW_ID,
             MEMBER_KEY,
             M_LABEL_ID,
             M_LABEL_TYPE_ID,
             CREATE_DATE,
             CREATE_USER_ID,
             LAST_UPDATE_DATE,
             LAST_UPDATE_USER_ID
        FROM MEMBER_LABEL_LINK
       WHERE M_LABEL_ID BETWEEN 202 AND 207) T
USING (SELECT MEMBER_LABEL_LINK_SEQ.NEXTVAL ROW_ID,
              G.MEMBER_KEY,
              H.M_LABEL_ID,
              H.M_LABEL_TYPE_ID,
              SYSDATE CREATE_DATE,
              'yangjin' CREATE_USER_ID,
              SYSDATE LAST_UPDATE_DATE,
              'yangjin' LAST_UPDATE_USER_ID
         FROM (SELECT F.MEMBER_KEY,
                      F.CREATE_DATE_KEY,
                      F.MAX_VISIT_DATE_KEY,
                      F.LESS_30_DAYS_ACTIVE,
                      F.MORE_30_DAYS_ACTIVE,
                      CASE
                        WHEN F.CREATE_DATE_KEY >=
                             TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD') THEN
                         'REGISTERED_LESS_ONE_MONTH'
                        WHEN F.CREATE_DATE_KEY <
                             TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD') AND
                             F.LESS_30_DAYS_ACTIVE >= 15 THEN
                         'EVERYDAY_SEE'
                        WHEN F.CREATE_DATE_KEY <
                             TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD') AND
                             F.LESS_30_DAYS_ACTIVE >= 4 THEN
                         'OCCASIONALLY_SEE'
                        WHEN F.CREATE_DATE_KEY <
                             TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD') AND
                             F.LESS_30_DAYS_ACTIVE > 0 THEN
                         'ACTIVE'
                        WHEN F.CREATE_DATE_KEY <
                             TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD') AND
                             F.MORE_30_DAYS_ACTIVE > 0 THEN
                         'MAYBE_LOSS'
                        ELSE
                         'DEEP_LOSS'
                      END MEMBER_LABEL_NAME
                 FROM (SELECT C.MEMBER_KEY,
                              D.CREATE_DATE_KEY,
                              C.MAX_VISIT_DATE_KEY,
                              C.LESS_30_DAYS_ACTIVE,
                              C.MORE_30_DAYS_ACTIVE
                         FROM (SELECT B.MEMBER_KEY,
                                      MAX(B.VISIT_DATE_KEY) MAX_VISIT_DATE_KEY,
                                      SUM(CASE
                                            WHEN B.VISIT_DATE_KEY >=
                                                 TO_CHAR(TRUNC(SYSDATE - 30),
                                                         'YYYYMMDD') THEN
                                             1
                                            ELSE
                                             0
                                          END) LESS_30_DAYS_ACTIVE,
                                      SUM(CASE
                                            WHEN B.VISIT_DATE_KEY <
                                                 TO_CHAR(TRUNC(SYSDATE - 30),
                                                         'YYYYMMDD') AND
                                                 B.VISIT_DATE_KEY >=
                                                 TO_CHAR(TRUNC(SYSDATE - 60),
                                                         'YYYYMMDD') THEN
                                             1
                                            ELSE
                                             0
                                          END) MORE_30_DAYS_ACTIVE
                                 FROM (SELECT DISTINCT A.VISIT_DATE_KEY,
                                                       A.MEMBER_KEY,
                                                       1 CNT
                                         FROM FACT_PAGE_VIEW A
                                        WHERE A.VISIT_DATE_KEY >=
                                              TO_CHAR(TRUNC(SYSDATE - 65),
                                                      'YYYYMMDD')
                                          AND A.MEMBER_KEY <> 0) B
                                GROUP BY B.MEMBER_KEY) C,
                              (SELECT E.MEMBER_BP MEMBER_KEY, E.CREATE_DATE_KEY
                                 FROM DIM_MEMBER E) D
                        WHERE C.MEMBER_KEY = D.MEMBER_KEY) F) G,
              MEMBER_LABEL_HEAD H
        WHERE G.MEMBER_LABEL_NAME = H.M_LABEL_NAME) S
ON (T.MEMBER_KEY = S.MEMBER_KEY)
WHEN MATCHED THEN
  UPDATE SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
  INSERT
    (T.ROW_ID,
     T.MEMBER_KEY,
     T.M_LABEL_ID,
     T.M_LABEL_TYPE_ID,
     T.CREATE_DATE,
     T.CREATE_USER_ID,
     T.LAST_UPDATE_DATE,
     T.LAST_UPDATE_USER_ID)
  VALUES
    (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
     S.MEMBER_KEY,
     S.M_LABEL_ID,
     1,
     SYSDATE,
     'yangjin',
     SYSDATE,
     'yangjin');
