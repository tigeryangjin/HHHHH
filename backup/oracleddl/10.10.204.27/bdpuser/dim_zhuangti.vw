???create or replace force view bdpuser.dim_zhuangti as
select "ZT_ID","ZT_NAME","ADD_DATE_KEY","ZTTYPEID","ZTTYPENM","END_DATE_KEY","KEY" from dw_user.DIM_ZHUANGTI;

