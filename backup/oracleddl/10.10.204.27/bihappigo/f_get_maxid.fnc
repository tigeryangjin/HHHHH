???create or replace function bihappigo.F_GET_MAXID(in_id      number,
                                           in_akey number,
                                           in_vkey number
                                           )
  return fact_page_view.id%type is
  is_val fact_page_view.id%type;
begin
select max(a.id) into is_val
                  from fact_page_view a
                  where a.id < in_id
                    and a.application_key = in_akey
                    and a.visitor_key =in_vkey;  

  return is_val;
exception
  when others then
    return '';
end F_GET_MAXID;
/

