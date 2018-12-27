???create or replace function dw_happigo.test_instr(ipvalue in varchar2) return number  is
  Result number ;
begin
  Result := substr(ipvalue ,
            instr(ipvalue , '.', 1, 1 ) + 1,
            instr(ipvalue , '.', 1, 2 ) -
            instr(ipvalue , '.', 1, 1 ) - 1);  

  --Result := instr(ipvalue,'.',1,1);
  return(Result);
end test_instr;
/

