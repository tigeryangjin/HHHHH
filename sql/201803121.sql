select 'select * from ' || a.owner || '.' || a.table_name || ';'
  from all_all_tables a
 where a.owner = 'ML'
 ORDER BY A.table_name;

select *
  from all_all_tables a
 where a.owner = 'ML'
 ORDER BY A.table_name;
