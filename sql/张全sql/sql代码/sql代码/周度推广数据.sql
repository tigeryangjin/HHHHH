-----海报推广 
select avg(日活), avg(注册), avg(订购)
  from (select count(distinct IP) 日活,
               count(distinct c.vid) 注册,
               count(distinct b.vid) 订购,
               VISIT_DATE_KEY
          from (select VID, IP, VISIT_DATE_KEY
                  from fact_page_view
                 where visit_date_key between
                       to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')
                   and (url like '%fo=HBTG%')
                 group by VID, IP, VISIT_DATE_KEY) a
          left join
        
         (select VID, FIST_IP, START_DATE_KEY
           from (select VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                   from fact_session
                  where START_DATE_KEY between
                        to_char(sysdate - 7, 'yyyymmdd') and
                        to_char(sysdate - 1, 'yyyymmdd')
                    and APPLICATION_KEY > 20) s
           join (select MEMBER_CRMBP, MEMBER_TIME
                  from fact_ecmember
                 where MEMBER_TIME between to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')) ss
             on s.MEMBER_KEY = ss.MEMBER_CRMBP
            and s.START_DATE_KEY = ss.MEMBER_TIME
          group by VID, FIST_IP, START_DATE_KEY) c
            on
        
         (a.ip = c.FIST_IP and a.VISIT_DATE_KEY = c.START_DATE_KEY)
          left join
        
         (select VID, ORDER_IP, add_time
           from factec_order
          where add_time between to_char(sysdate - 7, 'yyyymmdd') and
                to_char(sysdate - 1, 'yyyymmdd')
            and order_state > 10
          group by VID, ORDER_IP, add_time) b
            on (a.ip = b.ORDER_IP and a.VISIT_DATE_KEY = b.add_time)
         group by VISIT_DATE_KEY);
-----双屏互动 
select avg(日活), avg(注册), avg(订购)
  from (select count(distinct IP) 日活,
               count(distinct c.vid) 注册,
               count(distinct b.vid) 订购,
               VISIT_DATE_KEY
          from (select VID, IP, VISIT_DATE_KEY
                  from fact_page_view
                 where visit_date_key between
                       to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')
                   and (url like '%fo=SPHD%')
                 group by VID, IP, VISIT_DATE_KEY) a
          left join
        
         (select VID, FIST_IP, START_DATE_KEY
           from (select VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                   from fact_session
                  where START_DATE_KEY between
                        to_char(sysdate - 7, 'yyyymmdd') and
                        to_char(sysdate - 1, 'yyyymmdd')
                    and APPLICATION_KEY > 20) s
           join (select MEMBER_CRMBP, MEMBER_TIME
                  from fact_ecmember
                 where MEMBER_TIME between to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')) ss
             on s.MEMBER_KEY = ss.MEMBER_CRMBP
            and s.START_DATE_KEY = ss.MEMBER_TIME
          group by VID, FIST_IP, START_DATE_KEY) c
            on
        
         (a.ip = c.FIST_IP and a.VISIT_DATE_KEY = c.START_DATE_KEY)
          left join
        
         (select VID, ORDER_IP, add_time
           from factec_order
          where add_time between to_char(sysdate - 7, 'yyyymmdd') and
                to_char(sysdate - 1, 'yyyymmdd')
            and order_state > 10
          group by VID, ORDER_IP, add_time) b
            on (a.ip = b.ORDER_IP and a.VISIT_DATE_KEY = b.add_time)
         group by VISIT_DATE_KEY);

----短信  按周
select avg(日活), avg(注册), avg(订购)
  from (select count(distinct IP) 日活,
               count(distinct c.vid) 注册,
               count(distinct b.vid) 订购,
               VISIT_DATE_KEY
          from (select VID, IP, VISIT_DATE_KEY
                  from fact_page_view
                 where visit_date_key between
                       to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')
                   and (url like '%DXTX%')
                 group by VID, IP, VISIT_DATE_KEY) a
          left join
        
         (select VID, FIST_IP, START_DATE_KEY
           from (select VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                   from fact_session
                  where START_DATE_KEY between
                        to_char(sysdate - 7, 'yyyymmdd') and
                        to_char(sysdate - 1, 'yyyymmdd')
                    and APPLICATION_KEY > 20) s
           join (select MEMBER_CRMBP, MEMBER_TIME
                  from fact_ecmember
                 where MEMBER_TIME between to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')) ss
             on s.MEMBER_KEY = ss.MEMBER_CRMBP
            and s.START_DATE_KEY = ss.MEMBER_TIME
          group by VID, FIST_IP, START_DATE_KEY) c
            on
        
         (a.ip = c.FIST_IP and a.VISIT_DATE_KEY = c.START_DATE_KEY)
          left join
        
         (select VID, ORDER_IP, add_time
           from factec_order
          where add_time between to_char(sysdate - 7, 'yyyymmdd') and
                to_char(sysdate - 1, 'yyyymmdd')
            and order_state > 10
          group by VID, ORDER_IP, add_time) b
            on (a.ip = b.ORDER_IP and a.VISIT_DATE_KEY = b.add_time)
         group by VISIT_DATE_KEY);

-------按周  预约提醒 
select avg(日活), avg(注册), avg(订购)
  from (select count(distinct IP) 日活,
               count(distinct c.vid) 注册,
               count(distinct b.vid) 订购,
               VISIT_DATE_KEY
          from (select VID, IP, VISIT_DATE_KEY
                  from fact_page_view
                 where visit_date_key between
                       to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')
                   and (url like '%fo=YYTX%')
                 group by VID, IP, VISIT_DATE_KEY) a
          left join
        
         (select VID, FIST_IP, START_DATE_KEY
           from (select VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                   from fact_session
                  where START_DATE_KEY between
                        to_char(sysdate - 7, 'yyyymmdd') and
                        to_char(sysdate - 1, 'yyyymmdd')
                    and APPLICATION_KEY > 20) s
           join (select MEMBER_CRMBP, MEMBER_TIME
                  from fact_ecmember
                 where MEMBER_TIME between to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')) ss
             on s.MEMBER_KEY = ss.MEMBER_CRMBP
            and s.START_DATE_KEY = ss.MEMBER_TIME
          group by VID, FIST_IP, START_DATE_KEY) c
            on
        
         (a.VID = c.VID and a.VISIT_DATE_KEY = c.START_DATE_KEY)
          left join
        
         (select VID, ORDER_IP, add_time
           from factec_order
          where add_time between to_char(sysdate - 7, 'yyyymmdd') and
                to_char(sysdate - 1, 'yyyymmdd')
            and order_state > 10
          group by VID, ORDER_IP, add_time) b
            on (a.VID = b.VID and a.VISIT_DATE_KEY = b.add_time)
         group by VISIT_DATE_KEY);

------按周  微刊数据 
select avg(日活), avg(注册), avg(订购)
  from (select count(distinct IP) 日活,
               count(distinct c.vid) 注册,
               count(distinct b.vid) 订购,
               VISIT_DATE_KEY
          from (select VID, IP, VISIT_DATE_KEY
                  from fact_page_view
                 where visit_date_key between
                       to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')
                   and (url like '%wkzt%' or url like '%wksp%')
                 group by VID, IP, VISIT_DATE_KEY) a
          left join
        
         (select VID, FIST_IP, START_DATE_KEY
           from (select VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                   from fact_session
                  where START_DATE_KEY between
                        to_char(sysdate - 7, 'yyyymmdd') and
                        to_char(sysdate - 1, 'yyyymmdd')
                    and APPLICATION_KEY > 20) s
           join (select MEMBER_CRMBP, MEMBER_TIME
                  from fact_ecmember
                 where MEMBER_TIME between to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')) ss
             on s.MEMBER_KEY = ss.MEMBER_CRMBP
            and s.START_DATE_KEY = ss.MEMBER_TIME
          group by VID, FIST_IP, START_DATE_KEY) c
            on
        
         (a.ip = c.FIST_IP and a.VISIT_DATE_KEY = c.START_DATE_KEY)
          left join
        
         (select VID, ORDER_IP, add_time
           from factec_order
          where add_time between to_char(sysdate - 7, 'yyyymmdd') and
                to_char(sysdate - 1, 'yyyymmdd')
            and order_state > 10
          group by VID, ORDER_IP, add_time) b
            on (a.ip = b.ORDER_IP and a.VISIT_DATE_KEY = b.add_time)
         group by VISIT_DATE_KEY);

------DM单
select avg(日活), avg(注册), avg(订购)
  from (select count(distinct a.vid) 日活,
                count(distinct c.vid) 注册,
                count(distinct b.vid) 订购,
                VISIT_DATE_KEY
           from (select VID, START_DATE_KEY as VISIT_DATE_KEY
                   from (select *
                           from (select VID,
                                        substr(VID, 3, 200) vid1,
                                        START_DATE_KEY
                                   from fact_session
                                  where START_DATE_KEY between
                                        to_char(sysdate - 7, 'yyyymmdd') and
                                        to_char(sysdate - 1, 'yyyymmdd')
                                    and APPLICATION_KEY = 50
                                  group by substr(VID, 3, 200),
                                           START_DATE_KEY,
                                           VID) a
                           left join (select OPENID, CREATE_TIME
                                       from fact_wx_excode
                                      where CREATE_TIME between
                                            to_char(sysdate - 7, 'yyyymmdd') and
                                            to_char(sysdate - 1, 'yyyymmdd')) b
                             on a.vid1 = b.OPENID
                            and a.START_DATE_KEY = b.CREATE_TIME)
                  where OPENID is not null) a
           left join
         
          (select VID, FIST_IP, START_DATE_KEY
            from (select VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                    from fact_session
                   where START_DATE_KEY between
                         to_char(sysdate - 7, 'yyyymmdd') and
                         to_char(sysdate - 1, 'yyyymmdd')
                     and APPLICATION_KEY > 20) s
            join (select MEMBER_CRMBP, MEMBER_TIME
                   from fact_ecmember
                  where MEMBER_TIME between to_char(sysdate - 7, 'yyyymmdd') and
                        to_char(sysdate - 1, 'yyyymmdd')) ss
              on s.MEMBER_KEY = ss.MEMBER_CRMBP
             and s.START_DATE_KEY = ss.MEMBER_TIME
           group by VID, FIST_IP, START_DATE_KEY) c
             on
         
          a.VID = c.VID
       and a.VISIT_DATE_KEY = c.START_DATE_KEY
           left join
         
          (select VID, ORDER_IP, add_time
            from factec_order
           where add_time between to_char(sysdate - 7, 'yyyymmdd') and
                 to_char(sysdate - 1, 'yyyymmdd')
             and order_state > 10
           group by VID, ORDER_IP, add_time) b
             on (a.VID = b.VID and a.VISIT_DATE_KEY = b.add_time)
          group by VISIT_DATE_KEY);

--------扫码购

select (SELECT AVG(num1)
          from (select COUNT(DISTINCT VID) num1, visit_date_key
                  from fact_page_view
                 where visit_date_key between
                       to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')
                   and page_name = 'TV_QRC'
                 group by visit_date_key)) as 日活,
       
       (select count(distinct MEMBER_KEY) / 7
          from fact_session
         where START_DATE_KEY between to_char(sysdate - 7, 'yyyymmdd') and
               to_char(sysdate - 1, 'yyyymmdd')
           and vid in
               (select VID
                  from dim_vid_scan
                 where SCAN_DATE_KEY between to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd'))
           and MEMBER_KEY in
               (select MEMBER_CRMBP
                  from fact_ecmember
                 where MEMBER_TIME between to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd'))) as 注册人数,
       
       (SELECT AVG(num2)
          from (select count(distinct MEMBER_KEY) num2, add_time
                  from factec_order
                 where add_time between to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')
                   and order_state > 10
                   and order_from = 76
                 group by add_time)) as 订购人数
  from dual;

---整体流量
select (select avg(num1)
          from (select count(distinct vid) num1, START_DATE_KEY
                  from fact_session
                 where START_DATE_KEY between
                       to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')
                 group by START_DATE_KEY)) as 日活,
       (select count(1) / 7
          from fact_ecmember
         where MEMBER_TIME between to_char(sysdate - 7, 'yyyymmdd') and
               to_char(sysdate - 1, 'yyyymmdd')) as 注册人数,
       (SELECT AVG(num2)
          from (select count(distinct MEMBER_KEY) num2, add_time
                  from factec_order
                 where add_time between to_char(sysdate - 7, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')
                   and order_state > 10
                 group by add_time)) as 订购人数
  from dual;
