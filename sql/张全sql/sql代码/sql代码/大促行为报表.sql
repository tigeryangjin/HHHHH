------大促行为报表
declare
j int :=0;
begin
  while j<24 loop
 
  insert into  ls_test1(
select j as ssid,sname,s1,s2,s3 from (
select count(distinct vid) sname from fact_page_view where visit_date_key=20170112 and VISIT_HOUR<=j) a 
left join  
(
select count(distinct vid) s1 from fact_page_view where visit_date_key=20170113 and VISIT_HOUR<=j) b
on 1=1
left join  
(
select count(distinct vid) s2 from fact_page_view where visit_date_key=20170114 and VISIT_HOUR<=j) c
on 1=1
left join  
(
select count(distinct vid) s3 from fact_page_view where visit_date_key=20170115 and VISIT_HOUR<=j) d
on 1=1
);
  dbms_output.put_line(j);
  j:=j+1;
  end loop;
end;
------大促业绩报表
declare
j int :=0;
begin
  while j<24 loop
 
  insert into  ls_test1(
select j as ssid,sname,s1,s2,s3 from (
select sum(order_amount) sname from fact_ec_order where add_time=20170112 and  order_state>10 and to_char(ADDTIME,'hh24')<=j

)

 a 
left join  
(
select sum(order_amount) s1 from fact_ec_order where add_time=20170113 and  order_state>10 and to_char(ADDTIME,'hh24')<=j

) b
on 1=1
left join  
(
select sum(order_amount) s2 from fact_ec_order where add_time=20170114 and  order_state>10 and to_char(ADDTIME,'hh24')<=j

) c
on 1=1
left join  
(
select sum(order_amount) s3 from fact_ec_order where add_time=20170115 and  order_state>10 and to_char(ADDTIME,'hh24')<=j

) d
on 1=1
);
  dbms_output.put_line(j);
  j:=j+1;
  end loop;
end;




select * from  ls_test1


(
select sum(order_amount) s3 from fact_ec_order where add_time=20170125 and  order_state>10 and to_char(ADDTIME,'hh24')<=j

)
