???create or replace force view bdpuser.dim_vid_scan as
select "VID","SCAN_DATE_KEY","ACTIVE_DATE_KEY","IP","IS_NEW" from  dw_user.dim_vid_scan;

