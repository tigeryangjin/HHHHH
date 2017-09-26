CREATE TABLE fact_ec_p_xianshi (
   xianshi_id number(10) ,
   crm_policy_id varchar2(20),
   xianshi_type number(2) ,
   xianshi_name varchar2(50),
   xianshi_title varchar2(10) ,
   xianshi_explain varchar2(50),
   quota_id number(10) ,
   start_time number(10) ,
   end_time number(10) ,
   xianshi_time number(10),
   member_id number(10) ,
   store_id number(10) ,
   member_name varchar2(50),
   store_name varchar2(50) ,
   lower_limit number(10) ,
   state number(3)  ,
   xianshi_web number(2),
   xianshi_3g number(2) ,
   xianshi_app number(2) ,
   xianshi_wx number(2) ,
   xianshi_schedule number(2) 
 ) ;
 
-- Add comments to the columns 
comment on column fact_ec_p_xianshi.xianshi_id
  is '��ʱ���';
comment on column fact_ec_p_xianshi.crm_policy_id
  is 'CRM�������';
comment on column fact_ec_p_xianshi.xianshi_type
  is '��ʱ���� 1��ʱֱ��  2��ʱ�� 3 tvֱ��';
comment on column fact_ec_p_xianshi.xianshi_name
  is '�����';
comment on column fact_ec_p_xianshi.xianshi_title
  is '�����';
comment on column fact_ec_p_xianshi.xianshi_explain
  is '�˵��';
comment on column fact_ec_p_xianshi.quota_id
  is '�ײͱ��';
comment on column fact_ec_p_xianshi.start_time
  is '���ʼʱ��';
comment on column fact_ec_p_xianshi.end_time
  is '�����ʱ��';
comment on column fact_ec_p_xianshi.xianshi_time
  is '��ʱ������';
comment on column fact_ec_p_xianshi.member_id
  is '�û����';
comment on column fact_ec_p_xianshi.store_id
  is '���̱��';
comment on column fact_ec_p_xianshi.member_name
  is '�û���';
comment on column fact_ec_p_xianshi.store_name
  is '��������';
comment on column fact_ec_p_xianshi.lower_limit
  is '�������ޣ�1Ϊ������';
comment on column fact_ec_p_xianshi.state
  is '״̬��0-ȡ�� 1-���� 2���� 3����Ա�ر�';
comment on column fact_ec_p_xianshi.xianshi_web
  is '��������վ';
comment on column fact_ec_p_xianshi.xianshi_3g
  is '������3G';
comment on column fact_ec_p_xianshi.xianshi_app
  is '������APP';
comment on column fact_ec_p_xianshi.xianshi_wx
  is '������΢��';
comment on column fact_ec_p_xianshi.xianshi_schedule
  is '��ʱ������';
	
