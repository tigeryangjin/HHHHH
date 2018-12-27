???create or replace function dw_user.get_itemcode(commonid in number) return  number is
  itemcode number;
begin
  
  
select a2.item_code into  itemcode from  dim_good a2 where a2.goods_commonid=commonid and rownum=1;
return(itemcode);


end get_itemcode;
/

