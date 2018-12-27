???create or replace function dw_user.get_commonid(itemcode in number) return number is
  commonid number;
begin
  
select a2.goods_commonid into  commonid from  dim_ec_good a2 where a2.item_code=itemcode;
return(commonid);

end get_commonid;
/

