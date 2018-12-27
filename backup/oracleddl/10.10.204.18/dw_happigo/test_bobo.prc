???create or replace procedure dw_happigo.test_bobo(
       starttime in varchar,
       endtime in varchar
       --pagenum in int,
       --page in int
) is
total int;
--starts int;
--rows int;
vidid int;
begin
  --begin
    --if page<=1 then 
     -- starts:=0;
      --rows:=pagenum;
    --else
        --starts:=(page-1)*pagenum;
        --rows := pagenum*page;
   -- end if;  
  --end;
  
  total :=0;
  
  for i in (select vid,MEMBER_KEY,id from 
      (select fpv.* ,ROWNUM as rn from fact_page_view fpv where
        fpv.visit_date between to_date(starttime,'yyyy-mm-dd hh24:mi:ss')  
        and to_date(endtime,'yyyy-mm-dd hh24:mi:ss')
      ) p 
    --where p.rn between starts and rows
    ) loop
          
          select count(*) into vidid from bobo_test where vid=i.vid;
          if vidid>=1 then
            update bobo_test b set b.total=b.total+1 where vid=i.vid; 
            --DBMS_OUTPUT.put_line(vidid);
          else
            insert into bobo_test (name,id,vid,total) values (i.member_key,i.id,i.vid,1);
          end if;
          total:=total+1;
    end loop;
    commit;
    --total = 
    
    --if total>=1 then
     -- insert into (names,id,vid,title) value
     -- select 
    
    DBMS_OUTPUT.put_line(total);
exception
  
  when others then
    return;
end test_bobo;
/

