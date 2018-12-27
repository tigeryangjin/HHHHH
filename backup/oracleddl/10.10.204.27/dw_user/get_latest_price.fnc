???create or replace function dw_user.GET_LATEST_PRICE(ITTEMCODE in varchar2) return  number is
 lprice number;
begin
  
 select  bn6.acq_price into lprice from data_acquisition_item bn6,
 (select ITTEMCODE as itcode  ,max(bn3.period) as period from 
 data_acquisition_item bn3
 where bn3.acq_item_code=ITTEMCODE
 ) bn5
 where bn6.acq_item_code=bn5.itcode
 and   bn6.period=bn5.period
 and rownum=1;
return(lprice);

end GET_LATEST_PRICE;
/

