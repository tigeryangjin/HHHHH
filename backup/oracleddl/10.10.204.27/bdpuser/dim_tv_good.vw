???create or replace force view bdpuser.dim_tv_good as
select "ID","GOODS_COMMON_ID","ITEM_CODE","TV_NAME","TV_START_TIME","TV_END_TIME","P_START_TIME","P_END_TIME","TV_STARTDAY_KEY","IS_LIVE" from  dw_user.dim_tv_good;

