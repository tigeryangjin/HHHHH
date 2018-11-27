SELECT TO_NUMBER(yy.matnr) AS item_code,
       yy.pb00 AS cost_price,
       yy.zp01 AS sale_price,
       yy.datab AS report_date,
       yy.datbi AS valid_date,
       TO_NUMBER(TO_CHAR(SYSDATE, 'yyyymmdd')) AS create_date
  FROM (SELECT matnr, MAX(pricenum) AS maxpricenum
          FROM new_ztmm023 aa
         WHERE aa.datbi >= '20990101'
           AND aa.datab <= TO_CHAR(SYSDATE, 'yyyymmdd')
         GROUP BY matnr) xx,
       (SELECT DISTINCT matnr,
                        pb00,
                        zp01,
                        datab,
                        MAX(datbi) AS datbi,
                        pricenum
          FROM new_ztmm023 aa
         WHERE aa.datbi >= '20990101'
           AND aa.datab <= TO_CHAR(SYSDATE, 'yyyymmdd')
         GROUP BY aa.matnr, aa.pb00, zp01, datab, aa.pricenum) yy
 WHERE xx.matnr = yy.matnr
   AND xx.maxpricenum = yy.pricenum;

SELECT TO_NUMBER(yy.matnr) AS item_code,
       yy.pb00 AS cost_price,
       yy.zp01 AS sale_price,
       yy.datab AS report_date,
       yy.datbi AS valid_date,
       TO_NUMBER(TO_CHAR(SYSDATE, 'yyyymmdd')) AS create_date
  FROM (SELECT BB.matnr,
               BB.pb00,
               BB.zp01,
               BB.datab,
               BB.datbi,
               BB.pricenum,
               ROW_NUMBER() OVER(PARTITION BY BB.MATNR ORDER BY BB.pricenum DESC) RN
          FROM (SELECT matnr,
                       pb00,
                       zp01,
                       datab,
                       MAX(datbi) AS datbi,
                       pricenum
                  FROM new_ztmm023 aa
                 WHERE aa.datbi >= '20990101'
                   AND aa.datab <= TO_CHAR(SYSDATE, 'yyyymmdd')
                 GROUP BY aa.matnr, aa.pb00, zp01, datab, aa.pricenum) BB) YY
 WHERE YY.RN = 1;
