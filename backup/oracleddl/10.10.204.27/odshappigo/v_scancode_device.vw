???create or replace force view odshappigo.v_scancode_device as
select "VID","IP","VISIT_DATE","VISIT_DATE_KEY" from dw_user.SD_SCANCODE_DEVICE;

