???create or replace force view dw_happigo.pv_goods2 as
select u1.page_view_key, u1.visit_date_key,u1.application_key,u1.hmsc_key,u1.page_key, u1.page_name,
u1.hour_key,u1.page_staytime_key,u1.visitor_key,u1.member_key,u1.ip_geo_key,u1.channel_key, u2.goods_code,u2.goods_name,
u2.matkl
 from fact_page_view u1,dim_goods u2
 where (u1.page_name='good' or u1.page_name='Good') and u1.page_value is not null
       and u1.page_value=u2.goods_code1;

