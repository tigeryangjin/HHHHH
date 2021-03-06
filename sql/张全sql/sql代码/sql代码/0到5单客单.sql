select M_LABEL_DESC,count(distinct MEMBER_CRMBP),count( distinct MEMBER_KEY1),count( distinct MEMBER_KEY2),
count( distinct MEMBER_KEY3),count( distinct MEMBER_KEY4),count( distinct MEMBER_KEY5),sum(PAY_AMOUNT1),sum(GOODS_AMOUNT1)
,sum(PAY_AMOUNT2),sum(GOODS_AMOUNT2)
,sum(PAY_AMOUNT3),sum(GOODS_AMOUNT3)
,sum(PAY_AMOUNT4),sum(GOODS_AMOUNT4)
,sum(PAY_AMOUNT5),sum(GOODS_AMOUNT5)
 from (
select * from 
(select MEMBER_CRMBP,M_LABEL_DESC from (select MEMBER_CRMBP,REGISTER_APPNAME from fact_ecmember) a left join
 (select MEMBER_KEY,M_LABEL_DESC from MEMBER_LABEL_LINK_V where  
 M_LABEL_ID in (select M_LABEL_ID from MEMBER_LABEL_HEAD where M_LABEL_FATHER_ID=235)) b on a.member_crmbp=b.MEMBER_KEY)
s left join
(select MEMBER_KEY as MEMBER_KEY1,b.ADD_TIME as ADD_TIME1,APP_NAME as APP_NAME1,ORDER_FROM as ORDER_FROM1,PROMOTION_DESC as PROMOTION_DESC1
,GOODS_AMOUNT as GOODS_AMOUNT1,PAY_AMOUNT as PAY_AMOUNT1,INTEGRALS_AMOUNT as INTEGRALS_AMOUNT1,VOUCHER_PRICE as VOUCHER_PRICE1,ORDER_AMOUNT  as ORDER_AMOUNT1 from (
select to_number(MEMBER_BP),ADD_TIME,ORDER_ID,SALES_SOURCE_SECOND_DESC,PROMOTION_DESC from oper_ec_member_track_rank
where RANK1=1  and  to_number(MEMBER_BP) not in (select MEMBER_BP from dim_member where FIRSTW_ORDER_DATE_KEY<20170101) )a left join factec_order b on a.ORDER_ID=b.ORDER_ID) ss
on s.MEMBER_CRMBP=ss.MEMBER_KEY1
left join
(select MEMBER_KEY as MEMBER_KEY2,b.ADD_TIME as ADD_TIME2,APP_NAME as APP_NAME2,ORDER_FROM as ORDER_FROM2,PROMOTION_DESC as PROMOTION_DESC2
,GOODS_AMOUNT as GOODS_AMOUNT2,PAY_AMOUNT as PAY_AMOUNT2,INTEGRALS_AMOUNT as INTEGRALS_AMOUNT2,VOUCHER_PRICE as VOUCHER_PRICE2,ORDER_AMOUNT as ORDER_AMOUNT2
  from (
select to_number(MEMBER_BP),ADD_TIME,ORDER_ID,SALES_SOURCE_SECOND_DESC,PROMOTION_DESC from oper_ec_member_track_rank
where RANK1=2 and  to_number(MEMBER_BP) not in (select MEMBER_BP from dim_member where FIRSTW_ORDER_DATE_KEY<20170101)  )a left join factec_order b on a.ORDER_ID=b.ORDER_ID) sss
on s.MEMBER_CRMBP=sss.MEMBER_KEY2 
left join
(select MEMBER_KEY as MEMBER_KEY3,b.ADD_TIME as ADD_TIME3,APP_NAME as APP_NAME3,ORDER_FROM as ORDER_FROM3,PROMOTION_DESC as PROMOTION_DESC3
,GOODS_AMOUNT as GOODS_AMOUNT3,PAY_AMOUNT as PAY_AMOUNT3,INTEGRALS_AMOUNT as INTEGRALS_AMOUNT3,VOUCHER_PRICE as VOUCHER_PRICE3,ORDER_AMOUNT as ORDER_AMOUNT3 from (
select to_number(MEMBER_BP),ADD_TIME,ORDER_ID,SALES_SOURCE_SECOND_DESC,PROMOTION_DESC from oper_ec_member_track_rank
where RANK1=3 and  to_number(MEMBER_BP) not in (select MEMBER_BP from dim_member where FIRSTW_ORDER_DATE_KEY<20170101)  )a left join factec_order b on a.ORDER_ID=b.ORDER_ID) ssss
on s.MEMBER_CRMBP=ssss.MEMBER_KEY3
left join
(select MEMBER_KEY as MEMBER_KEY4,b.ADD_TIME as ADD_TIME4,APP_NAME as APP_NAME4,ORDER_FROM as ORDER_FROM4,PROMOTION_DESC as PROMOTION_DESC4
,GOODS_AMOUNT as GOODS_AMOUNT4,PAY_AMOUNT as PAY_AMOUNT4,INTEGRALS_AMOUNT as INTEGRALS_AMOUNT4,VOUCHER_PRICE as VOUCHER_PRICE4,ORDER_AMOUNT as ORDER_AMOUNT4
from (
select to_number(MEMBER_BP),ADD_TIME,ORDER_ID,SALES_SOURCE_SECOND_DESC,PROMOTION_DESC from oper_ec_member_track_rank
where RANK1=4 and  to_number(MEMBER_BP) not in (select MEMBER_BP from dim_member where FIRSTW_ORDER_DATE_KEY<20170101)  )a left join factec_order b on a.ORDER_ID=b.ORDER_ID) sssss
on s.MEMBER_CRMBP=sssss.MEMBER_KEY4 
left join
(select MEMBER_KEY as MEMBER_KEY5,b.ADD_TIME as ADD_TIME5,APP_NAME as APP_NAME5,ORDER_FROM as ORDER_FROM5,PROMOTION_DESC as PROMOTION_DESC5
,GOODS_AMOUNT as GOODS_AMOUNT5,PAY_AMOUNT as PAY_AMOUNT5,INTEGRALS_AMOUNT as INTEGRALS_AMOUNT5,VOUCHER_PRICE as VOUCHER_PRICE5,ORDER_AMOUNT as ORDER_AMOUNT5 from (
select to_number(MEMBER_BP),ADD_TIME,ORDER_ID,SALES_SOURCE_SECOND_DESC,PROMOTION_DESC from oper_ec_member_track_rank
where RANK1=5 and  to_number(MEMBER_BP) not in (select MEMBER_BP from dim_member where FIRSTW_ORDER_DATE_KEY<20170101)  )a left join factec_order b on a.ORDER_ID=b.ORDER_ID) ssssss
on s.MEMBER_CRMBP=ssssss.MEMBER_KEY5 )
group by M_LABEL_DESC
