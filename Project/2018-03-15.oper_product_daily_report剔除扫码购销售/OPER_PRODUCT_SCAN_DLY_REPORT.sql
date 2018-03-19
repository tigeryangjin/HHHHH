-- Create table
create table OPER_PRODUCT_SCAN_DLY_REPORT
(
  row_id                       NUMBER(10), 
	posting_date_key             NUMBER(10),
  sales_source_name            VARCHAR2(200),
  sales_source_second_name     VARCHAR2(200),
  own_account                  VARCHAR2(9),
  brand_name                   VARCHAR2(100),
  tran_type                    VARCHAR2(20),
  tran_type_name               VARCHAR2(12),
  item_or_gift                 VARCHAR2(6),
  matdlt                       VARCHAR2(100),
  matzlt                       VARCHAR2(100),
  matxlt                       VARCHAR2(100),
  md_person                    NUMBER(10),
  item_code                    NUMBER(10),
  goods_key                    NUMBER(20),
  goods_name                   VARCHAR2(200),
  total_order_amount           NUMBER(10,2) default 0,
  net_order_amount             NUMBER(10,2) default 0,
  effective_order_amount       NUMBER(10,2) default 0,
  cancel_order_amount          NUMBER(10,2) default 0,
  reverse_order_amount         NUMBER(10,2) default 0,
  reject_order_amount          NUMBER(10,2) default 0,
  cancel_reverse_amount        NUMBER(10,2) default 0,
  cancel_reject_amount         NUMBER(10,2) default 0,
  total_sales_amount           NUMBER(10,2) default 0,
  net_sales_amount             NUMBER(10,2) default 0,
  effective_sales_amount       NUMBER(10,2) default 0,
  total_order_member_count     NUMBER(10,2) default 0,
  net_order_member_count       NUMBER(10,2) default 0,
  effective_order_member_count NUMBER(10,2) default 0,
  cancel_order_member_count    NUMBER(10,2) default 0,
  reverse_member_count         NUMBER(10,2) default 0,
  reject_member_count          NUMBER(10,2) default 0,
  cancel_reverse_member_count  NUMBER(10,2) default 0,
  cancel_reject_member_count   NUMBER(10,2) default 0,
  total_order_count            NUMBER(10,2) default 0,
  net_order_count              NUMBER(10,2) default 0,
  effective_order_count        NUMBER(10,2) default 0,
  cancel_order_count           NUMBER(10,2) default 0,
  reverse_count                NUMBER(10,2) default 0,
  reject_count                 NUMBER(10,2) default 0,
  cancel_reverse_count         NUMBER(10,2) default 0,
  cancel_reject_count          NUMBER(10,2) default 0,
  gross_profit_amount          NUMBER(10,2) default 0,
  net_profit_amount            NUMBER(10,2) default 0,
  effective_profit_amount      NUMBER(10,2) default 0,
  gross_profit_rate            NUMBER(10,2) default 0,
  net_profit_rate              NUMBER(10,2) default 0,
  effective_profit_rate        NUMBER(10,2) default 0,
  total_order_qty              NUMBER(10,2) default 0,
  net_order_qty                NUMBER(10,2) default 0,
  effective_order_qty          NUMBER(10,2) default 0,
  cancel_order_qty             NUMBER(10,2) default 0,
  reverse_qty                  NUMBER(10,2) default 0,
  reject_qty                   NUMBER(10,2) default 0,
  cancel_reverse_qty           NUMBER(10,2) default 0,
  cancel_reject_qty            NUMBER(10,2) default 0,
  net_order_cust_price         NUMBER(10,2) default 0,
  effective_order_cust_price   NUMBER(10,2) default 0,
  net_order_unit_price         NUMBER(10,2) default 0,
  effective_order_unit_price   NUMBER(10,2) default 0,
  total_purchase_amount        NUMBER(10,2) default 0,
  net_purchase_amount          NUMBER(10,2) default 0,
  effective_purchase_amount    NUMBER(10,2) default 0,
  profit_amount                NUMBER(10,2) default 0,
  coupons_amount               NUMBER(10,2) default 0,
  freight_amount               NUMBER(10,2) default 0,
  product_avg_price            NUMBER(10,2) default 0,
  reject_amount                NUMBER(10,2) default 0,
  live_or_replay               VARCHAR2(10)
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table OPER_PRODUCT_SCAN_DLY_REPORT
  is '��ý�����������ձ�-ɨ�빺
by yangjin
2018-03-16';
-- Add comments to the columns 
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.posting_date_key
  is '��������key';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.sales_source_name
  is '����һ����֯����';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.sales_source_second_name
  is '���۶�����֯����';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.own_account
  is '�Ƿ���Ӫ';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.brand_name
  is 'Ʒ��';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.tran_type
  is '��������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.tran_type_name
  is '��������˵��';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.item_or_gift
  is '����Ʒ';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.matdlt
  is '���ϴ���';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.matzlt
  is '��������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.matxlt
  is '����С��';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.md_person
  is 'MD����';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.item_code
  is '��Ʒ�̱���';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.goods_key
  is '��Ʒ������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.goods_name
  is '��Ʒ����';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.total_order_amount
  is '�ܶ������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.net_order_amount
  is '���������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.effective_order_amount
  is '��Ч�������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_order_amount
  is 'ȡ���������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.reverse_order_amount
  is '�˻��������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.reject_order_amount
  is '���ն������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_reverse_amount
  is '�˻�ȡ���������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_reject_amount
  is '����ȡ���������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.total_sales_amount
  is '���ۼ۽��';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.net_sales_amount
  is '���ۼ۽��';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.effective_sales_amount
  is '��Ч�ۼ۽��';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.total_order_member_count
  is '�ܶ�������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.net_order_member_count
  is '����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.effective_order_member_count
  is '��Ч��������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_order_member_count
  is 'ȡ����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.reverse_member_count
  is '�˻���������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.reject_member_count
  is '���ն�������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_reverse_member_count
  is '�˻�ȡ����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_reject_member_count
  is '����ȡ����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.total_order_count
  is '�ܶ�������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.net_order_count
  is '����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.effective_order_count
  is '��Ч��������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_order_count
  is 'ȡ����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.reverse_count
  is '�˻���������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.reject_count
  is '���ն�������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_reverse_count
  is '�˻�ȡ����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_reject_count
  is '����ȡ����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.gross_profit_amount
  is '��ԭ����ë����';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.net_profit_amount
  is '��ԭ��ë����';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.effective_profit_amount
  is '��ԭ����Чë����';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.gross_profit_rate
  is '��ԭ����ë����';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.net_profit_rate
  is '��ԭ��ë����';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.effective_profit_rate
  is '��ԭ����Чë����';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.total_order_qty
  is '�ܶ�������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.net_order_qty
  is '����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.effective_order_qty
  is '��Ч��������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_order_qty
  is 'ȡ����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.reverse_qty
  is '�˻���������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.reject_qty
  is '���ն�������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_reverse_qty
  is '�˻�ȡ����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.cancel_reject_qty
  is '����ȡ����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.net_order_cust_price
  is '�������͵���';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.effective_order_cust_price
  is '��Ч�����͵���';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.net_order_unit_price
  is '������������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.effective_order_unit_price
  is '��Ч����������';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.total_purchase_amount
  is '�ܶ����ɱ�';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.net_purchase_amount
  is '�������ɱ�';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.effective_purchase_amount
  is '��Ч�����ɱ�';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.profit_amount
  is '�ۿ۽��';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.coupons_amount
  is '�Ż�ȯ���';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.freight_amount
  is '�˷�';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.product_avg_price
  is '��Ʒƽ���ۼ�';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.reject_amount
  is '���˽��';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.live_or_replay
  is 'ֱ���ز�';
comment on column OPER_PRODUCT_SCAN_DLY_REPORT.row_id
  is '�м�¼ID';
-- Create/Recreate indexes 
create index OPER_PRODUCT_SCAN_DLY_RRT_I1 on OPER_PRODUCT_SCAN_DLY_REPORT (POSTING_DATE_KEY)
  tablespace DWDATA00
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Grant/Revoke object privileges 
grant select on OPER_PRODUCT_SCAN_DLY_REPORT to BDPUSER;
grant select on OPER_PRODUCT_SCAN_DLY_REPORT to YUNYING;
