-------扫码落地页 11~12
select sum(num1)/count(1)*1.1 from (
select  count(distinct(vid)) num1,SCAN_DATE_KEY  from dim_vid_scan where SCAN_DATE_KEY  between 20170101 and 20170228
and  VID like '%wxoeNKj%'
group by SCAN_DATE_KEY)


------扫码落地页 3~5
select sum(num1)/count(1)*1.1 from (
select  count(distinct(vid)) num1,SCAN_DATE_KEY  from dim_vid_scan where SCAN_DATE_KEY between 20170301 and 20170531
and  VID like '%wxoeNKj%'
group by SCAN_DATE_KEY)


-----------------APP订购 11~12
select sum(num1)/count(1) from (
select  count(distinct(vid)) num1,SCAN_DATE_KEY  from dim_vid_scan where SCAN_DATE_KEY between 20170101 and 20170228
and ( VID like '%iphone%'  or  VID like '%android%')
and IS_NEW=0
and ip in (
select IP from (
select IP,count(distinct(vid)) num from dim_vid_scan where  SCAN_DATE_KEY between 20170101 and 20170228
and ( VID like '%iphone%'  or  VID like '%android%')
group by  IP) where NUM<50)
group by SCAN_DATE_KEY)

---------------APP订购 3~5
select sum(num1)/count(1) from (
select  count(distinct(vid)) num1,SCAN_DATE_KEY  from dim_vid_scan where SCAN_DATE_KEY  between 20170301 and 20170531
and ( VID like '%iphone%'  or  VID like '%android%')
group by SCAN_DATE_KEY)


----- APP订购 11~12 （新）

select sum(num1)/count(1) from (
select  count(distinct(vid)) num1,SCAN_DATE_KEY  from dim_vid_scan where SCAN_DATE_KEY  between 20161101 and 20161231
and ( VID like '%iphone%'  or  VID like '%android%')
and IS_NEW=1

group by SCAN_DATE_KEY)

---------------APP订购 3~5 （新）
select sum(num1)/count(1) from (
select  count(distinct(vid)) num1,SCAN_DATE_KEY  from dim_vid_scan where SCAN_DATE_KEY  between 20170301 and 20170531
and ( VID like '%iphone%'  or  VID like '%android%')
and IS_NEW=1
group by SCAN_DATE_KEY)



--------APP 提交订单页  3~5   （新）
select sum(nums)/count(1) from 
(select SCAN_DATE_KEY,count(distinct(vid)) nums from (
select a.vid vid,SCAN_DATE_KEY,visit_date_key from 
(
-----调整部分
select  vid ,SCAN_DATE_KEY  from dim_vid_scan where SCAN_DATE_KEY  between 20170101 and 20170228
and ( VID like '%iphone%'  or  VID like '%android%')
and ip in (
select IP from (
select IP,count(distinct(vid)) num from dim_vid_scan where  SCAN_DATE_KEY between 20170101 and 20170228
and ( VID like '%iphone%'  or  VID like '%android%')
group by  IP) where NUM<50)
and IS_NEW=0
-----调整部分
) a
left join 
(
select  vid,visit_date_key  from fact_page_view where visit_date_key   between 20170101 and 20170228

and page_name='OrderConfirm' and APPLICATION_KEY in (10,20) 
) b  ON  a.vid=b.vid and a.SCAN_DATE_KEY=b.visit_date_key) where visit_date_key is not null
group by SCAN_DATE_KEY)


-----APP 总订购  3~5   

select sum(nums)/count(1) from 
(select SCAN_DATE_KEY,count(distinct(member_key)) nums from (
select a.vid vid,SCAN_DATE_KEY,add_time,member_key from 
(
-----调整部分
select  vid ,SCAN_DATE_KEY  from dim_vid_scan where SCAN_DATE_KEY between 20170301 and 20170528
--and ( VID like '%iphone%'  or  VID like '%android%')
---and IS_NEW=1
-----调整部分
) a
left join 
(
select  VID,add_time,member_key from factec_order where add_time   between 20170301 and 20170528
 --and ORDER_FROM in (61,63) 
) b  ON  a.vid=b.vid and a.SCAN_DATE_KEY=b.add_time) where add_time is not null
group by SCAN_DATE_KEY)



-----APP 总订购  3~5   

select sum(nums)/count(1),sum(order_amount)/count(1) from 
(select SCAN_DATE_KEY,count(distinct(vid)) nums,sum(order_amount)  order_amount from (
select a.vid vid,SCAN_DATE_KEY,add_time,order_amount from 
(
-----调整部分
select  vid ,SCAN_DATE_KEY  from dim_vid_scan where SCAN_DATE_KEY  between 20170101 and 20170228
and ( VID like '%iphone%'  or  VID like '%android%'  )
--and vid like '%wxoeNK%'
and IS_NEW=0
and ip in (
select IP from (
select IP,count(distinct(vid)) num from dim_vid_scan where  SCAN_DATE_KEY between 20170101 and 20170228
and ( VID like '%iphone%'  or  VID like '%android%')
group by  IP) where NUM<50)
-----调整部分
) a
left join 
(
select  VID,add_time,sum(order_amount)  order_amount from factec_order where add_time   between 20170101 and 20170228
 --and ORDER_FROM in (76) 
 --and order_state>10
 group by  VID,add_time
) b  ON  a.vid=b.vid and a.SCAN_DATE_KEY=b.add_time) where add_time is not null
group by SCAN_DATE_KEY)




--------微信提交订单页  3~5   （新）
select sum(nums)/count(1) from 
(select SCAN_DATE_KEY,count(distinct(member_key)) nums from (
select a.vid vid,SCAN_DATE_KEY,visit_date_key,member_key from 
(
-----调整部分
select  vid ,SCAN_DATE_KEY  from dim_vid_scan where SCAN_DATE_KEY    between 20170301 and 20170531
--and ( VID like '%iphone%'  or  VID like '%android%')
--and IS_NEW=1
-----调整部分
) a
left join 
(
select  vid,visit_date_key,member_key  from fact_page_view where visit_date_key    between 20170301 and 20170531

and page_name='SL_TV_TVplay' and APPLICATION_KEY in (10,20,50) 
) b  ON  a.vid=b.vid and a.SCAN_DATE_KEY=b.visit_date_key) where visit_date_key is not null
group by SCAN_DATE_KEY)
-----
select count(distinct(vid)) from fact_page_view where visit_date_key=20170607

and page_name='SL_TV_TVplay'


select count(distinct(MEMBER_KEY)) from factec_order where ADD_TIME between 20170501 and 20170531
and MEMBER_KEY in (
select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME between 20170501 and 20170531)
and ORDER_STATE>10


10348  32808

select count(MEMBER_CRMBP) from fact_ecmember where MEMBER_TIME between 20170501 and 20170531


select * from fact_order where  ORDER_DATE_KEY=20170608


DIM_VID_SCAN
