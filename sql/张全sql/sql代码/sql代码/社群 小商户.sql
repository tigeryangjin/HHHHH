insert into    ls_test1  (S1 )

select MEMBER_KEY from (
select MEMBER_KEY,count(distinct(ADDRESS_KEY)) num1 from fact_order  group by MEMBER_KEY
) where  num1>15;


select * from( 
select MEMBER_KEY,count(1) order_nums,sum(order_amount) order_amount from  fact_order where   POSTING_DATE_KEY >20170101 and order_state=1 and member_key   in(
select S1 from ls_test1) group by MEMBER_KEY) a
left join dim_member b  on a.MEMBER_KEY=b.member_bp
left join  (select MEMBER_KEY,OPEN_ID from dim_mapping_mem) c on a.MEMBER_KEY=c.MEMBER_KEY

