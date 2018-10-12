select count(distinct(vid)),VER_NAME,s.application_name from fact_page_view  s where  s.visit_date_key = 20161012
 and s.application_key in (10,20)
 group by VER_NAME,s.application_name 
 
 
 select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Small_ad'  --and s.page_value='home'
 and s.visit_date_key  between 20160901 and 20160930 group by visit_date_key
 --- 整体日活
  select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view  s where
   s.visit_date_key  between 20160923 and 20160930
 and s.application_key in (10,20)  and VER_NAME not in('6.8.0',' 6.8.1')
  and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 group by visit_date_key
 
 
 ----  新版本日活
 
 select count(distinct(vid)) ,visit_date_key from fact_page_view  s where
   s.visit_date_key  between 20161008 and 20161013
 and s.application_key in (10,20)  and VER_NAME in('6.8.0',' 6.8.1')  and 
 HMSC
  in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 group by visit_date_key
 
 ----  大眼睛数据
 select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Big_ad'  and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key  between 20161008 and 20161013 group by visit_date_key
 
 ---   小眼睛数据
 
  select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Small_ad'   and VER_NAME  in('6.8.0',' 6.8.1')
 and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key    between 20161008 and 20161013 group by visit_date_key
 
 ---  中间广告页
 
   select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Mediate_ad'   and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key   between 20161008 and 20161013 group by visit_date_key
 
 ---- 限时抢
 
   select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Flash_sale'  -- and VER_NAME  in('6.8.0',' 6.8.1')
  and s.page_value='0'
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key  between 20161008 and 20161013 group by visit_date_key
 
 
 
  select * from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Flash_sale'  -- and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key  between 20161008 and 20161013 group by visit_date_key
 
 ---新品上新
 
 
   select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='New_Good'  and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key  between 20161008 and 20161013 group by visit_date_key
 ---一周热卖
 

   select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Hot_Good'  and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key  between 20161008 and 20161013 group by visit_date_key
 
 --- 头条  Home_headlines
   select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Home_headlines'  and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key  between 20161008 and 20161013 group by visit_date_key
 
 ---TV直播  TV_liveplay
 
    select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='TV_liveplay'  and s.page_value='home'
   and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key  between 20161008 and 20161013 group by visit_date_key
 
 
 --网络直播 Web_liveplay
     select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Web_liveplay'  and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key  between 20161008 and 20161013 group by visit_date_key
 
 --更多视频 Web_livelist
     select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Web_livelist'  and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 and s.visit_date_key  between 20161008 and 20161013 group by visit_date_key
 
 
 ---节目表 TVPlayList
 
 
      select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) --and s.page_name='Home_TVLive' -- and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
 --  and s.last_page_key in(6404,6966)
 and s.visit_date_key  between 20161001 and 20161013 group by visit_date_key
 
 select count(1),count(distinct(vid)) ,visit_date_key  from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='Good'  
   and s.visit_date_key  between 20161001 and 20161013 
   and s.last_page_key in(1582,2855) group by visit_date_key

 
       select count(1),count(distinct(vid)) ,visit_date_key from fact_page_view s  where 
  s.application_key in(10,20) and s.page_name='TVPlayList' -- and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
   and s.last_page_key in(6404,6966)
 and s.visit_date_key  between 20160923 and 20160930 group by visit_date_key
 
 
 select (
 
( select count(distinct(vid)) from  fact_page_view s  where 
  s.application_key in(10,20) and   s.page_name='Mediate_ad' --and s.last_page_key in(6404,6966)
  and s.visit_date_key=20161003  --and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs'))
   
  / 
    
 (select count(distinct(vid)) from  fact_page_view s  where 
  s.application_key in(10,20) --and  s.page_name='Video_home' 
  and s.visit_date_key=20161003 -- and VER_NAME  in('6.8.0',' 6.8.1')
   and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs'))) from dual
   
   
   select * FROM dim_tv_good
