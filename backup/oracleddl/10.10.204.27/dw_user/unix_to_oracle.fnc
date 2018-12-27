???create or replace function dw_user.unix_to_oracle(in_number NUMBER) return date is

  begin

   return(TO_DATE('19700101','yyyymmdd') + in_number/86400 +TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone),1,3))/24);

  end unix_to_oracle;
/

