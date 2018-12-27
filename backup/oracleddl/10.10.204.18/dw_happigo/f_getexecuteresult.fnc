???create or replace function dw_happigo.f_getexecuteresult(executeresult clob)
  return number is

  resultcode number;
begin
  if substr(executeresult, 3, 5) = 'error' then
    resultcode := to_number(substr(executeresult, 28, 4));
  else
    resultcode := to_number(substr(executeresult, 61, 4));
  end if;
  return resultcode;
exception
  when others then
    return '';
end f_getexecuteresult;
/

