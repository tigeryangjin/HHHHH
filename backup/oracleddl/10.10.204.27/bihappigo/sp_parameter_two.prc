???create or replace procedure bihappigo.sp_parameter_two(s_pname     in varchar2,
                                             s_parameter out number) is
  s_ptype s_parameters2.ptype%type;
  /*
  功能说明：框架
            依据传入的procedure名称，获得该过程的数据加载方式
            并获得数据抽取的起始时间节点
            A--全量加载
            B--增量加载
  
  作者：LIQIAO  2015-05-11
  */
begin
  select ptype
    into s_ptype
    from s_parameters2
   where upper(s_pname) = upper(pname);

  if s_ptype = 1 then
    select x.parameter_value
      into s_parameter
      from s_parameters1 x
     where x.flag = 1;
  elsif s_ptype = 2 then
    select x.parameter_value
      into s_parameter
      from s_parameters1 x
     where x.flag = 2;
  
  end if;
exception
  when no_data_found then
    s_parameter := 0;
end sp_parameter_two;
/

