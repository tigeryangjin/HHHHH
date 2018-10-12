--ÐÂ°æ
select case
         when exists
          (select *
                 from dim_member zz
                where zz.member_bp = yy.member_key
                  and zz.member_level in ('HAPP_T0', 'HAPP_T1', 'HAPP_T2')) then
          yy.order_amount / 100
         when exists (select *
                 from dim_member zz
                where zz.member_bp = yy.member_key
                  and zz.member_level = 'HAPP_T3') then
          yy.order_amount / 100 * 2
         when exists (select *
                 from dim_member zz
                where zz.member_bp = yy.member_key
                  and zz.member_level = 'HAPP_T4') then
          yy.order_amount / 100 * 3
         when exists (select *
                 from dim_member zz
                where zz.member_bp = yy.member_key
                  and zz.member_level = 'HAPP_T5') then
          yy.order_amount / 100 * 4
         when exists (select *
                 from dim_member zz
                where zz.member_bp = yy.member_key
                  and zz.member_level = 'HAPP_T6') then
          yy.order_amount / 100 * 5
         else
          yy.order_amount / 100
       end
  from factec_order yy
 where yy.add_time between 20180701 and 20180731
   and yy.order_state >= 20;

--ÀÏ°æ
select case
         when exists
          (select *
                 from dim_member zz
                where zz.member_bp = yy.member_key
                  and zz.member_level in ('HAPP_T0', 'HAPP_T1', 'HAPP_T2')) then
          yy.order_amount / 100 / 2
         when exists (select *
                 from dim_member zz
                where zz.member_bp = yy.member_key
                  and zz.member_level = 'HAPP_T3') then
          yy.order_amount / 100 / 2
         when exists (select *
                 from dim_member zz
                where zz.member_bp = yy.member_key
                  and zz.member_level = 'HAPP_T4') then
          yy.order_amount / 100
         when exists (select *
                 from dim_member zz
                where zz.member_bp = yy.member_key
                  and zz.member_level = 'HAPP_T5') then
          yy.order_amount / 100 * 3 / 2
         when exists (select *
                 from dim_member zz
                where zz.member_bp = yy.member_key
                  and zz.member_level = 'HAPP_T6') then
          yy.order_amount / 100 * 2
         else
          yy.order_amount / 100
       end
  from factec_order yy
 where yy.add_time between 20180601 and 20180630
   and yy.order_state >= 20
