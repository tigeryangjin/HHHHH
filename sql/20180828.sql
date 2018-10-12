select event, blocking_session, sql_id, count(*)
  from dba_hist_active_sess_history ash
 where sample_time >=
       to_timestamp('2018-08-25 22:25:00', 'yyyy-mm-dd hh24:mi:ss')
   and sample_time <=
       to_timestamp('2018-08-28 09:35:00', 'yyyy-mm-dd hh24:mi:ss')
   and event in ('cursor: pin S wait on X', 'cursor: mutex S')
 group by event, blocking_session, sql_id;

select event, blocking_session, sql_id, count(*)
  from dba_hist_active_sess_history ash
 where sample_time >=
       to_timestamp('2018-08-27 22:25:00', 'yyyy-mm-dd hh24:mi:ss')
   and sample_time <=
       to_timestamp('2018-08-28 09:35:00', 'yyyy-mm-dd hh24:mi:ss')
   and ash.session_id = 2
 group by event, blocking_session, sql_id;

7af8amaxth0y4 g9nw2tnsscym2 dz3pgv3chghrr 9h5wsruq1gs20
