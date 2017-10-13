create or replace procedure sp_parameter_two(s_pname     in varchar2,
                                             s_parameter out number) is
  s_ptype s_parameters2.ptype%type;
  /*
  ����˵�������
            ���ݴ����procedure���ƣ���øù��̵����ݼ��ط�ʽ
            ��������ݳ�ȡ����ʼʱ��ڵ�
            A--ȫ������
            B--��������
  
  ���ߣ�LIQIAO  2015-05-11
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
