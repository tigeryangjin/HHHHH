select * from (
select VISIT_DATE_KEY,GC_NAME,count(distinct vid) as vid1 from (
select VISIT_DATE_KEY,vid,GC_NAME from (
select page_value,visit_date_key,vid from fact_page_view where visit_date_key between 20170901 and 20170931 and APPLICATION_KEY in (10,20)
and page_name='Good') aa  join(
select  GC_NAME,GOODS_COMMONID from (
select b.GC_NAME GC_NAME,to_char(GOODS_COMMONID) GOODS_COMMONID from dim_ec_good a left join   dim_good_class b  on a.MATZL=b.MATZL
) where GC_NAME is not null  group by GC_NAME,GOODS_COMMONID )bb on aa.page_value=bb.GOODS_COMMONID) group by VISIT_DATE_KEY,GC_NAME
) aaa join (

select VISIT_DATE_KEY,GC_NAME,count(distinct vid) as vid2 from (
select VISIT_DATE_KEY,vid,GC_NAME  from (
select page_value,visit_date_key,vid from fact_page_view_hit where visit_date_key between 20170901 and 20170931 and APPLICATION_KEY in (10,20)
and page_name in ('SL_Good_Shoppcar',
'SL_Good_Order')) aa join (
select  GC_NAME,GOODS_COMMONID from (
select b.GC_NAME GC_NAME,to_char(GOODS_COMMONID) GOODS_COMMONID from dim_ec_good a left join   dim_good_class b  on a.MATZL=b.MATZL
) where GC_NAME is not null  group by GC_NAME,GOODS_COMMONID )bb on aa.page_value=bb.GOODS_COMMONID) group by VISIT_DATE_KEY,GC_NAME
) bbb on aaa.VISIT_DATE_KEY=bbb.VISIT_DATE_KEY and aaa.GC_NAME=bbb.GC_NAME 
