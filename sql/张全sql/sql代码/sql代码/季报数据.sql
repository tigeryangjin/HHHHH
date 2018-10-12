----- 0单转1单用户
 insert into  ls_test1 (ssid)
 select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <20170701 and order_state=1
group by  MEMBER_KEY);


select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between 20170701 and 20170931
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY  not in  (
select ssid from ls_test1
);

truncate table ls_test1;

----- 0单转1单用户
 insert into  ls_test1 (ssid)
 select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <20170701 and order_state=1
group by  MEMBER_KEY) where num1=1;


select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between 20170701 and 20170931
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in  (
select ssid from ls_test1
);

truncate table ls_test1;


----- 1单转2单用户
----- 0单转1单用户
 insert into  ls_test1 (ssid)
 select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <20170701 and order_state=1
group by  MEMBER_KEY) where num1=2;


select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between 20170701 and 20170931
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in  (
select ssid from ls_test1
);

truncate table ls_test1;

----- 2单转3单用户
----- 0单转1单用户
 insert into  ls_test1 (ssid)
 select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <20170701 and order_state=1
group by  MEMBER_KEY) where num1=3;


select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between 20170701 and 20170931
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in  (
select ssid from ls_test1
);

truncate table ls_test1;

----- 3单转4单用户
 insert into  ls_test1 (ssid)
 select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY <20170701 and order_state=1
group by  MEMBER_KEY) where num1=4;


select count(distinct(MEMBER_KEY)),sum(order_amount) from  fact_order where  POSTING_DATE_KEY between 20170701 and 20170931
and order_state=1 and SALES_SOURCE_KEY=20  and SALES_SOURCE_SECOND_KEY>20013
and MEMBER_KEY in  (
select ssid from ls_test1
);

truncate table ls_test1;



