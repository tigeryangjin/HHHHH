----- 0单转1单用户
select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between  20171201 and  20171207
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY not  in (
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <= 20171201 and order_state=1
group by  MEMBER_KEY)
);

----- 1单转2单用户
select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between  20171201 and  20171207
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in (
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <= 20171201 and order_state=1
group by  MEMBER_KEY) where num1=1
);
----- 2单转3单用户
select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between  20171201 and  20171207
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in (
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <= 20171201 and order_state=1
group by  MEMBER_KEY) where num1=2
);
----- 3单转4单用户
select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between  20171201 and  20171207
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in (
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <= 20171201 and order_state=1
group by  MEMBER_KEY) where num1=3
);
----- 4单转5单用户
select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between  20171201 and  20171207
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in (
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <= 20171201 and order_state=1
group by  MEMBER_KEY) where num1=4
);

