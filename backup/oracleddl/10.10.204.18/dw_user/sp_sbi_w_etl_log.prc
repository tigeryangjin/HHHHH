???create or replace procedure dw_user.sp_sbi_w_etl_log(p_rec_row w_etl_log%rowtype) is
  v_rec_row w_etl_log%rowtype;
begin

  v_rec_row := p_rec_row;

  insert into w_etl_log values v_rec_row;
  commit;
end sp_sbi_w_etl_log;
/

