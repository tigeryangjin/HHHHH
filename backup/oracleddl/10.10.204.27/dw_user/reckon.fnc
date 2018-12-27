???create or replace function dw_user.reckon(posting in number) return number is
  resulttotal number;
  goods_true  number;

begin
  declare
    type type_arrays_info is record(
      member_key number(10));
  
    type type_array_info is table of type_arrays_info index by binary_integer; --类似二维数组 
    var_array_info type_array_info; --有更新member用户  
  
  begin
    resulttotal := 0;
    select p.* bulk collect
      into var_array_info
      from (select member_key
              from fact_association_good_member
             where posting_date_key = posting) p;
    for i in 1 .. var_array_info.count loop
    
      select count(1)
        into goods_true
        from ((select *
                 from (select item_code
                         from fact_association_good_member
                        where member_key = var_array_info(i).member_key
                          and posting_date_key = posting),
                      (select item_code as item_code_r
                         from fact_association_good_member
                        where member_key = var_array_info(i).member_key
                          and posting_date_key != posting)) union
              (select *
                 from (select item_code
                         from fact_association_good_member
                        where member_key = var_array_info(i).member_key
                          and posting_date_key != posting),
                      (select item_code as item_code_r
                         from fact_association_good_member
                        where member_key = var_array_info(i).member_key
                          and posting_date_key = posting)) union
              (select *
                 from (select item_code
                         from fact_association_good_member
                        where member_key = var_array_info(i).member_key
                          and posting_date_key = posting),
                      (select item_code as item_code_r
                         from fact_association_good_member
                        where member_key = var_array_info(i).member_key
                          and posting_date_key = posting)));
      resulttotal := resulttotal + goods_true;
    end loop;
  end;
  return(resulttotal);
end reckon;
/

