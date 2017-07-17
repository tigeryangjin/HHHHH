--1.

--2.--最近半年购买过美妆(30)、服装配饰(18)、日用(50)、母婴(54)的用户(物料大类)，与这次618订购过美妆的用户剔重  给到BP号
select distinct b.member_key
  from (select a.member_key, a.goods_common_key
          from fact_goods_sales a
         where a.posting_date_key between 20161218 and 20170615
           and a.sales_source_key = 20
           and a.order_state = 1) b,
       dim_good c
 where b.goods_common_key = c.item_code
   and c.matdl in (18, 30, 50, 54)
   and not exists
 (select 1
          from (select f.member_key
                  from (select e.member_key, e.goods_common_key
                          from fact_goods_sales e
                         where e.posting_date_key between 20170616 and
                               20170626
                           and e.sales_source_key = 20
                           and e.order_state = 1) f,
                       dim_good g
                 where f.goods_common_key = g.item_code
                   and g.matdl in (18, 30, 50, 54)) d
         where b.member_key = d.member_key)
 order by 1;


--3.  4-6月活跃用户 BP 访问频次  订购单数  订购金额
create table member_tmp3(member_key number(20));
select * from member_tmp3 for update;

--访问回应率：25113/90351
select 25113/90351 from dual;
select count(1) from member_tmp3;
SELECT COUNT(DISTINCT T.MEMBER_KEY)
  FROM FACT_PAGE_VIEW T
 WHERE T.VISIT_DATE_KEY BETWEEN 20170629 AND 20170630
   AND EXISTS
 (SELECT 1 FROM member_tmp3 S WHERE T.MEMBER_KEY = S.MEMBER_KEY);


--订购回应率
--866,423283.45
select 866/90351 from dual;
SELECT COUNT(B.MEMBER_KEY) MEMBER_COUNT, SUM(B.ORDER_AMOUNT) ORDER_AMOUNT
  FROM (SELECT A.MEMBER_KEY,
               COUNT(A.ORDER_OBJ_ID) ORDER_COUNT,
               SUM(A.ORDER_AMOUNT) ORDER_AMOUNT
          FROM (SELECT T.POSTING_DATE_KEY,
                       T.ORDER_OBJ_ID,
                       T.MEMBER_KEY,
                       T.ORDER_AMOUNT
                  FROM FACT_ORDER T
                 WHERE T.POSTING_DATE_KEY BETWEEN 20170629 AND 20170630 /*过账日期*/
                   AND T.SALES_SOURCE_KEY = 20 /*新媒体通路*/
                   AND T.ORDER_STATE = 1
                   AND EXISTS
                 (SELECT 1
                          FROM member_tmp3 C
                         WHERE T.MEMBER_KEY = C.MEMBER_KEY)) A
         GROUP BY A.MEMBER_KEY) B;

select d.member_key,
       d.visit_count,
       nvl(e.order_count, 0) order_count,
       nvl(e.order_amount, 0) order_amount
  from (select c.member_key, count(c.visit_date_key) visit_count
          from (select distinct b.member_key, b.visit_date_key
                  from fact_page_view b
                 where b.visit_date_key between 20170401 and 20170628) c
         group by c.member_key
				 having count(c.visit_date_key)>1) d,
       (select a.member_key,
               nvl(count(a.order_obj_id), 0) order_count,
               nvl(sum(a.order_amount), 0) order_amount
          from fact_order a
         where a.posting_date_key between 20170401 and 20170628
           and a.order_state = 1
         group by a.member_key) e
 where d.member_key = e.member_key(+)
 order by 2, 3, 4;
