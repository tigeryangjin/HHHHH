???create or replace procedure dw_user.processmatch is
begin

  declare
  
    type type_array is table of tmp_0228%rowtype index by binary_integer;
    cnt1      number;
    o_id      varchar2(50);
    var_array type_array;
  
  begin
  
    select * bulk collect into var_array from tmp_0228 e order by e.id;
  
    for i in 1 .. var_array.count loop
    
      select count(1)
        into cnt1
        from dim_wechat a
       where a.nickname = var_array(i).nickname;
    
      if cnt1 = 1 then
      
        select a.open_id
          into o_id
          from dim_wechat a
         where a.nickname = var_array(i).nickname;
      
        update tmp_0228 b
           set b.flag = 1, b.openid = o_id
         where b.id = var_array(i).id;
        commit;
      else
        update tmp_0228 b set b.flag = 0 where b.id = var_array(i).id;
        commit;
      end if;
    end loop;
  end;
end processmatch;
/

