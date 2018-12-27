???create or replace force view bdpuser.v_dim_vid_mem as
select "VID","MEMBER_KEY","CREATE_DATE_KEY","APPLICATION_KEY" from  dw_user.dim_vid_mem;

