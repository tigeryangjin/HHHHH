select *
  from w_etl_log a
 where a.proc_name = 'process3gpromotion'
 order by a.start_time desc;

select *
  from w_etl_log a
 where a.proc_name = 'processmblabelsource'
 order by a.start_time desc;
 
begin
  -- Call the procedure
  processmblabelsource(20181008);
end;
