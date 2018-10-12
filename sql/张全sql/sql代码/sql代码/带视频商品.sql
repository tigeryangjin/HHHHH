select * from 
(select PAGE_VALUE,VISIT_DATE_KEY,count(1),count(distinct(vid)) from fact_page_view where  
VISIT_DATE_KEY between 20170201 and 20170331
and page_name='Good'  
and page_value in(
select to_char(GOODS_COMMONID) from dim_ec_good
where ITEM_CODE in  (185186,196647,207504,192197,207690,201932,211623,200081,194018,195899))
group by PAGE_VALUE,VISIT_DATE_KEY) s
left join 
(select PAGE_VALUE,VISIT_DATE_KEY,count(1),count(distinct(vid)) from fact_page_view where  VISIT_DATE_KEY between 20170201 and 20170331
and page_name='Good_videoplay' and page_value in(
select GOODS_COMMONID from dim_ec_good
where ITEM_CODE in  (185186,196647,207504,192197,207690,201932,211623,200081,194018,195899))
group by PAGE_VALUE,VISIT_DATE_KEY) ss
 on s.PAGE_VALUE=ss.PAGE_VALUE and s.VISIT_DATE_KEY=ss.VISIT_DATE_KEY
 
 
left join 
select * from 

--on   s.PAGE_VALUE=sss.GOODS_COMMONID

(select GOODS_COMMON_KEY,ORDER_DATE_KEY,count(distinct(MEMBER_KEY)),sum(NUMS),sum(BARGAIN_PRICE) from fact_goods_sales where GOODS_COMMON_KEY
 in  (185186,196647,207504,192197,207690,201932,211623,200081,194018,195899)
and ORDER_DATE_KEY between 20170201 and 20170331
and SALES_SOURCE_KEY=20
group by GOODS_COMMON_KEY,ORDER_DATE_KEY)ssss 
left join  (select GOODS_COMMONID,GOODS_NAME,ITEM_CODE from  dim_ec_good where
ITEM_CODE
 in  (185186,196647,207504,192197,207690,201932,211623,200081,194018,195899)
)sss 
on  sss.ITEM_CODE=ssss.GOODS_COMMON_KEY

