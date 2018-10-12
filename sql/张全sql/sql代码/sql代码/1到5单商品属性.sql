----一单商品属性
select * from (
select * from 
(select MEMBER_CRMBP,M_LABEL_DESC from (select MEMBER_CRMBP,REGISTER_APPNAME from fact_ecmember) a left join
 (select MEMBER_KEY,M_LABEL_DESC from MEMBER_LABEL_LINK_V where  
 M_LABEL_ID in (select M_LABEL_ID from MEMBER_LABEL_HEAD where M_LABEL_FATHER_ID=235)) b on a.member_crmbp=b.MEMBER_KEY)
s left join
(select * from (
select to_number(MEMBER_BP) as MEMBER_KEY,ADD_TIME,ORDER_ID,SALES_SOURCE_SECOND_DESC,PROMOTION_DESC from oper_ec_member_track_rank
where RANK1=1  and  to_number(MEMBER_BP) not in (select MEMBER_BP from dim_member where FIRSTW_ORDER_DATE_KEY<20170101) )
a left join (select ITEM_CODE,ORDER_ID from  factec_order_goods where GOODS_TYPE not in(5,6) ) c on a.ORDER_ID=c.ORDER_ID
left join (select GOODS_NAME,ITEM_CODE,BRAND_NAME,GOODS_PRICE,IS_TV,IS_KJG,MATDLT,MATZLT,MATXLT,IS_SHIPPING_SELF from dim_ec_good) d
on c.ITEM_CODE=d.item_code
) ss
on s.MEMBER_CRMBP=ss.MEMBER_KEY ) where MEMBER_KEY is not null

----二单商品属性
select * from (
select * from 
(select MEMBER_CRMBP,M_LABEL_DESC from (select MEMBER_CRMBP,REGISTER_APPNAME from fact_ecmember) a left join
 (select MEMBER_KEY,M_LABEL_DESC from MEMBER_LABEL_LINK_V where  
 M_LABEL_ID in (select M_LABEL_ID from MEMBER_LABEL_HEAD where M_LABEL_FATHER_ID=235)) b on a.member_crmbp=b.MEMBER_KEY)
s left join
(select * from (
select to_number(MEMBER_BP) as MEMBER_KEY,ADD_TIME,ORDER_ID,SALES_SOURCE_SECOND_DESC,PROMOTION_DESC from oper_ec_member_track_rank
where RANK1=2  and  to_number(MEMBER_BP) not in (select MEMBER_BP from dim_member where FIRSTW_ORDER_DATE_KEY<20170101) )
a left join (select ITEM_CODE,ORDER_ID from  factec_order_goods where GOODS_TYPE not in(5,6) ) c on a.ORDER_ID=c.ORDER_ID
left join (select GOODS_NAME,ITEM_CODE,BRAND_NAME,GOODS_PRICE,IS_TV,IS_KJG,MATDLT,MATZLT,MATXLT,IS_SHIPPING_SELF from dim_ec_good) d
on c.ITEM_CODE=d.item_code
) ss
on s.MEMBER_CRMBP=ss.MEMBER_KEY ) where MEMBER_KEY is not null

---三单商品属性
select * from (
select * from 
(select MEMBER_CRMBP,M_LABEL_DESC from (select MEMBER_CRMBP,REGISTER_APPNAME from fact_ecmember) a left join
 (select MEMBER_KEY,M_LABEL_DESC from MEMBER_LABEL_LINK_V where  
 M_LABEL_ID in (select M_LABEL_ID from MEMBER_LABEL_HEAD where M_LABEL_FATHER_ID=235)) b on a.member_crmbp=b.MEMBER_KEY)
s left join
(select * from (
select to_number(MEMBER_BP) as MEMBER_KEY,ADD_TIME,ORDER_ID,SALES_SOURCE_SECOND_DESC,PROMOTION_DESC from oper_ec_member_track_rank
where RANK1=3  and  to_number(MEMBER_BP) not in (select MEMBER_BP from dim_member where FIRSTW_ORDER_DATE_KEY<20170101) )
a left join (select ITEM_CODE,ORDER_ID from  factec_order_goods where GOODS_TYPE not in(5,6) ) c on a.ORDER_ID=c.ORDER_ID
left join (select GOODS_NAME,ITEM_CODE,BRAND_NAME,GOODS_PRICE,IS_TV,IS_KJG,MATDLT,MATZLT,MATXLT,IS_SHIPPING_SELF from dim_ec_good) d
on c.ITEM_CODE=d.item_code
) ss
on s.MEMBER_CRMBP=ss.MEMBER_KEY ) where MEMBER_KEY is not null


---4单商品属性
select * from (
select * from 
(select MEMBER_CRMBP,M_LABEL_DESC from (select MEMBER_CRMBP,REGISTER_APPNAME from fact_ecmember) a left join
 (select MEMBER_KEY,M_LABEL_DESC from MEMBER_LABEL_LINK_V where  
 M_LABEL_ID in (select M_LABEL_ID from MEMBER_LABEL_HEAD where M_LABEL_FATHER_ID=235)) b on a.member_crmbp=b.MEMBER_KEY)
s left join
(select * from (
select to_number(MEMBER_BP) as MEMBER_KEY,ADD_TIME,ORDER_ID,SALES_SOURCE_SECOND_DESC,PROMOTION_DESC from oper_ec_member_track_rank
where RANK1=4  and  to_number(MEMBER_BP) not in (select MEMBER_BP from dim_member where FIRSTW_ORDER_DATE_KEY<20170101) )
a left join (select ITEM_CODE,ORDER_ID from  factec_order_goods where GOODS_TYPE not in(5,6) ) c on a.ORDER_ID=c.ORDER_ID
left join (select GOODS_NAME,ITEM_CODE,BRAND_NAME,GOODS_PRICE,IS_TV,IS_KJG,MATDLT,MATZLT,MATXLT,IS_SHIPPING_SELF from dim_ec_good) d
on c.ITEM_CODE=d.item_code
) ss
on s.MEMBER_CRMBP=ss.MEMBER_KEY ) where MEMBER_KEY is not null


---5单商品属性
select * from (
select * from 
(select MEMBER_CRMBP,M_LABEL_DESC from (select MEMBER_CRMBP,REGISTER_APPNAME from fact_ecmember) a left join
 (select MEMBER_KEY,M_LABEL_DESC from MEMBER_LABEL_LINK_V where  
 M_LABEL_ID in (select M_LABEL_ID from MEMBER_LABEL_HEAD where M_LABEL_FATHER_ID=235)) b on a.member_crmbp=b.MEMBER_KEY)
s left join
(select * from (
select to_number(MEMBER_BP) as MEMBER_KEY,ADD_TIME,ORDER_ID,SALES_SOURCE_SECOND_DESC,PROMOTION_DESC from oper_ec_member_track_rank
where RANK1=5  and  to_number(MEMBER_BP) not in (select MEMBER_BP from dim_member where FIRSTW_ORDER_DATE_KEY<20170101) )
a left join (select ITEM_CODE,ORDER_ID from  factec_order_goods where GOODS_TYPE not in(5,6) ) c on a.ORDER_ID=c.ORDER_ID
left join (select GOODS_NAME,ITEM_CODE,BRAND_NAME,GOODS_PRICE,IS_TV,IS_KJG,MATDLT,MATZLT,MATXLT,IS_SHIPPING_SELF from dim_ec_good) d
on c.ITEM_CODE=d.item_code
) ss
on s.MEMBER_CRMBP=ss.MEMBER_KEY ) where MEMBER_KEY is not null
