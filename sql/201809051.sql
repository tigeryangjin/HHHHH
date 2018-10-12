declare
  i  date;
  i1 varchar2(100);

begin

  select nvl(max(t.end_time),
             to_date('2016-07-19 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
    into i
    from stats_online_good_minute t;

  select to_char(max(e.visit_date), 'yyyymmddhh24mi')
    into i1
    from fact_page_view e
   where e.visit_date_key = to_number(to_char(sysdate, 'yyyymmdd'))
     and e.page_key in (1924, 2841, 24146, 11586, 355, 38629)
     and e.ip_geo_key != 0;

  loop
  
    exit when to_number(to_char(i + 10 / 24 / 60, 'yyyymmddhh24mi')) >= to_number(i1);
    dbms_output.put_line(i);
    insert into stats_online_good_minute
      (id,
       statdate,
       stathour,
       statminute,
       start_time,
       end_time,
       application_key,
       application_name,
       good_code,
       good_name,
       pv,
       uv,
       rangepv,
       rangeuv)
    
      select w_statgd1_d_s.nextval as id,
             to_number(to_char(i + 10 / 24 / 60, 'yyyymmdd')) as statdate,
             to_number(to_char(i + 10 / 24 / 60, 'hh24')) as stathour,
             to_number(to_char(i + 10 / 24 / 60, 'mi')) as statminute,
             
             to_date(to_char(i, 'yyyy-mm-dd hh24:mi'),
                     'yyyy-mm-dd hh24:mi:ss') as start_time,
             to_date(to_char(i + 10 / 24 / 60, 'yyyy-mm-dd hh24:mi'),
                     'yyyy-mm-dd hh24:mi:ss') as end_time,
             
             x1.application_key,
             x1.application_name,
             (select j.item_code
                from dim_ec_good j
               where j.goods_commonid = to_number(case
                                                    when regexp_like(x1.page_value, '.([a-z]+|[A-Z])') then
                                                     '0'
                                                    when regexp_like(x1.page_value, '[[:punct:]]+') then
                                                     '0'
                                                  -- when regexp_like(x1.page_value, '[\u4e00-\u9fa5]+') then
                                                  --  '0'
                                                    when x1.page_value is null then
                                                     '0'
                                                    when x1.page_value like '%null%' then
                                                     '0'
                                                    else
                                                     regexp_replace(x1.page_value, '\s', '')
                                                  end)) as good_code,
             
             (select j.goods_name
                from dim_ec_good j
               where j.goods_commonid = to_number(case
                                                    when regexp_like(x1.page_value, '.([a-z]+|[A-Z])') then
                                                     '0'
                                                    when regexp_like(x1.page_value, '[[:punct:]]+') then
                                                     '0'
                                                  -- when regexp_like(x1.page_value, '[\u4e00-\u9fa5]+') then
                                                  --  '0'
                                                    when x1.page_value is null then
                                                     '0'
                                                    when x1.page_value like '%null%' then
                                                     '0'
                                                    else
                                                     regexp_replace(x1.page_value, '\s', '')
                                                  end)) as good_name,
             
             x1.rangepv,
             x1.rangeuv,
             x2.pv,
             x2.uv
        from (select n.application_key,
                     n.application_name,
                     n.page_value,
                     count(vid) as rangepv,
                     count(distinct vid) as rangeuv
                from fact_page_view n
               where n.page_key in (1924, 2841, 24146, 11586, 355, 38629)
                 and n.visit_date >= i
                 and n.visit_date < i + 10 / 24 / 60
                 and n.ip_geo_key != 0
               group by n.application_key, n.application_name, n.page_value) x1,
             
             (select n.application_key,
                     n.application_name,
                     n.page_value,
                     nvl(count(vid), 0) as pv,
                     nvl(count(distinct vid), 0) as uv
                from fact_page_view n
               where n.page_key in (1924, 2841, 24146, 11586, 355, 38629)
                 and n.visit_date >= trunc(sysdate) -- to_date(i, 'yyyy-mm-dd')
                 and n.visit_date < i + 10 / 24 / 60
                 and n.ip_geo_key != 0
               group by n.application_key, n.application_name, n.page_value) x2
       where x1.application_name = x2.application_name
         and x1.application_key = x2.application_key
         and x1.page_value = x2.page_value;
  
    commit;
  
    i := i + 10 / 24 / 60;
  
  end loop;

end;
