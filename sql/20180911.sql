select * from fact_weekly_market;

SELECT (SELECT MAX(ID) FROM FACT_PAGE_VIEW) - (SELECT ID FROM W_ACTIVE_NUM)
  FROM DUAL;

SELECT NVL(CASE
             WHEN D1.APPLICATION_KEY IN (10, 20) THEN
              (SELECT X.HMMD FROM DIM_HMSC X WHERE X.HMSC = D1.HMSC)
             ELSE
              NVL((SELECT DISTINCT D3.LEVEL1
                    FROM DIM_PROMOTION D3
                   WHERE D3.KEYWORD = CASE
                         /*&*/
                           WHEN REGEXP_INSTR(D1.URL, '&') > 0 AND
                                GET_STR_COUNT(NVL(SUBSTR(D1.URL,
                                                         1,
                                                         INSTR(D1.URL, '&')),
                                                  'unkown')) < 2 THEN
                            REGEXP_SUBSTR(REGEXP_SUBSTR(D1.URL, '[^?]+', 1, 2),
                                          '[^&]+',
                                          1,
                                          1)
                           WHEN REGEXP_INSTR(D1.URL, ';') > 0 AND
                                GET_STR_COUNT(NVL(SUBSTR(D1.URL,
                                                         1,
                                                         INSTR(D1.URL, ';')),
                                                  'unkown')) < 2 THEN
                            REGEXP_SUBSTR(REGEXP_SUBSTR(D1.URL, '[^?]+', 1, 2),
                                          '[^;]+',
                                          1,
                                          1)
                         /*&*/
                           WHEN REGEXP_INSTR(D1.URL, '&') > 0 AND
                                GET_STR_COUNT(NVL(SUBSTR(D1.URL,
                                                         1,
                                                         INSTR(D1.URL, '&')),
                                                  'unkown')) >= 2 THEN
                            REGEXP_SUBSTR(REGEXP_SUBSTR(D1.URL, '[^?]+', 2, 3),
                                          '[^&]+',
                                          1,
                                          1)
                           WHEN REGEXP_INSTR(D1.URL, ';') > 0 AND
                                GET_STR_COUNT(NVL(SUBSTR(D1.URL,
                                                         1,
                                                         INSTR(D1.URL, ';')),
                                                  'unkown')) >= 2 THEN
                            REGEXP_SUBSTR(REGEXP_SUBSTR(D1.URL, '[^?]+', 2, 3),
                                          '[^;]+',
                                          1,
                                          1)
                           ELSE
                            REGEXP_SUBSTR(REGEXP_SUBSTR(D1.URL, '[^?]+', 1, 2),
                                          '[^&]+',
                                          1,
                                          1)
                         END),
                  'unknown')
           END,
           'unknown') AS LEVEL1,
       /*LEVEL2*/
       NVL(CASE
             WHEN D1.APPLICATION_KEY IN (10, 20) THEN
              (SELECT X.HMMD FROM DIM_HMSC X WHERE X.HMSC = D1.HMSC)
             ELSE
              NVL((SELECT DISTINCT D3.LEVEL1
                    FROM DIM_PROMOTION D3
                   WHERE D3.KEYWORD = CASE
                           WHEN REGEXP_INSTR(D1.URL, '&') > 0 THEN
                            CASE
                              WHEN GET_STR_COUNT(NVL(SUBSTR(D1.URL,
                                                            1,
                                                            INSTR(D1.URL, '&')),
                                                     'unkown')) < 2 THEN
                               REGEXP_SUBSTR(REGEXP_SUBSTR(D1.URL, '[^?]+', 1, 2),
                                             '[^&]+',
                                             1,
                                             1)
                              ELSE
                               REGEXP_SUBSTR(REGEXP_SUBSTR(D1.URL, '[^?]+', 2, 3),
                                             '[^&]+',
                                             1,
                                             1)
                            END
                           WHEN REGEXP_INSTR(D1.URL, ';') > 0 THEN
                            CASE
                              WHEN GET_STR_COUNT(NVL(SUBSTR(D1.URL,
                                                            1,
                                                            INSTR(D1.URL, ';')),
                                                     'unkown')) < 2 THEN
                               REGEXP_SUBSTR(REGEXP_SUBSTR(D1.URL, '[^?]+', 1, 2),
                                             '[^;]+',
                                             1,
                                             1)
                              ELSE
                               REGEXP_SUBSTR(REGEXP_SUBSTR(D1.URL, '[^?]+', 2, 3),
                                             '[^;]+',
                                             1,
                                             1)
                            END
                           ELSE
                            REGEXP_SUBSTR(REGEXP_SUBSTR(D1.URL, '[^?]+', 1, 2),
                                          '[^&]+',
                                          1,
                                          1)
                         END),
                  'unknown')
           END,
           'unknown') AS LEVEL2
  FROM FACT_PAGE_VIEW D1
 WHERE D1.VISIT_DATE_KEY = 20180911;
