----- 0��ת1���û�
select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between  20171201 and  20171207
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY not  in (
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <= 20171201 and order_state=1
group by  MEMBER_KEY)
);

----- 1��ת2���û�
select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between  20171201 and  20171207
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in (
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <= 20171201 and order_state=1
group by  MEMBER_KEY) where num1=1
);
----- 2��ת3���û�
select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between  20171201 and  20171207
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in (
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <= 20171201 and order_state=1
group by  MEMBER_KEY) where num1=2
);
----- 3��ת4���û�
select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between  20171201 and  20171207
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in (
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <= 20171201 and order_state=1
group by  MEMBER_KEY) where num1=3
);
----- 4��ת5���û�
select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between  20171201 and  20171207
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in (
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <= 20171201 and order_state=1
group by  MEMBER_KEY) where num1=4
);

