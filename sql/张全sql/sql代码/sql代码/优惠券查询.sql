select VOUCHER_REF,count(1),sum(order_amount) from   factec_order where VOUCHER_REF in 
(4750,
4751,
4752,
4753,
4754,
4755,
4756,
4705,
4706,
4707,
4708,
4709,
4710,
4711,
4712,
4713) and order_state>10  group by  VOUCHER_REF

