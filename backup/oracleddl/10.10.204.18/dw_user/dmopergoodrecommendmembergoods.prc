???create or replace procedure dw_user.dmopergoodrecommendmembergoods(postday in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  min_day     number;
  max_day     number;
  garde_num   number;
  lsi         number;
  ls_total    number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：猜你喜欢底层数据层级表
       
  
  作者时间：bobo  2016-07-19
  */

begin
  sp_name          := 'dmopergoodrecommendmembergoods'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'oper_goodrecommend_m_fq'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
  --onetotal         := 50000; --一次取5000记录循环
  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0'
    then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;
  begin
    delete from oper_goodrecommend_m_fq
     where member_key in
           (select member_key
              from oper_goodrecommend_m_ls
             where rn between postday + 1 and postday + 1000);
    insert_rows := sql%rowcount;
    commit;
    s_etl.err_msg := s_etl.err_msg || to_char(sysdate, 'hh24miss');
    --计算用户的维度
  
    insert into oper_goodrecommend_m_fq
      (mat_status, member_key, item_code, preference, grade, matxl)
      (select 0 as mat_status, /*mat_status=0商品*/
              cc.member_key,
              cc.item_code,
              cc.user_preference as preference,
              (case
                when cc.rank <= 5 then
                 1
                when cc.rank <= 10 then
                 2
                else
                 3
              end) grade,
              g.matxl
         from (select member_key,
                      item_code,
                      user_preference,
                      RANK() OVER(PARTITION BY member_key order by user_preference desc, item_code desc) as RANK
                 from oper_goodrecommend_m_total
                where member_key in
                      (select member_key
                         from oper_goodrecommend_m_ls
                        where rn between postday + 1 and postday + 1000)
                  and item_code is not null
                order by member_key desc) cc
         left join dim_ec_good@dw_datalink g
           on g.item_code = cc.item_code
        where cc.rank <= 30);
    insert_rows := insert_rows + sql%rowcount;
    commit;
    s_etl.err_msg := s_etl.err_msg || '-' || to_char(sysdate, 'hh24miss');
    --全部用户的分类top3商品
    insert into oper_goodrecommend_m_fq
      (mat_status, member_key, item_code, preference, matxl, grade)
      (select 1 mat_status, /*mat_status=1分类*/
              cc.member_key,
              cc.item_code,
              cc.preference,
              cc.matxl,
              cc.grade
         from (select t.item_code,
                      t.matxl,
                      tt.member_key,
                      tt.preference,
                      tt.grade
                 from oper_goodrecommend_mat_top4 t
                inner join (select c.*,
                                  (case
                                    when rownum < 5 then
                                     1
                                    when rownum < 10 then
                                     2
                                    else
                                     3
                                  end) grade
                             from (select o.member_key,
                                          g.matxl,
                                          sum(o.pl_preference) preference,
                                          RANK() OVER(PARTITION BY o.member_key order by sum(o.pl_preference) desc, g.matxl desc) as RANK
                                     from oper_goodrecommend_m_total o
                                     left join dim_ec_good@dw_datalink g
                                       on o.item_code = g.item_code
                                    where o.member_key in
                                          (select member_key
                                             from oper_goodrecommend_m_ls
                                            where rn between postday + 1 and
                                                  postday + 1000)
                                    group by g.matxl, o.member_key
                                    order by sum(pl_preference) desc) c
                            where c.rank <= 15) tt
                   on t.matxl = tt.matxl) cc);
    insert_rows   := insert_rows + sql%rowcount;
    s_etl.err_msg := s_etl.err_msg || '-' || to_char(sysdate, 'hh24miss');
  
    if insert_rows > 0
    then
    
      delete from oper_goodrecommend_m_m;
      insert into oper_goodrecommend_m_m
        (member_key, rn)
        (select max(member_key) member_key, max(rn) rn
           from oper_goodrecommend_m_ls
          where rn between postday + 1 and postday + 1000);
    elsif postday != 0 and insert_rows = 0
    then
      delete from oper_goodrecommend_m_m;
    elsif insert_rows = 0 and postday = 0
    then
      delete from oper_goodrecommend_m_m;
      insert into oper_goodrecommend_m_m
        (member_key, rn)
        (select 0 member_key, 0 rn from dual);
    end if;
  
    s_etl.err_msg := s_etl.err_msg || '-' || postday;
  end;
  commit;
  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.etl_status     := 'SUCCESS';
  s_etl.etl_duration   := trunc((s_etl.end_time - s_etl.start_time) * 86400);
  sp_sbi_w_etl_log(s_etl);
  return;
exception
  when others then
    s_etl.end_time   := sysdate;
    s_etl.etl_status := 'FAILURE';
    s_etl.err_msg    := sqlerrm;
    sp_sbi_w_etl_log(s_etl);
    return;
end dmopergoodrecommendmembergoods;
/

