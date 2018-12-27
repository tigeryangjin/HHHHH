???create or replace function dw_user.get_cust_level(m_key in number) return number is
  level_id number;
begin

  select case
           when c2.member_level = 'HAPP_T0' then
            0
           when c2.member_level = 'HAPP_T1' then
            1
           when c2.member_level = 'HAPP_T2' then
            2
           when c2.member_level = 'HAPP_T3' then
            3
           when c2.member_level = 'HAPP_T4' then
            4
           when c2.member_level = 'HAPP_T5' then
            5
            when c2.member_level = 'HAPP_T6' then
            6
           else
            0
         end
  
    into level_id
    from dim_member c2
   where c2.member_bp = m_key;
  return(level_id);

end get_cust_level;
/

