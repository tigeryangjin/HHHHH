------ 每日会员状态
select count(distinct(MEMBER_KEY)),CLV_TYPE,visit_date_key from 
(select MEMBER_KEY,VISIT_DATE_KEY,REGISTER_RESOURCE,MEMBER_INSERT_DATE,CLV_TYPE from 
(select MEMBER_KEY,visit_date_key from  fact_page_view  a where a.visit_date_key between 20161201 and 20161215
group by  MEMBER_KEY,visit_date_key) a left join dim_member b on a.member_key=b.member_bp ) 
 where CLV_TYPE is not null

group by CLV_TYPE,visit_date_key


----每周会员黏性

select count(1),nums from (
select count(1) as nums,member_key  from( 
    select  member_key,visit_date_key from  fact_page_view de where 
  de.visit_date_key between  20161209 and 20161215 
   group by member_key,visit_date_key )   
   group by member_key)group by  nums;
   
----来的人数


select count(distinct(MEMBER_KEY)),REGISTER_RESOURCE,visit_date_key from 
(select MEMBER_KEY,VISIT_DATE_KEY,REGISTER_RESOURCE,MEMBER_INSERT_DATE from 
(select MEMBER_KEY,visit_date_key from  fact_page_view  a where a.visit_date_key between 20161201 and 20161215
group by  MEMBER_KEY,visit_date_key) a left join dim_member b on a.member_key=b.member_bp ) 
 where REGISTER_RESOURCE is not null

group by REGISTER_RESOURCE,visit_date_key


---订购人数 
select count(distinct(MEMBER_KEY)),REGISTER_RESOURCE,POSTING_DATE_KEY from 
(select MEMBER_KEY,POSTING_DATE_KEY,REGISTER_RESOURCE,MEMBER_INSERT_DATE from 
(select MEMBER_KEY,POSTING_DATE_KEY from    fact_goods_sales a  where  SALES_SOURCE_KEY=20
 and POSTING_DATE_KEY  between 20161201 and 20161215
and ORDER_STATE=1group by  MEMBER_KEY,POSTING_DATE_KEY) a left join dim_member b on a.MEMBER_KEY=b.member_bp ) 
 where REGISTER_RESOURCE is not null

group by REGISTER_RESOURCE,POSTING_DATE_KEY

---- 订购商品(直播商品)

select count(distinct(MEMBER_KEY)),REGISTER_RESOURCE,POSTING_DATE_KEY,sum(ORDER_AMOUNT),sum(nums) from 
(select MEMBER_KEY,POSTING_DATE_KEY,REGISTER_RESOURCE,MEMBER_INSERT_DATE,nums,ORDER_AMOUNT from 
(select sum(NUMS) as nums,sum(ORDER_AMOUNT) as ORDER_AMOUNT,MEMBER_KEY,POSTING_DATE_KEY from    fact_goods_sales a  where  SALES_SOURCE_KEY=20
 and POSTING_DATE_KEY  between 20161201 and 20161215 and (LIVE_STATE=1 or REPLAY_STATE=1)
and ORDER_STATE=1 group by  MEMBER_KEY,POSTING_DATE_KEY)
 a left join dim_member b on a.MEMBER_KEY=b.member_bp ) 
 where REGISTER_RESOURCE is not null

group by REGISTER_RESOURCE,POSTING_DATE_KEY


---- 订购商品(TV非播出商品)

select count(distinct(MEMBER_KEY)),REGISTER_RESOURCE,POSTING_DATE_KEY,sum(ORDER_AMOUNT),sum(nums) from 
(select MEMBER_KEY,POSTING_DATE_KEY,REGISTER_RESOURCE,MEMBER_INSERT_DATE,nums,ORDER_AMOUNT,GROUP_NAME from 
(select GOODS_COMMON_KEY,sum(NUMS) as nums,sum(ORDER_AMOUNT) as ORDER_AMOUNT,MEMBER_KEY,
POSTING_DATE_KEY from    fact_goods_sales a  where  SALES_SOURCE_KEY=20
 and POSTING_DATE_KEY  between 20161201 and 20161215 and LIVE_STATE=0 and REPLAY_STATE=0
and ORDER_STATE=1 group by  MEMBER_KEY,POSTING_DATE_KEY,GOODS_COMMON_KEY)
 a left join dim_member b on a.MEMBER_KEY=b.member_bp 
   left join dim_good  c  on a.GOODS_COMMON_KEY=c.item_code
 ) 
 where REGISTER_RESOURCE is not null and GROUP_NAME='TV提报组'
 group by REGISTER_RESOURCE,POSTING_DATE_KEY


select sum(ORDER_AMOUNT) from fact_ec_order where ADD_TIME=20161215 and ORDER_STATE>0


---- 订购商品(TV非播出商品)

select count(distinct(MEMBER_KEY)),REGISTER_RESOURCE,POSTING_DATE_KEY,sum(ORDER_AMOUNT),sum(nums) from 
(select MEMBER_KEY,POSTING_DATE_KEY,REGISTER_RESOURCE,MEMBER_INSERT_DATE,nums,ORDER_AMOUNT,GROUP_NAME from 
(select GOODS_COMMON_KEY,sum(NUMS) as nums,sum(ORDER_AMOUNT) as ORDER_AMOUNT,MEMBER_KEY,
POSTING_DATE_KEY from    fact_goods_sales a  where  SALES_SOURCE_KEY=20
 and POSTING_DATE_KEY  between 20161201 and 20161215 and LIVE_STATE=0 and REPLAY_STATE=0
and ORDER_STATE=1 group by  MEMBER_KEY,POSTING_DATE_KEY,GOODS_COMMON_KEY)
 a left join dim_member b on a.MEMBER_KEY=b.member_bp 
   left join dim_good  c  on a.GOODS_COMMON_KEY=c.item_code
 ) 
 where REGISTER_RESOURCE is not null and GROUP_NAME!='TV提报组'
 

group by REGISTER_RESOURCE,POSTING_DATE_KEY


--- 各个品类商品订购
select count(distinct(MEMBER_KEY)),REGISTER_RESOURCE,POSTING_DATE_KEY,sum(ORDER_AMOUNT),sum(nums),MATDLT from 
(select MEMBER_KEY,POSTING_DATE_KEY,REGISTER_RESOURCE,MEMBER_INSERT_DATE,nums,ORDER_AMOUNT,GROUP_NAME,MATDLT from 
(select GOODS_COMMON_KEY,sum(NUMS) as nums,sum(ORDER_AMOUNT) as ORDER_AMOUNT,MEMBER_KEY,
POSTING_DATE_KEY from    fact_goods_sales a  where  SALES_SOURCE_KEY=20
 and POSTING_DATE_KEY  between 20161201 and 20161215  and TRAN_TYPE=0
and ORDER_STATE=1 group by  MEMBER_KEY,POSTING_DATE_KEY,GOODS_COMMON_KEY)
 a left join dim_member b on a.MEMBER_KEY=b.member_bp 
   left join dim_good  c  on a.GOODS_COMMON_KEY=c.item_code
 ) 
 where REGISTER_RESOURCE is not null 
 

group by REGISTER_RESOURCE,POSTING_DATE_KEY,MATDLT


select * from   fact_goods_sales
