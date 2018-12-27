???create or replace force view dw_user.t_liqiao_1 as
select  h2.member_crmbp,
case when h1.vid like   '%android%' then 'android'
  else 'iphone' end as app
 from temp_vid h1, fact_ecmember h2
where h1.member_id=h2.member_id;

