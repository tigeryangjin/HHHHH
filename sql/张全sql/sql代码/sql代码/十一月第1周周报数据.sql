---˫ʮһǰһ�� ��Ա�ṹ״̬
select count(distinct(MEMBER_KEY)),CLV_TYPE from 
(select MEMBER_KEY,VISIT_DATE_KEY,REGISTER_RESOURCE,MEMBER_INSERT_DATE,CLV_TYPE from 
(select MEMBER_KEY,visit_date_key from  fact_page_view  a where a.visit_date_key between 20161031 and 20161105

group by  MEMBER_KEY,visit_date_key) a left join dim_member b on a.member_key=b.member_bp ) 
 where CLV_TYPE is not null

group by CLV_TYPE

--- 

select count(distinct(MEMBER_KEY)) from (
(select MEMBER_KEY,VISIT_DATE_KEY,MEMBER_BP,CLV_TYPE from (
(select MEMBER_KEY,visit_date_key from  fact_page_view  a where a.visit_date_key between 20161031 and 20161105
group by  MEMBER_KEY,visit_date_key) a left join dim_member b on a.member_key=b.member_bp)  where CLV_TYPE is  null)
) where  MEMBER_BP is not  null  

---- 1020 ��1111Ԥ�Ƚ׶� ��Ա�ص�����
select * from 
(select MEMBER_KEY,CLV_TYPE from (
(select MEMBER_KEY,VISIT_DATE_KEY,CLV_TYPE from 
(select MEMBER_KEY,visit_date_key from  fact_page_view  a where a.visit_date_key between 20161031 and 20161105

group by  MEMBER_KEY,visit_date_key) a left join dim_member b on a.member_key=b.member_bp ) ) 
group by MEMBER_KEY,CLV_TYPE) ss

left join 
(
select MEMBER_KEY from factec_order where ADD_TIME  between 20161111 and 20161021  and order_state >0  and ORDER_AMOUNT >19.9 group by MEMBER_KEY 
) sss
on ss.MEMBER_KEY=sss.MEMBER_KEY


select MEMBER_KEY,CLV_TYPE,count(1) from 
(select MEMBER_KEY,VISIT_DATE_KEY,CLV_TYPE from 
(select MEMBER_KEY,visit_date_key from  fact_page_view  a where a.visit_date_key between 20161030 and 20161105

group by  MEMBER_KEY,visit_date_key) a left join dim_member b on a.member_key=b.member_bp ) group by  MEMBER_KEY,CLV_TYPE


left join 
(select MEMBER_KEY,CLV_TYPE from (
(select MEMBER_KEY,VISIT_DATE_KEY,CLV_TYPE from 
(select MEMBER_KEY,visit_date_key from  fact_page_view  a where a.visit_date_key between 20161111 and 20161021

group by  MEMBER_KEY,visit_date_key) a left join dim_member b on a.member_key=b.member_bp ))
group by MEMBER_KEY,CLV_TYPE) s 
on ss.MEMBER_KEY=s.MEMBER_KEY


----  1020 �����ص�
select MEMBER_KEY,member_bp,CLV_TYPE,ORDER_ID from 
(select MEMBER_KEY,ORDER_ID from factec_order where ADD_TIME  between 20161010 and 20161015  and order_state >0   and ORDER_AMOUNT >19.9 group by MEMBER_KEY,ORDER_ID) a
left join dim_member b on a.member_key=b.member_bp

select count(distinct(MEMBER_KEY)) from factec_order where   ADD_TIME  between 20161031 and 20161105 
  and order_state >0  and ORDER_AMOUNT >19.9
  
  

   
