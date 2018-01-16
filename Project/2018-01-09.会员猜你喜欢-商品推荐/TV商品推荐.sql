select *
  from (select c.ITEM_CODE, GOODS_NAME, GOOD_PRICE, zhi, ren
          from (select ITEM_CODE, sum(num1 * num2) zhi, count(1) ren
                  from (select *
                          from (select MEMBER_KEY,
                                       ITEM_CODE,
                                       MATXL,
                                       sum(PV_FREQ * 5 + FAV_FREQ * 3 +
                                           CAR_FREQ * 5 + ORDER_NET_QTY * 4) num1
                                  from OPER_MEMBER_LIKE_BASE
                                 where ITEM_CODE != 224889
                                   and MATXL not in
                                       (SELECT MATXL
                                          FROM DIM_GOOD@DW_DATALINK
                                         where ITEM_CODE = 224889)
                                 group by MEMBER_KEY, ITEM_CODE, MATXL) a
                          join (select MEMBER_KEY, num2
                                 from (select MEMBER_KEY,
                                              ITEM_CODE,
                                              MATXL,
                                              sum(PV_FREQ * 5 + FAV_FREQ * 3 +
                                                  CAR_FREQ * 5 +
                                                  ORDER_NET_QTY * 4) num2
                                         from OPER_MEMBER_LIKE_BASE
                                        where ITEM_CODE = 224889
                                        group by MEMBER_KEY, ITEM_CODE, MATXL)) b
                            on a.MEMBER_KEY = b.MEMBER_KEY)
                 group by ITEM_CODE) c
          join (SELECT ITEM_CODE, GOODS_NAME, GOOD_PRICE
                 FROM DIM_GOOD@DW_DATALINK
                where GOOD_PRICE > 100) cc
            on c.ITEM_CODE = cc.ITEM_CODE)
 where zhi > 1000
   and ren > 100
