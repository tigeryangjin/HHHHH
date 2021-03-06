--报表脚本
select v1.visit_date_key,
       v1.page_value,
       v1.item_code,
       v1.goods_name,
       v1.matdlt,
       v1.group_name,
       v1.pv,
       v1.uv,
       v1.avgnum,
       v2.goodpv,
       v2.gooduv,
       v2.goodavg,
       v3.goods_commonid,
       v3.goodnum,
       v3.custnum,
       v3.goodmount
  from (select x1.page_value,
               x1.visit_date_key,
               (select y1.item_code
                  from dim_good y1
                 where y1.item_code = get_itemcode(x1.page_value)
                   and rownum = 1) as item_code,
               (select y1.goods_name
                  from dim_good y1
                 where y1.item_code = get_itemcode(x1.page_value)
                   and rownum = 1) as goods_name,
               (select y1.matdlt
                  from dim_good y1
                 where y1.item_code = get_itemcode(x1.page_value)
                   and rownum = 1) as matdlt,
               (select y1.group_name
                  from dim_good y1
                 where y1.item_code = get_itemcode(x1.page_value)
                   and rownum = 1) as group_name,
               count(x1.vid) as pv,
               count(distinct x1.vid) as uv,
               trunc(avg(x1.page_staytime), 2) as avgnum
          from fact_page_view x1
         where visit_date_key = 20170618
           and page_key in (40899, 40903)
         group by x1.page_value, x1.visit_date_key) v1
  left join (select x2.page_value,
                    count(x2.vid) as goodpv,
                    count(distinct x2.vid) as gooduv,
                    trunc(avg(x2.page_staytime), 2) as goodavg
               from fact_page_view x2
              where x2.visit_date_key = 20170618
                and x2.page_key in (1924, 2841)
              group by x2.page_value) v2
    on v1.page_value = v2.page_value
  left join (select x3.goods_commonid,
                    sum(x3.goods_num) as goodnum,
                    count(distinct x3.cust_no) as custnum,
                    sum(x3.goods_pay_price * x3.goods_num) as goodmount
               from order_good x3
              where x3.add_time = 20170618
                and x3.iscg = 1
              group by x3.goods_commonid) v3
    on v2.page_value = v3.goods_commonid;

--重新刷新历史数据
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2017-06-01';
  END_DATE    DATE := DATE '2017-06-28';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    YANGJIN_PKG.OPER_PRODUCT_PVUV_DAILY_RPT(IN_DATE_INT);
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/
