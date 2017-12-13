/*
HBP供应商编号ec_store_joinin.hbp_store_id	
品类	
公司名称ec_store.store_company_name	
店铺名称ec_store.store_name	
品牌	
开店模式ec_store.store_type	
支付金额ec_store.store_baozhrmb保证金金额	
预计入驻时间	
状态ec_store.store_state	
SKU 数	
销售金额 （元）	
MD	
供应商联系人ec_store_joinin.contacts_name	
供应商联系方式ec_store_joinin.contacts_phone
*/

select a.store_zy,/*品类*/
a.store_company_name,
a.store_name

from happigo_ec.ec_store a;