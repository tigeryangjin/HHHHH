???create or replace procedure dw_user.dmopergoodrecommendmember(postday in number) is
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

  sp_name          := 'dmopergoodrecommendmember'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'oper_goodrecommend_m_page'; --此处需要手工录入该PROCEDURE操作的表格
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
  s_etl.err_msg := '开始时间:' || to_char(sysdate, 'hh24miss');
  delete from oper_goodrecommend_m_page where day_KEY = postday;

  insert into oper_goodrecommend_m_page
    (item_code,
     member_key,
     pv_nums,
     cart_nums,
     fav_nums,
     day_key,
     order_nums,
     cancel_nums)
    (select (case
              when jp.item_code is not null then
               jp.item_code
              when jp2.item_code is not null then
               jp2.item_code
              when jp3.item_code is not null then
               jp3.item_code
              else
               jp4.item_code
            end) as item_code,
            (case
              when jp.member_key is not null then
               jp.member_key
              when jp2.member_key is not null then
               jp2.member_key
              when jp3.member_key is not null then
               jp3.member_key
              else
               jp4.member_key
            end) as member_key,
            sum(case
                  when jp.pv_nums is not null then
                   jp.pv_nums
                  else
                   0
                end) pv_nums,
            sum(case
                  when jp3.total is not null then
                   jp3.total
                  else
                   0
                end) cart_nums,
            sum(case
                  when jp4.nums is not null then
                   jp4.nums
                  else
                   0
                end) fav_nums,
            postday as day_key,
            sum(case
                  when jp2.TODAY_NUMS is not null then
                   jp2.TODAY_NUMS
                  else
                   0
                end) order_NUMS,
            sum(case
                  when jp2.CANCEL_NUMS is not null then
                   jp2.CANCEL_NUMS
                  else
                   0
                end) CANCEL_NUMS
       from (
             
             --会员的商品浏览数据 
             select p.member_key, g.item_code, p.pv_nums
               from (select member_key, page_value, count(1) as pv_nums
                        from fact_page_view@dw_datalink
                       where visit_date_key = postday
                         and member_key != 0
                         and page_name = 'Good'
                         and trim(translate(nvl(page_value, 'x'),
                                            '0123456789',
                                            ' ')) is NULL
                       group by member_key, page_value) p
               left join dim_ec_good@dw_datalink g
                 on p.page_value = g.goods_commonid) jp
       full join (
                 --ec订购数据统计
                 select g.item_code,
                         o.member_key,
                         sum(case
                               when o.add_time = postday then
                                g.goods_num
                               else
                                0
                             end) TODAY_NUMS,
                         sum(case
                               when o.last_time_key = postday and
                                    o.order_state = 0 then
                                g.goods_num
                               else
                                0
                             end) CANCEL_NUMS
                   from factec_order_goods@dw_datalink g
                   left join factec_order@dw_datalink o
                     on o.order_id = g.order_id
                  where add_time = postday
                     or last_time_key = postday
                  group by g.item_code, o.member_key) jp2
         on jp.item_code = jp2.item_code
        and jp.member_key = jp2.member_key
       full join (
                 --加购物车
                 select item_code, member_key, sum(nums) as total
                   from ((select g.item_code, p.member_key, p.nums
                             from (select scgid, member_key, sum(scgq) nums
                                     from fact_shoppingcar@dw_datalink
                                    where create_date_key = postday
                                      and application_key != 10
                                      and member_key != 0
                                      and scgq > 0
                                    group by scgid, member_key) p
                             left join dim_ec_good@dw_datalink g
                               on p.scgid = g.goods_commonid)
                         
                          union
                         
                          (select g.item_code,
                                  p.member_key,
                                  sum(p.nums) as nums
                             from (select scgid, member_key, sum(scgq) nums
                                     from fact_shoppingcar@dw_datalink
                                    where create_date_key = postday
                                      and application_key = 10
                                      and member_key != 0
                                      and scgq > 0
                                    group by scgid, member_key) p
                             left join dim_ec_goods@dw_datalink g
                               on p.scgid = g.goods_id
                            group by g.item_code, p.member_key))
                  group by item_code, member_key) jp3
         on jp2.item_code = jp3.item_code
        and jp2.member_key = jp3.member_key
       full join (
                 --收藏
                 select g.item_code,
                         m.member_crmbp as member_key,
                         count(1) as nums
                   from fact_favorites@dw_datalink f
                   left join dim_ec_good@dw_datalink g
                     on f.fav_id = g.goods_commonid
                   left join fact_ecmember@dw_datalink m
                     on f.member_id = m.member_id
                  where f.fav_time = postday
                    and f.fav_type = 'goods'
                    and m.member_crmbp > 0
                  group by g.item_code, m.member_crmbp) jp4
         on jp2.item_code = jp4.item_code
        and jp2.member_key = jp4.member_key
     
      group by (case
                 when jp.item_code is not null then
                  jp.item_code
                 when jp2.item_code is not null then
                  jp2.item_code
                 when jp3.item_code is not null then
                  jp3.item_code
                 else
                  jp4.item_code
               end),
               (case
                 when jp.member_key is not null then
                  jp.member_key
                 when jp2.member_key is not null then
                  jp2.member_key
                 when jp3.member_key is not null then
                  jp3.member_key
                 else
                  jp4.member_key
               end));

  insert_rows := sql%rowcount;
  commit;

  s_etl.err_msg := s_etl.err_msg || ',每日数据:' ||
                   to_char(sysdate, 'hh24miss');
  if insert_rows > 0
  then
    /*
    select o.member_key,o.item_code,sum(o.pv_nums) as pv_total,
                        sum(o.cart_nums) as cart_total,sum(o.fav_nums) as fav_total, 
                        sum(o.order_nums) as order_total,sum(o.cancel_nums) as cancel_total,
                        (sum(o.pv_nums)+sum(o.fav_nums)*3+sum(o.cart_nums)*5-(sum(o.order_nums)-sum(o.cancel_nums))*15) as USER_PREFERENCE,
                        (sum(o.pv_nums)+sum(o.fav_nums)*3+sum(o.cart_nums)*5+(sum(o.order_nums)-sum(o.cancel_nums))*15) as PL_PREFERENCE from fact_member_page_order o left join (
                        
                   select cc.member_key,min(cc.day_key) min_day,max(cc.day_key) max_day from (
                   select * from (     
                        SELECT  a.*,
                      RANK() OVER (PARTITION BY a.member_key order by a.day_key,a.member_key desc) as RANK
                      FROM (select member_key,day_key from fact_member_page_order group by member_key,day_key) a join 
                      (select member_key from fact_member_page_order where day_key=postday group by member_key) b on a.member_key=b.member_key)
                      c where c.rank<=15) cc group by cc.member_key) q on o.member_key=q.member_key
                      where o.day_key>=q.min_day and o.day_key<=max_day
                      group by o.item_code,o.member_key
    */
    --全部用户15日内的数据统计
    begin
      declare
        type type_arrays is record(
          member_key number(20));
      
        type type_array is table of type_arrays index by binary_integer; --类似二维数组 
      
        var_array type_array;
      begin
        select p.*
          bulk collect
          into var_array
          from (select member_key
                  from oper_goodrecommend_m_page
                 where day_key = postday
                 group by member_key) p;
      
        for i in 1 .. var_array.count loop
          select p.max_day
            into max_day
            from (select to_number(max(daykey)) max_day,
                         to_number(min(daykey)) min_day
                    from (select distinct (day_key) as daykey
                            from oper_goodrecommend_m_page
                           where member_key = var_array(i).member_key
                           order by day_key desc)
                   where rownum <= 15) p;
        
          select p.min_day
            into min_day
            from (select to_number(max(daykey)) max_day,
                         to_number(min(daykey)) min_day
                    from (select distinct (day_key) as daykey
                            from oper_goodrecommend_m_page
                           where member_key = var_array(i).member_key
                           order by day_key desc)
                   where rownum <= 15) p;
        
          merge into oper_goodrecommend_m_total m --fzq1表是需要更新的表
          using (select var_array(i).member_key as member_key,
                        item_code,
                        sum(pv_nums) as pv_total,
                        sum(cart_nums) as cart_total,
                        sum(fav_nums) as fav_total,
                        sum(order_nums) as order_total,
                        sum(cancel_nums) as cancel_total,
                        (sum(pv_nums) + sum(fav_nums) * 3 +
                        sum(cart_nums) * 5 -
                        (sum(order_nums) - sum(cancel_nums)) * 15) as USER_PREFERENCE,
                        (sum(pv_nums) + sum(fav_nums) * 3 +
                        sum(cart_nums) * 5 +
                        (sum(order_nums) - sum(cancel_nums)) * 15) as PL_PREFERENCE /*品类权重*/
                   from oper_goodrecommend_m_page
                  where day_key between min_day and max_day
                    and member_key = var_array(i).member_key
                  group by item_code) mm -- 关联表
          on (m.member_key = mm.member_key and m.item_code = mm.item_code) --关联条件
          when matched then --匹配关联条件，作更新处理
            update
               set m.pv_total        = mm.pv_total,
                   m.cart_total      = mm.cart_total,
                   m.fav_total       = mm.fav_total,
                   m.order_total     = mm.order_total,
                   m.cancel_total    = mm.cancel_total,
                   m.USER_PREFERENCE = mm.USER_PREFERENCE,
                   m.PL_PREFERENCE   = mm.PL_PREFERENCE,
                   m.UPDATE_DATE_KEY = postday
          when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
            insert
              (member_key,
               item_code,
               pv_total,
               cart_total,
               fav_total,
               order_total,
               cancel_total,
               USER_PREFERENCE,
               PL_PREFERENCE,
               UPDATE_DATE_KEY)
            values
              (mm.member_key,
               mm.item_code,
               mm.pv_total,
               mm.cart_total,
               mm.fav_total,
               mm.order_total,
               mm.cancel_total,
               mm.USER_PREFERENCE,
               mm.PL_PREFERENCE,
               postday);
          --此处只是说明可以同时更新多个字段。
        end loop;
      end;
    end;
    s_etl.err_msg := s_etl.err_msg || ',用户总量数据数据:' ||
                     to_char(sysdate, 'hh24miss');
    /* merge into fact_member_page_order_total m --fzq1表是需要更新的表
    using (select o.member_key,o.item_code,sum(o.pv_nums) as pv_total,
               sum(o.cart_nums) as cart_total,sum(o.fav_nums) as fav_total, 
               sum(o.order_nums) as order_total,sum(o.cancel_nums) as cancel_total,
               (sum(o.pv_nums)+sum(o.fav_nums)*3+sum(o.cart_nums)*5-(sum(o.order_nums)-sum(o.cancel_nums))*15) as USER_PREFERENCE,
               (sum(o.pv_nums)+sum(o.fav_nums)*3+sum(o.cart_nums)*5+(sum(o.order_nums)-sum(o.cancel_nums))*15) as PL_PREFERENCE from fact_member_page_order o inner join (
             select a.member_key,min(a.day_key) min_day,max(a.day_key) max_day
             from (
             select member_key,day_key,RANK() OVER (PARTITION BY member_key order by day_key desc) as RANK 
             from fact_member_page_order 
             where member_key in (select member_key from fact_member_page_order where day_key=postday group by member_key)
             group by member_key,day_key)a where a.rank<=15 group by a.member_key) q on o.member_key=q.member_key
             where o.day_key>=q.min_day and o.day_key<=max_day
             group by o.item_code,o.member_key) mm -- 关联表
     on (m.member_key = mm.member_key and m.item_code = mm.item_code) --关联条件
     when matched then --匹配关联条件，作更新处理
         update
            set m.pv_total                      = mm.pv_total,
                m.cart_total                    = mm.cart_total,
                m.fav_total                     = mm.fav_total,
                m.order_total                   = mm.order_total,
                m.cancel_total                  = mm.cancel_total,
                m.USER_PREFERENCE                  = mm.USER_PREFERENCE,
                m.PL_PREFERENCE                  = mm.PL_PREFERENCE,
                m.UPDATE_DATE_KEY                = postday
          when not matched then    --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
          insert (member_key,item_code,pv_total,cart_total,fav_total,order_total,cancel_total,USER_PREFERENCE,PL_PREFERENCE,UPDATE_DATE_KEY) values
          ( mm.member_key,mm.item_code,mm.pv_total,mm.cart_total,mm.fav_total,mm.order_total,mm.cancel_total,mm.USER_PREFERENCE,mm.PL_PREFERENCE,postday);       
       --此处只是说明可以同时更新多个字段。*/
    commit;
  
    begin
      EXECUTE IMMEDIATE 'truncate table oper_goodrecommend_m_ls';
    end;
  
    --保存member_key,rn
    insert into oper_goodrecommend_m_ls
      (member_key, rn)
      (select p.member_key, rownum rn
         from (select member_key
                 from oper_goodrecommend_m_page
                where day_key = postday
                group by member_key) p);
  
    --初始化rn
    delete from oper_goodrecommend_m_m;
    insert into oper_goodrecommend_m_m
      (member_key, rn)
      (select 0 member_key, 0 rn from dual);
    /*
      begin
      lsi :=0;
      select count(1) into ls_total from fact_member_ec_goods_sales_ls;
      
      begin
      while lsi <= ls_total loop
        delete from fact_member_ec_goods_sales_fq where member_key in 
        (select member_key from fact_member_ec_goods_sales_ls where rn between lsi+1 and lsi+1000);
         commit;
         s_etl.err_msg := s_etl.err_msg||to_char(sysdate,'hh24miss');
         --计算用户的维度
                insert into fact_member_ec_goods_sales_fq
                (mat_status,member_key,item_code,preference,grade,matxl)
                (select 0 as mat_status,cc.member_key,cc.item_code,cc.user_preference as preference,(case when cc.rank<=5 then 1 when cc.rank<=10 then 2 else 3 end) grade,g.matxl from (
                                        select member_key,item_code,user_preference,
                                        RANK() OVER (PARTITION BY member_key order by user_preference desc,item_code desc) as RANK 
                                        from fact_member_page_order_total where member_key
                                        in (select member_key from fact_member_ec_goods_sales_ls where rn between lsi+1 and lsi+1000)
                                        and item_code is not null
                                        order by member_key desc)
                                        cc left join dim_ec_good g on g.item_code=cc.item_code where cc.rank<=30);
                                        commit;
      s_etl.err_msg := s_etl.err_msg||'-'||to_char(sysdate,'hh24miss');
         --全部用户的分类top3商品
      insert into fact_member_ec_goods_sales_fq
                        (mat_status,member_key,item_code,preference,matxl,grade)
                        (select 1 mat_status,cc.member_key,cc.item_code,cc.preference,cc.matxl,cc.grade from (
                          select t.item_code,t.matxl,tt.member_key,tt.preference,tt.grade
                          from fact_ec_goods_sales_mat_top4 t inner join (
                          select c.*,(case when rownum<5 then 1 when rownum<10 then 2 else 3 end) grade from (
                          select o.member_key,g.matxl,sum(o.pl_preference) preference,
                          RANK() OVER (PARTITION BY o.member_key order by sum(o.pl_preference) desc,g.matxl desc) as RANK
                           from fact_member_page_order_total o 
                                left join dim_ec_good g on o.item_code=g.item_code
                                where o.member_key in (select member_key from fact_member_ec_goods_sales_ls where rn between lsi+1 and lsi+1000)
                                 group by g.matxl,o.member_key order by sum(pl_preference) desc)
                                 c where c.rank<=15
                                 ) tt on t.matxl=tt.matxl) cc );
         s_etl.err_msg := s_etl.err_msg||'-'||to_char(sysdate,'hh24miss');
        lsi := lsi + 1000;
      end loop;
      end;
    end;
    s_etl.err_msg := s_etl.err_msg||',删除用户数据:'||to_char(sysdate,'hh24miss');*/
    --delete from fact_member_ec_goods_sales where member_key in (select member_key from fact_member_page_order where day_key=postday group by member_key);
    --计算用户的维度
    /*     insert into fact_member_ec_goods_sales
              (mat_status,member_key,item_code,preference,grade,matxl)
              (select 0 as mat_status,cc.member_key,cc.item_code,cc.user_preference as preference,(case when cc.rank<=5 then 1 when cc.rank<=10 then 2 else 3 end) grade,g.matxl from (
                                      select member_key,item_code,user_preference,
                                      RANK() OVER (PARTITION BY member_key order by user_preference desc,item_code desc) as RANK 
                                      from fact_member_page_order_total where member_key
                                      in (select member_key from fact_member_page_order where day_key=postday group by member_key)
                                      and item_code is not null
                                      order by member_key desc)
                                      cc left join dim_ec_good g on g.item_code=cc.item_code where cc.rank<=30);
                                      commit;
    s_etl.err_msg := s_etl.err_msg||',用户top30数据:'||to_char(sysdate,'hh24miss');                                  
    --全部用户的分类top3商品
    insert into fact_member_ec_goods_sales
                      (mat_status,member_key,item_code,preference,matxl,grade)
                      (select 1 mat_status,cc.member_key,cc.item_code,cc.preference,cc.matxl,cc.grade from (
                        select t.item_code,t.matxl,tt.member_key,tt.preference,tt.grade
                        from fact_ec_goods_sales_mat_top4 t inner join (
                        select c.*,(case when rownum<5 then 1 when rownum<10 then 2 else 3 end) grade from (
                        select o.member_key,g.matxl,sum(o.pl_preference) preference,
                        RANK() OVER (PARTITION BY o.member_key order by sum(o.pl_preference) desc,g.matxl desc) as RANK
                         from fact_member_page_order_total o 
                              left join dim_ec_good g on o.item_code=g.item_code
                              where o.member_key in (select member_key from fact_member_page_order where day_key=postday group by member_key)
                               group by g.matxl,o.member_key order by sum(pl_preference) desc)
                               c where c.rank<=15
                               ) tt on t.matxl=tt.matxl) cc );*/
    /*(select 1 mat_status,cc.member_key,cc.item_code,cc.preference,cc.matxl,cc.grade from (
    select t.item_code,t.matxl,tt.member_key,tt.preference,tt.grade,RANK() OVER (PARTITION BY tt.member_key,tt.matxl order by t.sales_total desc,t.item_code desc) as RANKs
    from fact_ec_goods_sales_mat_top t inner join (
    select c.*,(case when rownum<5 then 1 when rownum<10 then 2 else 3 end) grade from (
    select o.member_key,g.matxl,sum(o.pl_preference) preference,
    RANK() OVER (PARTITION BY o.member_key order by sum(o.pl_preference) desc,g.matxl desc) as RANK
    
     from fact_member_page_order_total o 
                                    left join dim_ec_good g on o.item_code=g.item_code
                                    where o.member_key in (select member_key from fact_member_page_order where day_key=postday group by member_key)
                                     group by g.matxl,o.member_key order by sum(pl_preference) desc)
                                     c where c.rank<=15 order by c.member_key,c.rank asc
                                     ) tt on t.matxl=tt.matxl) cc where cc.ranks<=3);*/
  
    commit;
    s_etl.err_msg := s_etl.err_msg || ',用户分类top15数据:' ||
                     to_char(sysdate, 'hh24miss');
    --集体top15
    --插入每个分类下的前三销量的商品
    begin
      EXECUTE IMMEDIATE 'truncate table oper_goodrecommend_m_top';
    end;
    insert into oper_goodrecommend_m_top
      (item_code, preference, grade, matxl)
      (select t.item_code, p.preference, p.grade, t.matxl
         from oper_goodrecommend_mat_top4 t
        inner join (select p.*,
                          (case
                            when rownum < 5 then
                             1
                            when rownum < 10 then
                             2
                            else
                             3
                          end) grade
                     from (select g.matxl, /*物料小类*/
                                  sum(pl_preference) preference /*合计权重*/
                             from oper_goodrecommend_m_total o
                             left join dim_ec_good@dw_datalink g
                               on o.item_code = g.item_code
                            group by g.matxl
                            order by sum(pl_preference) desc) p
                    where rownum <= 15) p
           on t.matxl = p.matxl);
    /*(select cc.item_code,cc.preference,cc.grade,cc.matxl from (
    select t.item_code,p.preference,t.matxl,p.grade,
    RANK() OVER (PARTITION BY t.matxl order by p.preference desc,item_code desc) as RANK
    from fact_ec_goods_sales_mat_top t inner join (
    select p.*,(case when rownum<5 then 1 when rownum<10 then 2 else 3 end) grade 
    from (select g.matxl,sum(pl_preference) preference from fact_member_page_order_total o 
                        left join dim_ec_good g on o.item_code=g.item_code
                         group by g.matxl order by sum(pl_preference) desc) p 
                        where rownum<=15) p on t.matxl=p.matxl) cc where cc.rank<=4);*/
  
    /*begin
    declare
    type type_arrays is record
    (
      member_key  number(20)
    );
    
    type type_array is table of type_arrays index by binary_integer; --类似二维数组 
    
    
    var_array type_array;
    begin
      select p.* bulk collect
        into var_array from 
        (select member_key from fact_member_page_order where day_key=postday group by member_key) p;
    
        for i in 1 .. var_array.count loop
           select p.max_day into max_day from (
                select to_number(max(daykey)) max_day,to_number(min(daykey)) min_day from (
                select distinct(day_key) as daykey from fact_member_page_order 
                where member_key=var_array(i).member_key order by day_key desc)
                where rownum<=15) p;
                
           select p.min_day into min_day from (
                select to_number(max(daykey)) max_day,to_number(min(daykey)) min_day from (
                select distinct(day_key) as daykey from fact_member_page_order 
                where member_key=var_array(i).member_key order by day_key desc)
                where rownum<=15) p;
            
                
           merge into fact_member_page_order_total m --fzq1表是需要更新的表
           using (
                      select var_array(i).member_key as member_key,item_code,sum(pv_nums) as pv_total,
                      sum(cart_nums) as cart_total,sum(fav_nums) as fav_total, 
                      sum(order_nums) as order_total,sum(cancel_nums) as cancel_total,
                      (sum(pv_nums)+sum(fav_nums)*3+sum(cart_nums)*5-(sum(order_nums)-sum(cancel_nums))*15) as USER_PREFERENCE,
                      (sum(pv_nums)+sum(fav_nums)*3+sum(cart_nums)*5+(sum(order_nums)-sum(cancel_nums))*15) as PL_PREFERENCE
                      from fact_member_page_order where 
                      day_key between min_day and max_day and member_key=var_array(i).member_key 
                      group by item_code) mm -- 关联表
            on (m.member_key = mm.member_key and m.item_code = mm.item_code) --关联条件
            when matched then --匹配关联条件，作更新处理
                update
                   set m.pv_total                      = mm.pv_total,
                       m.cart_total                    = mm.cart_total,
                       m.fav_total                     = mm.fav_total,
                       m.order_total                   = mm.order_total,
                       m.cancel_total                  = mm.cancel_total,
                       m.USER_PREFERENCE                  = mm.USER_PREFERENCE,
                       m.PL_PREFERENCE                  = mm.PL_PREFERENCE,
                       m.UPDATE_DATE_KEY                = postday
                 when not matched then    --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
                 insert (member_key,item_code,pv_total,cart_total,fav_total,order_total,cancel_total,USER_PREFERENCE,PL_PREFERENCE,UPDATE_DATE_KEY) values
                 ( mm.member_key,mm.item_code,mm.pv_total,mm.cart_total,mm.fav_total,mm.order_total,mm.cancel_total,mm.USER_PREFERENCE,mm.PL_PREFERENCE,postday);       
              --此处只是说明可以同时更新多个字段。
              
              --计算用户的维度
              delete from fact_member_ec_goods_sales where member_key=var_array(i).member_key;
              insert into fact_member_ec_goods_sales
              (mat_status,member_key,item_code,preference,grade,matxl)
              (select 0 as mat_status,p.member_key,p.item_code,p.user_preference as preference,(case when p.rn<=10 then 1 
                                when p.rn<=20 then 2 else 3 end) grade,
                                  g.matxl 
                                  from (
                                  select ps.*,rownum rn from (
                                      select member_key,item_code,user_preference 
                                      from fact_member_page_order_total where member_key=var_array(i).member_key
                                      order by user_preference desc) ps
                                      ) p left join dim_ec_good g on p.item_code=g.item_code
                where p.rn<=30);
               --分类下的
               insert into fact_member_ec_goods_sales
                      (mat_status,member_key,item_code,preference,grade,matxl)
                      (select 1 as mat_status,var_array(i).member_key member_key,c.item_code,c.preference,c.grade,c.matxl from (SELECT  a.item_code, a.matxl,b.preference,b.grade,
                          RANK() OVER (PARTITION BY a.matxl order by a.sales_total,a.item_code desc) as RANK
                        FROM fact_ec_goods_sales_mat_top a join 
                              (select p.*,(case when rownum<5 then 1 when rownum<10 then 2 else 1 end) grade 
                              from (select g.matxl,sum(pl_preference) preference 
                                   from fact_member_page_order_total o 
                                   left join dim_ec_good g on o.item_code=g.item_code
                                   where o.member_key=var_array(i).member_key 
                                   group by g.matxl order by sum(pl_preference) desc) p 
                              where rownum<=15) b on a.matxl=b.matxl) c where c.rank<=3);
            end loop;
          end;
     end;
     --全部用户的top分类15
      begin
         declare
         type emp_type_fls is record
         (
             matxl  number(20),
             preference  number(20)
          );
          type emp_types_fls is table of emp_type_fls index by binary_integer; --类似二维数组 
          emp_rec_fls emp_types_fls;
          begin
              select pq.* bulk collect
                      into emp_rec_fls from 
                      (select p.* from (
                              select g.matxl,sum(pl_preference) preference from fact_member_page_order_total o 
                              left join dim_ec_good g on o.item_code=g.item_code
                               group by g.matxl order by sum(pl_preference) desc) p 
                              where rownum<=15) pq;
             for iii in 1 .. emp_rec_fls.count loop
               if iii<5 then
                        garde_num :=1;
               else
                 if iii<10 then
                          garde_num :=2;
                 else
                          garde_num :=3;
                 end if;
               end if;
                      --插入每个分类下的前三销量的商品
                      insert into FACT_EC_GOODS_MAT_TOP
                      (item_code,preference,grade,matxl)
                      (select p.item_code,
                      emp_rec_fls(iii).preference as preference,garde_num as grade,matxl 
                      from (
                        select * from fact_ec_goods_sales_mat_top 
                        where matxl=emp_rec_fls(iii).matxl and 
                        --排除掉30天没有变化的
                        posting_date_key>=(select to_number(to_char(to_date(postday,'yyyy-mm-dd')-29,'yyyymmdd')) from dual)
                        order by sales_total desc )p where rownum<=4
                      );
             end loop;
          end;
      end;*/
  end if;
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
end dmopergoodrecommendmember;
/

