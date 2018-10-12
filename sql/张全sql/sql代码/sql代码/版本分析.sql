  ---------  7.0.0  求用户黏度
    SELECT SUM(exp(CHI)),page_name,SUM(exp(3))  FROM (
       SELECT COUNT(1) AS CHI,page_name,VID FROM (
         select  ssd.page_name,ssd.visit_date_key,VID from fact_page_view  ssd
      where ssd.visit_date_key  between 20170224 and 20170302
      and ssd.application_key  in(10,20) and VER_NAME in ('7.0.0','7.0.2','7.0.4')
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm')
         group by ssd.page_name,ssd.visit_date_key,VID)
   
       GROUP BY page_name,VID)  GROUP BY page_name
       
      ------------ 7.0.0版本板块状态
    
     select  count(1),count(distinct(vid)),ssd.page_name,ssd.visit_date_key from fact_page_view  ssd
      where ssd.visit_date_key   between  20170224 and 20170302
      and ssd.application_key  in(10,20) and VER_NAME in ('7.0.0','7.0.2','7.0.4') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm','vivo')
  
    group by ssd.page_name,ssd.visit_date_key
    
          ------------ 7.0.0版本停留时长
    
     select  sum(PAGE_STAYTIME),count(distinct(vid)),ssd.visit_date_key from fact_page_view  ssd
      where ssd.visit_date_key   between  20170224 and 20170302
      and ssd.application_key  in(10,20) and VER_NAME in ('7.0.0','7.0.2','7.0.4') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm','vivo')
  
    group by ssd.visit_date_key
    
    ----  B2C_ ICON
    
    
      select  PAGE_VALUE,count(distinct(vid)),ssd.visit_date_key from fact_page_view  ssd
      where ssd.visit_date_key   between  20170224 and 20170302
      AND PAGE_NAME='LS_B2C_Icon'
      and ssd.application_key  in(10,20) and VER_NAME in ('7.0.0','7.0.2','7.0.4') 
      and hmsc in('as','hw','klg','t360','oppo','wdj','xm','vivo')
  
    group by ssd.visit_date_key,PAGE_VALUE
   ----- 
   
   select SNAME from ls_test1
   
   select count(1),sum(ORDER_AMOUNT),VID from factec_order where  ADD_TIME between 20170201 and 20170228 
   and vid in (   select SNAME from ls_test1  )
   and  order_state>10
   and  order_from=76
   group by VID
   
   -----
   
   select VIDSCORE,count(1) from  abpage_vidscore
   
   group by VIDSCORE
   ----
   select  count(distinct(vid)) from fact_page_view where visit_date_key  
    between  20170306 and 20170306  and application_key in (10,20)
  and (page_name like '%SL_TV_%' or  page_name='TVPlayList' )
    and vid in (select vid from abpage_vidscore where VIDSCORE>6 )
    and vid in  (  select vid from (select  vid,count(1) num from  fact_page_view where visit_date_key  
    between  20170306 and 20170306 and application_key in (10,20)
     group  by  vid) where num>5  ) ---排除单纯签到或跳失用户
   ----会员
    SELECT MEMSCORE,count(1) FROM abpage_memscore WHERE MEMBER_KEY IN(
    select member_key from fact_page_view where visit_date_key  
    between  20170306 and 20170306  and application_key in (10,20)
    and (page_name like '%SL_TV_%' or  page_name='TVPlayList' )
    ---and member_key in (select MEMBER_KEY from abpage_memscore where MEMSCORE>10 )
    and vid in  (  select vid from (select  vid,count(1) num from  fact_page_view where visit_date_key  
    between  20170306 and 20170306 and application_key in (10,20)
     group  by  vid) where num>5  ) ---排除单纯签到或跳失用户
     GROUP BY MEMBER_KEY)
     group by MEMSCORE
     
     select * from dim_member_base
   where  MEMBER_BP in 
   ( select member_key from fact_page_view where visit_date_key  
    between  20170306 and 20170306  and application_key in (10,20)
    and (page_name like '%SL_TV_%' or  page_name='TVPlayList' )
    ---and member_key in (select MEMBER_KEY from abpage_memscore where MEMSCORE>10 )
    and vid in  (  select vid from (select  vid,count(1) num from  fact_page_view where visit_date_key  
    between  20170306 and 20170306 and application_key in (10,20)
     group  by  vid) where num>5  ) ---排除单纯签到或跳失用户
     GROUP BY MEMBER_KEY)
     and MEMBER_BP in (
     select MEMBER_KEY from abpage_memscore where MEMSCORE in(-2)
     )
 
select
* from fact_daily_goodzaijia


SELECT * from fact_page_view where visit_date_key=20170303 and page_name like '%Video%'

select * from dim_tv_good

select FIRST_ORDER_DATE_KEY,count(distinct(MEMBER_BP)),sum(ORDER_AMOUNT),sum(ORDER_NUMS) from (
select MEMBER_BP,FIRST_ORDER_DATE_KEY,ORDER_AMOUNT,ORDER_NUMS from (
select MEMBER_BP,FIRST_ORDER_DATE_KEY from dim_member 
where FIRST_ORDER_DATE_KEY between  20160901  and 20170307
) s left join 
(select sum(ORDER_AMOUNT) ORDER_AMOUNT,sum(ORDER_NUMS) ORDER_NUMS,MEMBER_KEY,ORDER_DATE_KEY from  fact_order where ORDER_DATE_KEY between  20160901  and 20170307 and SALES_SOURCE_KEY=20
and ORDER_STATE=1 
group by MEMBER_KEY,ORDER_DATE_KEY ) b on s.member_bp=b.MEMBER_KEY and s.FIRST_ORDER_DATE_KEY=b.ORDER_DATE_KEY
) 
where  ORDER_AMOUNT is not null 
 group by FIRST_ORDER_DATE_KEY
 
 
 select  *  from abpage_vidscore   where vid='iphonefed4769ebddd23f47f68102485c9f1a0e858e1a6' 
 
 VIDSCORE>0
 
 select page_name,count(distinct(vid)) from fact_page_view where visit_date_key between 20170307 and 20170307 and vid in (
 select vid from abpage_vidscore where VIDSCORE>0)
  and vid in  (  select vid from (select  vid,count(1) num from  fact_page_view where visit_date_key  
    between  20170307 and 20170307 and application_key in (10,20)
     group  by  vid) where num>5  ) 
 group by page_name
 
 
 
 select *  from dim_tv_good where TV_STARTDAY_KEY=20170306
 
 
SELECT
to_date(visit_date_key ,'YYYY-MM-DD HH24:MI:ss')    统计日期,
 count(distinct(vid))*-1   总访问次数,
 count(1)*-1   总访问人数,
 APPLICATION_NAME  应用渠道名称
  from fact_page_view 
  where
    visit_date_key=to_char(sysdate,'yyyymmdd')
  and  APPLICATION_key=30  
 and page_name in ('appdownload','TV_QRC') 
 group by APPLICATION_NAME,visit_date_key;   
 
 select * from fact_goods_sales
