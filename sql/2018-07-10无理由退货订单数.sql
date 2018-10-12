--3到6月份的129元以上订单（含供应商发货及仓配）无理由产生的退货订单数量（20017，20020，20021，20023）
SELECT CASE
         WHEN D.IS_SHIPPING_SELF = 0 THEN
          '直配'
         WHEN D.IS_SHIPPING_SELF = 1 THEN
          '仓配'
       END SHIPPING,
       D.ORDER_COUNT
  FROM (SELECT C.IS_SHIPPING_SELF, COUNT(DISTINCT A.ORDER_KEY) ORDER_COUNT
          FROM FACT_GOODS_SALES A, DIM_EC_GOOD C
         WHERE A.GOODS_COMMON_KEY = C.ITEM_CODE
           AND A.POSTING_DATE_KEY BETWEEN 20180301 AND 20180630
           AND A.SALES_SOURCE_SECOND_KEY IN (20017, 20020, 20021, 20023)
           AND A.ORDER_STATE = 0
           AND EXISTS (SELECT 1
                  FROM FACT_GOODS_SALES_REVERSE B
                 WHERE A.ORDER_KEY = B.ORDER_KEY
                   AND B.ONE_REASON IN ('Y004',
                                        'Y008',
                                        'Y013',
                                        'Y018',
                                        'Y024',
                                        'Y033',
                                        'Y034',
                                        'Y040',
                                        'Y044',
                                        'Y045',
                                        'Y046',
                                        'Y048',
                                        'Y057',
                                        'Y064',
                                        'Y065',
                                        'Y066',
                                        'Y082'))
         GROUP BY C.IS_SHIPPING_SELF) D;

--tmp
SELECT * FROM DIM_EC_GOOD;
SELECT * FROM FACT_GOODS_SALES A WHERE A.POSTING_DATE_KEY = 20180709;
SELECT *
  FROM FACT_GOODS_SALES_REVERSE A
 WHERE A.POSTING_DATE_KEY = 20180709;

SELECT * FROM DIM_RE_RESEAON_1;
SELECT * FROM DIM_RE_RESEAON_2;

SELECT * FROM DIM_RE_RESEAON_2 A WHERE A.REASON_NM LIKE '%无理由%';

SELECT *
  FROM DIM_RE_RESEAON_1 A
 WHERE A.REASON_NM IN ('商品主观原因',
                       '商品主观原因(商品本身不存在任何质量问题',
                       '商品型号偏大/偏粗',
                       '型号选择失误',
                       '用户原因',
                       '商品材质不满',
                       '商品效果不满',
                       '顾客主观原因',
                       '顾客原因',
                       '顾客变心',
                       '商品颜色不满',
                       '商品型号偏小/偏细(',
                       '恶意订购');
