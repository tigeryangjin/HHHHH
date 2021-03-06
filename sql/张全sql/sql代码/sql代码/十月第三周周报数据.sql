----热力图
----大眼睛 修正UV
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Big_ad'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )
  from dual
----大眼睛非修正
 
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Big_ad'  
 
 and s.visit_date_key=20161020

---4大icon

---签到修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='HappigoSign'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--签到非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='HappigoSign'  
 
 and s.visit_date_key=20161020

---夺宝修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='JFDB_Home'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )  from dual
--夺宝非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='JFDB_Home'  
 
 and s.visit_date_key=20161020
 
 ---新人礼修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='WZT2'  and VER_NAME  in('6.8.0',' 6.8.1') and s.page_value='dMaGEb7Z38WcZrs'
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--新人礼非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='WZT2'   and s.page_value='dMaGEb7Z38WcZrs'
 
 and s.visit_date_key=20161020

---全球购修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Qqg_goodList'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--全球购非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Qqg_goodList'  
 
 and s.visit_date_key=20161020
  
---中间广告位修正

select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Mediate_ad'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--中间广告位非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Mediate_ad'  
 
 and s.visit_date_key=20161020
 
---头条修正

select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Home_headlines'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--头条非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Home_headlines'  
 
 and s.visit_date_key=20161020
---限时抢修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Flash_sale'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--限时抢非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Flash_sale'  
 
 and s.visit_date_key=20161020

---0元购修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='New_Good'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )    from dual
--0元购非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='New_Good'  
 
 and s.visit_date_key=20161020
 
---热销榜修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Hot_Good'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--热销榜非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Hot_Good'  
 
 and s.visit_date_key=20161020

---TV直播修正

select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='TV_liveplay'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--TV直播非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='TV_liveplay'  
 
 and s.visit_date_key=20161020
---节目表修正

select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='TVPlayList'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs') and s.last_page_key in(6404,6966)
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--节目表非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='TVPlayList'  
 
 and s.visit_date_key=20161020
 
---小眼睛修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Small_ad'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--小眼睛非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Small_ad'  
 
 and s.visit_date_key=20161020
---分类修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Category'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--分类非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Category'  
 
 and s.visit_date_key=20161020
---视频购修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Video_home'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--视频购非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Video_home'  
 
 and s.visit_date_key=20161020

---购物车修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='ShoppingCart'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )   from dual
--购物车非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='ShoppingCart'  
 
 and s.visit_date_key=20161020
---个人中心修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Member'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )    from dual
--个人中心非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Member'  
 
 and s.visit_date_key=20161020

---搜索修正
select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Search'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )    from dual
--搜索非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Search'  
 
 and s.visit_date_key=20161020
 
 ----TV直播修正
 
 select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Home_TVLive'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )    from dual
--TV直播非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Home_TVLive'  
 
 and s.visit_date_key=20161020
 
  ----消息中心修正
 
 select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Message_Center'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )    from dual
--消息中心非修正
SELECT  count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) --and s.page_name='Message_Center'  
 
 and s.visit_date_key=20161020
 
 
  ----频道修正
 
 select 
(select count(distinct(vid))  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Webcast'  and VER_NAME  in('6.8.0',' 6.8.1') --and s.page_value='18'
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)/(
 
 select count(distinct(vid))from fact_page_view s  where 
  s.application_key in(10,20)  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key=20161020)* (select count(distinct(vid)) from fact_page_view s  where 
  s.application_key in(10,20)  and s.visit_date_key=20161020 )    from dual
  
  
  ----用户数据   1020 数据 
  
  select count(1) from fact_visitor_register  where CREATE_DATE_KEY=20161020 and APPLICATION_KEY in (10,20)
  and HMSC in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')
  
  
  select  count(1) from fact_visitor_register  where CREATE_DATE_KEY=20161020 and APPLICATION_KEY in (10,20)
  and HMSC not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')

---老用户

 select count(distinct(vid)) from fact_page_view s where s.visit_date_key=20161020 and APPLICATION_KEY in (10,20)
  and HMSC in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')
  
 select count(distinct(vid)) from fact_page_view s where s.visit_date_key=20161020 and APPLICATION_KEY in (10,20)
  and HMSC not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')
  

---用户注册 



----新用户数据 日常数据 
---推广来源
  select count(1)/18 from fact_visitor_register  where CREATE_DATE_KEY between 20161001 and 20161018 and APPLICATION_KEY in (10,20)
 and HMSC in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')
 
 

--非推广来源
    select count(1)/18 from fact_visitor_register  where CREATE_DATE_KEY between 20161001 and 20161018 and APPLICATION_KEY in (10,20)
 and HMSC  not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')

--老用户 日常数据
---推广来源

  select count(distinct(vid)),START_DATE_KEY from fact_session  where START_DATE_KEY between 20161001 and 20161018 and APPLICATION_KEY in (10,20)
  and HMSC   in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')  group by START_DATE_KEY
---非推广来源
  select count
  select count(distinct(vid)),START_DATE_KEY from fact_session  where START_DATE_KEY between 20161001 and 20161018 and APPLICATION_KEY in (10,20)
  and HMSC  not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')  group by START_DATE_KEY
  
  ----注册数据
  ---新推广用户注册
  select count(1) from fact_ecmember where MEMBER_CRMBP in (
  select MEMBER_KEY from fact_session  where   START_DATE_KEY=20161020  and vid in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161020 and APPLICATION_KEY in (10,20)
  and HMSC in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')) and MEMBER_KEY!=0) and 
  MEMBER_TIME =20161020 
  ---新非推广用户注册
  select count(1) from fact_ecmember where MEMBER_CRMBP in (
  select MEMBER_KEY from fact_session  where   START_DATE_KEY=20161020  and vid in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161020 and APPLICATION_KEY in (10,20)
  and HMSC not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')) and MEMBER_KEY!=0) and 
  MEMBER_TIME =20161020 
  
  ---老非推广用户注册
  select count(1) from fact_ecmember where MEMBER_CRMBP in (
  select MEMBER_KEY from fact_session  where   START_DATE_KEY=20161020   and   APPLICATION_KEY in (10,20) 
  and HMSC not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')
   and MEMBER_KEY!=0) and 
  MEMBER_TIME =20161020 
   ---老推广用户注册
  select count(1) from fact_ecmember where MEMBER_CRMBP in (
  select MEMBER_KEY from fact_session  where   START_DATE_KEY=20161020   and   APPLICATION_KEY in (10,20) 
  and HMSC  in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')
   and MEMBER_KEY!=0) and 
  MEMBER_TIME =20161020 
  
  
  ---加购物车人数
  ---新推广用户加购物车
  select  count(distinct(vid)) from  fact_shoppingcar  where CREATE_DATE_KEY=20161020 and vid in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161111 and APPLICATION_KEY in (10,20)
  and HMSC in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')) 
  
  ---新非推广用户加购物车
  select  count(distinct(vid)) from  fact_shoppingcar  where CREATE_DATE_KEY=20161020 and vid in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161020 and APPLICATION_KEY in (10,20)
  and HMSC not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')) 
  
   ---老非推广用户加购物车
  select  count(distinct(vid)) from  fact_shoppingcar  where CREATE_DATE_KEY=20161020 and vid in (
   select vid from fact_session  where   START_DATE_KEY=20161020   and   APPLICATION_KEY in (10,20) 
  and HMSC not  in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')) 
  
     ---老推广用户加购物车
  select  count(distinct(vid)) from  fact_shoppingcar  where CREATE_DATE_KEY=20161020 and vid in (
   select vid from fact_session  where   START_DATE_KEY=20161020   and   APPLICATION_KEY in (10,20) 
  and HMSC  in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')) 
  
  ---总订购人数
  ---新推广用户总订购
  select count(distinct(vid)) from  factec_order where ADD_TIME=20161020 and vid  in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161020 and APPLICATION_KEY in (10,20)
  and HMSC in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')) 
  ---新推广用户有效订购
   select count(distinct(vid)),sum(ORDER_AMOUNT) from  factec_order where ADD_TIME=20161020 and vid  in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161020 and APPLICATION_KEY in (10,20)
  and HMSC in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广'))  and ORDER_STATE>0 
  


  ---新非推广用户总订购
  select count(distinct(vid)) from  factec_order where ADD_TIME=20161020 and vid  in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161020 and APPLICATION_KEY in (10,20)
  and HMSC not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')) ;
  ---新非推广用户有效订购
   select count(distinct(vid)),sum(ORDER_AMOUNT) from  factec_order where ADD_TIME=20161020 and vid  in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161020 and APPLICATION_KEY in (10,20)
  and HMSC not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广'))  and ORDER_STATE>0 ;
  
  
    ---新非推广用户总订购
  select count(distinct(vid)) from  factec_order where ADD_TIME=20161020 and vid  in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161020 and APPLICATION_KEY in (10,20)
  and HMSC not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广')) ;
  ---新非推广用户有效订购
   select count(distinct(vid)),sum(ORDER_AMOUNT) from  factec_order where ADD_TIME=20161020 and vid  in (
    select vid from fact_visitor_register  where CREATE_DATE_KEY=20161020 and APPLICATION_KEY in (10,20)
  and HMSC not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广'))  and ORDER_STATE>0 ;
  
      ---老非推广用户总订购
  select count(distinct(vid)) from  factec_order where ADD_TIME=20161020 and  vid in (
   select vid from fact_session  where   START_DATE_KEY=20161020   and   APPLICATION_KEY in (10,20) 
  and HMSC not  in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广'))  ;
  ---老非推广用户有效订购
   select count(distinct(vid)),sum(ORDER_AMOUNT) from  factec_order where ADD_TIME=20161020 and  vid in (
   select vid from fact_session  where   START_DATE_KEY=20161020   and   APPLICATION_KEY in (10,20) 
  and HMSC not  in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广'))   and ORDER_STATE>0 ;
  
    
      ---老推广用户总订购
  select count(distinct(vid)) from  factec_order where ADD_TIME=20161020 and  vid in (
   select vid from fact_session  where   START_DATE_KEY=20161020   and   APPLICATION_KEY in (10,20) 
  and HMSC   in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广'))  ;
  ---老推广用户有效订购
   select count(distinct(vid)),sum(ORDER_AMOUNT) from  factec_order where ADD_TIME=20161020 and  vid in (
   select vid from fact_session  where   START_DATE_KEY=20161020   and   APPLICATION_KEY in (10,20) 
  and HMSC  in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广'))   and ORDER_STATE>0 ;
  
  
  
  ----1020 各个节点转化情况
  ---日活
  select  sum(uv)/count(visit_date_key) from (
  select count(distinct(vid)) as uv,visit_date_key from fact_page_view  sa where 
  sa.visit_date_key between 20161010 and 20161017 and sa.application_key in (10,20)
  group by visit_date_key );
  
  ---商品详情页
  
   select  sum(uv)/count(visit_date_key) from (
  select count(distinct(vid)) as uv,visit_date_key from fact_page_view  sa where
   sa.visit_date_key  between 20161010 and 20161017 and sa.application_key in (10,20)
  and sa.page_name='Good'
  group by visit_date_key );
  
  ---订单提交页
  
   select  sum(uv)/count(visit_date_key) from (
  select count(distinct(vid)) as uv,visit_date_key from fact_page_view  sa where 
  sa.visit_date_key  between 20161010 and 20161017  and sa.application_key in (10,20)
  and sa.page_name='OrderConfirm' group by visit_date_key );
  ---总订购人数 
  select  sum(uv)/count(ADD_TIME) from (
  select count(distinct(vid)) as uv,ADD_TIME
  from factec_order where ADD_TIME   between 20161010 and 20161017 and   ORDER_FROM in(63,61)
  group by ADD_TIME ) ;
  
  ----有效订购人数
  select  sum(uv)/count(ADD_TIME) from (
  select count(distinct(vid)) as uv,ADD_TIME
   from factec_order where ADD_TIME between 20151111 and 20151111  and   ORDER_FROM in(63,61) and ORDER_STATE>0   
   and ORDER_AMOUNT>9
   
   group by ADD_TIME );

  
  ----  路径1 
  select * from fact_page_view where  sa.visit_date_key=20161020 and sa.application_key in (10,20) and 
  sa.page_name not  in ('KFZT','Video_home','Home_TVLive','Search')
  
  select * from 
  (select * from  factec_order where ADD_TIME=20161020 and   ORDER_FROM in(63,61) ) a left join factec_order_goods b
  on a.ORDER_ID =b.ORDER_ID
  
  --搜索结果页
  select
  
  select vid,PAGE_VALUE,IP_GEO_KEY,LAST_PAGE_KEY from fact_page_view sa  where  sa.visit_date_key=20161020 
  and sa.application_key in (10,20)  and   IP_GEO_KEY>0 and 
   (IP_GEO_KEY =969 or IP_GEO_KEY =2851 or IP_GEO_KEY =1740 or IP_GEO_KEY =2899 ) or  LAST_PAGE_KEY in(969,2851,1740,2899))
  
  select * from fact_page_view sa  where  sa.visit_date_key=20161020 
  and sa.application_key in (10,20) and  sa.page_name='Good' 
  
  
  
 select count(distinct(vid)) from fact_page_view sa  where  sa.visit_date_key=20161020 
  and sa.application_key in (10,20) and (sa.page_name like '%app%' and page_name!='HappigoSign')
  -- TV 
    
 select count(distinct(vid)) from fact_page_view sa  where  sa.visit_date_key=20161020 
  and sa.application_key in (10,20) and (sa.page_name='TVPlayList'  OR sa.page_name='Home_TVLive')
  
  --Channel
  
      
 select count(distinct(vid)) from fact_page_view sa  where  sa.visit_date_key=20161020 
  and sa.application_key in (10,20) and sa.page_name='Channel'  
  
  --Search	
  
   select count(distinct(vid)) from fact_page_view sa  where  sa.visit_date_key=20161020 
  and sa.application_key in (10,20) and sa.page_name='Search' 
  
  ---Category
     select count(distinct(vid)) from fact_page_view sa  where  sa.visit_date_key=20161020 
  and sa.application_key in (10,20) and sa.page_name='Category' 
  
    ---Category
     select count(distinct(vid)) from fact_page_view sa  where  sa.visit_date_key=20161020 
  and sa.application_key in (10,20) and (sa.page_name='ZT_Detail2'  or sa.page_name='WZT2')
  
  
  select sum(ORDER_AMOUNT) from  factec_order where add_time=20161020 and  ORDER_STATE>0  and  ORDER_FROM in (61,63)
  
  
  select count(distinct(vid)) from fact_visitor_register where  CREATE_DATE_KEY=20161021
   and  APPLICATION_KEY in (10,20)   and HMSC not in (select HMSC from dim_hmsc where HMMD is not null and HMPL='推广') 
   
   13859 1966
   
   
   
   select SKW,count(1) from fact_search  where  CREATE_DATE_KEY=20161020 and  (APPLICATION_KEY =10  Or  APPLICATION_KEY =20)
   
   
   and  vid in ( select vid
   from factec_order where ADD_TIME between 20161020 and 20161020 and   ORDER_FROM in(63,61) and ORDER_STATE>0   
   and ORDER_AMOUNT>9 )
   group by SKW
select  max(VISIT_DATE) from Fact_Page_View 


select * from dim_page


select PAGE_NAME,count(1) from fact_page_view da where  da.visit_date_key  between 20161020 and 20161024
group by page_name


select count(1) from dim_member where (END_ACTIVE_DATE_KEY=20160826 
or(LAST_ORDER_DATE_KEY=20160826 and END_ACTIVE_DATE_KEY=0 and MEMBER_AGE<=55)) and VALID_ORDERAMOUNT>=2000


select  * from fact_page_view ds where ds.visit_date_key=20161026 and vid='iphone6cc73094f918c903203fa5aa96766f32a4256b92'
 and ds.page_name='Refund'
 
 
 select count(1) from fact_visitor_register where CREATE_DATE_KEY=20161111 and APPLICATION_KEY in (10,20)
 
select * from fact_page_view where 
