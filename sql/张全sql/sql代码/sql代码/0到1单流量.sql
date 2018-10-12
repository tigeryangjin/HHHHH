----- 0单转1单用户

insert into  ls_test(ssid)
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY < 20171201 and order_state=1
group by  MEMBER_KEY);
select count(distinct MEMBER_KEY ) from fact_session where  START_DATE_KEY between  20171201 and  20171207
and MEMBER_KEY not in (
select ssid from  ls_test
);
truncate table ls_test;
----- 1单转2单用户
insert into  ls_test(ssid)
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY < 20171201 and order_state=1
group by  MEMBER_KEY) where num1=1;
select count(distinct MEMBER_KEY ) from fact_session where  START_DATE_KEY between  20171201 and  20171207
and MEMBER_KEY in (
select ssid from  ls_test
);
truncate table ls_test;
----- 2单转3单用户
insert into  ls_test(ssid)
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY < 20171201 and order_state=1
group by  MEMBER_KEY) where num1=2;
select count(distinct MEMBER_KEY ) from fact_session where  START_DATE_KEY between  20171201 and  20171207
and MEMBER_KEY in (
select ssid from  ls_test
);
truncate table ls_test;
----- 3单转4单用户
insert into  ls_test(ssid)
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY < 20171201 and order_state=1
group by  MEMBER_KEY) where num1=3;
select count(distinct MEMBER_KEY ) from fact_session where  START_DATE_KEY between  20171201 and  20171207
and MEMBER_KEY in (
select ssid from  ls_test
);
truncate table ls_test;
----- 4单转5单用户
insert into  ls_test(ssid)
select MEMBER_KEY from (
select MEMBER_KEY,count(1) num1 from fact_order where  POSTING_DATE_KEY < 20171201 and order_state=1
group by  MEMBER_KEY) where num1=4;
select count(distinct MEMBER_KEY ) from fact_session where  START_DATE_KEY between  20171201 and  20171207
and MEMBER_KEY in (
select ssid from  ls_test
);
truncate table ls_test;



