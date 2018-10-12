------

select count(distinct vid),visit_date_key,count(1) from fact_page_view where visit_date_key between 20180615
and 20180704 and APPLICATION_KEY=70
and HMSC ='Bargain' group by visit_date_key

------
SELECT NUM1,COUNT(1) FROM (
select VID,COUNT(DISTINCT visit_date_key)  NUM1 from fact_page_view where visit_date_key between 20180615
and 20180704 and APPLICATION_KEY=70
and HMSC ='Bargain' group by VID)  GROUP BY NUM1


------用户发起砍价（引客）
select * from(
SELECT count(distinct vid),count(distinct IP),visit_date_key  FROM  fact_page_view_hit where visit_date_key between 20180615
and 20180704 and APPLICATION_KEY=70
and HMSC ='Bargain'
and page_name='BargainGood' group by visit_date_key) a
join (
SELECT count(distinct vid),count(distinct IP),visit_date_key  FROM  fact_page_view_hit where visit_date_key between 20180615
and 20180704 and APPLICATION_KEY=70
and HMSC ='Bargain'
and page_name='SL_BargainGood_New' group by visit_date_key) b on  a.visit_date_key=b.visit_date_key
join (
SELECT count(distinct vid),count(distinct IP),visit_date_key  FROM  fact_page_view_hit where visit_date_key between 20180615
and 20180704 and APPLICATION_KEY=70
and HMSC ='Bargain'
and page_name='SL_BargainGood_Keeping' group by visit_date_key) c on   a.visit_date_key=c.visit_date_key



------
insert into ls_test
select 1,vid,1 from  fact_page_view where  visit_date_key between 20180615
and 20180704 and APPLICATION_KEY=70
and PAGE_KEY =51455
and HMSC ='Bargain' and id in
(
SELECT min(id) FROM  fact_page_view_hit where visit_date_key between 20180615
and 20180704 and APPLICATION_KEY=70
and HMSC ='Bargain'
group by vid,visit_date_key
)


----------帮砍用户转化（裂变）
select * from(
SELECT count(distinct vid),count(distinct IP),visit_date_key  FROM  fact_page_view_hit where visit_date_key between 20180615
and 20180704 and APPLICATION_KEY=70
and HMSC ='Bargain'
and page_name='Bargaindetials' group by visit_date_key) a
join (
SELECT count(distinct vid),count(distinct IP),visit_date_key  FROM  fact_page_view_hit where visit_date_key between 20180615
and 20180704 and APPLICATION_KEY=70
and HMSC ='Bargain'
and page_name='BargainGood' 
and  vid in (select SNAME from ls_test)
group by visit_date_key) b on  a.visit_date_key=b.visit_date_key
join (
SELECT count(distinct vid),count(distinct IP),visit_date_key  FROM  fact_page_view_hit where visit_date_key between 20180615
and 20180704 and APPLICATION_KEY=70
and HMSC ='Bargain'
and  vid in (select SNAME from ls_test)
and page_name='SL_BargainGood_New' group by visit_date_key) c on   a.visit_date_key=c.visit_date_key


---------

select count(distinct a.MEMBER_KEY),VISIT_DATE_KEY,count(distinct c.MEMBER_KEY),sum(num1)  from 
(select MEMBER_KEY,visit_date_key  from fact_page_view where visit_date_key between 20180613
and 20180704 and APPLICATION_KEY=70
and HMSC ='Bargain' ) a 
 join 
(
select MEMBER_CRMBP,MEMBER_TIME from fact_ecmember where MEMBER_TIME between 20180613
and 20180704
)  b on a.MEMBER_KEY=b.MEMBER_CRMBP and a.visit_date_key=b.MEMBER_TIME

left join (
select  sum(order_amount) num1, member_key from factec_order where add_time between 20180613
and 20180704 and order_state>10 group by  member_key
) c  on  a.MEMBER_KEY=c.member_key
group by VISIT_DATE_KEY

 
select count(1),CREATE_DATE_KEY from fact_visitor_register where  CREATE_DATE_KEY between 20180614
and 20180704 and  APPLICATION_KEY=70 and HMSC ='Bargain'  group by CREATE_DATE_KEY
