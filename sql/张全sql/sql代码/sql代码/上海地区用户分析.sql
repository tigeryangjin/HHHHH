
-----��Ⱥ
truncate table ls_test;
insert into  ls_test(ssid)
select distinct(MEMBER_KEY) from  factec_order where ZONE1_4 in (
SELECT ZONE1_4 from dim_zone where VTEXT1='�Ϻ���') and add_time >20170101



--- �Ա�����
select MEMBER_AGE,MEMBER_AGENDA,count(1) 
from dim_member where   MEMBER_BP in (select ssid from ls_test)
group by MEMBER_AGE,MEMBER_AGENDA

---- ���ϴ���
select MATDLT,count(distinct MEMBER_KEY),count(1),count(distinct ORDER_KEY) from (
select GOODS_COMMON_KEY,MEMBER_KEY,ITEM_CODE,ORDER_KEY,GOODS_NAME,MATDLT from (
select GOODS_COMMON_KEY,MEMBER_KEY,ORDER_KEY from fact_goods_sales where ORDER_DATE_KEY between 20170101 and 20171031
and TRAN_TYPE=0
and order_state=1
and MEMBER_KEY in (select ssid from ls_test)) a
left join (select ITEM_CODE,GOODS_NAME,MATDLT from dim_ec_good) b on a.GOODS_COMMON_KEY=b.ITEM_CODE
)  group by MATDLT;

---- ��Ʒ
select ITEM_CODE,GOODS_NAME,count(distinct MEMBER_KEY),count(1),count(distinct ORDER_KEY) from (
select GOODS_COMMON_KEY,MEMBER_KEY,ITEM_CODE,ORDER_KEY,GOODS_NAME,MATDLT from (
select GOODS_COMMON_KEY,MEMBER_KEY,ORDER_KEY from fact_goods_sales where ORDER_DATE_KEY between 20170101 and 20171031
and TRAN_TYPE=0
and order_state=1
and MEMBER_KEY in (select ssid from ls_test)) a
left join (select ITEM_CODE,GOODS_NAME,MATDLT from dim_ec_good) b on a.GOODS_COMMON_KEY=b.ITEM_CODE
)  group by GOODS_NAME,ITEM_CODE

----

select M_LABEL_DESC,count(1),M_LABEL_ID,M_LABEL_TYPE_ID from member_label_link_v
where MEMBER_KEY in (select ssid from ls_test)
group by M_LABEL_DESC,M_LABEL_ID,M_LABEL_TYPE_ID



-----

