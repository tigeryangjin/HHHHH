---a.商品转化率方向=>    调整前后的商品转化率是否有提升？
----调整前 商品转化率 //2617097	67283
select count(PAGE_VALUE),count(EC_GOODS_COMMON),visit_date_key from(
select VID,PAGE_VALUE,visit_date_key from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20171101 and 20180226
and page_name ='Good'
and page_value in  (select to_char(GOODS_COMMONID) from   dim_ec_good where STORE_ID=1  and IS_TV=1)
and APPLICATION_KEY in (10,20) 
   group by VID,PAGE_VALUE,visit_date_key 
) a left join (
select ADD_TIME,EC_GOODS_COMMON,VID from factec_order s  left join factec_order_goods ss on s.order_id=ss.order_id
) b on a.vid=b.vid and a.visit_date_key=b.ADD_TIME and a.PAGE_VALUE=to_char(b.EC_GOODS_COMMON)
group by visit_date_key;


---b.用户转化率方向=>   使用在线客服的用户的转化率是否达到预期？

----按时间展开
SELECT COUNT(VID1),COUNT(VID2) FROM (
select A.VID AS VID1,B.VID AS VID2,visit_date_key from(
select VID,PAGE_VALUE,visit_date_key from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20180101 and 20180226
and page_name ='SL_Good_Customer'   group by VID,PAGE_VALUE,visit_date_key 
) a left join (
select ADD_TIME,EC_GOODS_COMMON,VID from factec_order s  left join factec_order_goods ss on s.order_id=ss.order_id
) b on a.vid=b.vid and a.visit_date_key=b.ADD_TIME and a.PAGE_VALUE=to_char(b.EC_GOODS_COMMON)
) group by visit_date_key
;

---按类目展开
select sum(num1),sum(num2),MATDLT  from 
(
SELECT COUNT(VID1) num1,COUNT(VID2) num2,PAGE_VALUE FROM (
select A.VID AS VID1,B.VID AS VID2,PAGE_VALUE from(
select VID,PAGE_VALUE,visit_date_key from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20180101 and 20180226
and page_name ='SL_Good_Customer'   group by VID,PAGE_VALUE,visit_date_key 
) a left join (
select ADD_TIME,EC_GOODS_COMMON,VID from factec_order s  left join factec_order_goods ss on s.order_id=ss.order_id
) b on a.vid=b.vid and a.visit_date_key=b.ADD_TIME and a.PAGE_VALUE=to_char(b.EC_GOODS_COMMON)
) group by PAGE_VALUE) s1  left join dim_ec_good s2 on s1.PAGE_VALUE= s2.goods_commonid group by MATDLT;


---按商品展开
select sum(num1),sum(num2),Goods_name  from 
(
SELECT COUNT(VID1) num1,COUNT(VID2) num2,PAGE_VALUE FROM (
select A.VID AS VID1,B.VID AS VID2,PAGE_VALUE from(
select VID,PAGE_VALUE,visit_date_key from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20180101 and 20180226
and page_name ='SL_Good_Customer'   group by VID,PAGE_VALUE,visit_date_key 
) a left join (
select ADD_TIME,EC_GOODS_COMMON,VID from factec_order s  left join factec_order_goods ss on s.order_id=ss.order_id
) b on a.vid=b.vid and a.visit_date_key=b.ADD_TIME and a.PAGE_VALUE=to_char(b.EC_GOODS_COMMON)
) group by PAGE_VALUE) s1  left join dim_ec_good s2 on s1.PAGE_VALUE= s2.goods_commonid group by Goods_name;



---c.跳出分析=>        调整前后的用户跳出率是否有变化？ 

select count(PAGE_VALUE),count(EC_GOODS_COMMON) from(
select VID,PAGE_VALUE,visit_date_key from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20180101 and 20180130 
and page_name ='Good'
   group by VID,PAGE_VALUE,visit_date_key 
) a left join (
select ADD_TIME,EC_GOODS_COMMON,VID from factec_order s  left join factec_order_goods ss on s.order_id=ss.order_id
) b on a.vid=b.vid and a.visit_date_key=b.ADD_TIME and a.PAGE_VALUE=to_char(b.EC_GOODS_COMMON);





---d.用户习惯=>        使用在线客服的用户是否形成询问习惯？
---用户画像
select * from 
(
select  MEMBER_KEY,count(1),count(distinct visit_date_key)  from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20180101 and 20180226
and page_name ='SL_Good_Customer'    group by MEMBER_KEY
) a left join dim_member b  on a.MEMBER_KEY=b.member_bp
-----  用户喜好资讯什么商品 
select MATDLT,sum(num1),sum(num2) from 
(
select  PAGE_VALUE,count(1) num1,count(distinct MEMBER_KEY) num2  from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20180101 and 20180226
and page_name ='SL_Good_Customer'    group by PAGE_VALUE
) s1  left join dim_ec_good s2 on s1.PAGE_VALUE= s2.goods_commonid group by MATDLT

-----
select num2,count(1) from 
(
select  MEMBER_KEY,count(1) num1,count(distinct visit_date_key) num2  from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20180101 and 20180226
and page_name ='SL_Good_Customer'    group by MEMBER_KEY
) group by num2

----商品使用占比
select sum(num1),sum(num2),a1.visit_date_key1 from 
(
select page_value,count(distinct vid) num1,visit_date_key  as visit_date_key1 from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20180101 and 20180226
and page_name ='SL_Good_Customer'    group by page_value,visit_date_key
) a1 left join 
(
select page_value,count(distinct vid) num2,visit_date_key  from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20180101 and 20180226
and page_name ='Good'   and APPLICATION_KEY in (10,20)   group by page_value,visit_date_key
) a2 on a1.page_value=a2.page_value and a1.visit_date_key1=a2.visit_date_key
group by visit_date_key1


----商品页跳出率
 
select count(1),START_DATE_KEY from fact_session where START_DATE_KEY  between 20171101 and 20180226
and APPLICATION_KEY in(10,20)
and LEFT_PAGE_KEY in (2841,1924)
group by START_DATE_KEY;

select count(1),START_DATE_KEY from fact_session where START_DATE_KEY  between 20171101 and 20180226
and APPLICATION_KEY in(10,20)
group by START_DATE_KEY;

(
select count(distinct vid) num2,visit_date_key  from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20171101 and 20180226
and page_name ='Good'  
--and page_value in  (select to_char(GOODS_COMMONID) from   dim_ec_good where STORE_ID=1  and IS_TV=1)
 and APPLICATION_KEY in (10,20)   group by visit_date_key
)


-----------直播商品使用率

select * from 
(
select page_value,count(distinct vid) num1,visit_date_key  as visit_date_key1 from DW_USER.FACT_PAGE_VIEW@BITONEWBI  where visit_date_key between 
20180101 and 20180226
and page_name ='SL_Good_Customer'
and page_value in  (select to_char(GOODS_COMMONID) from   dim_ec_good where STORE_ID=1  and IS_TV=1)
 group by page_value,visit_date_key
) a  left join  
(select GOODS_COMMON_ID,TV_STARTDAY_KEY from dim_tv_good) b on a.visit_date_key1=b.TV_STARTDAY_KEY and a.page_value=to_char(b.GOODS_COMMON_ID)
