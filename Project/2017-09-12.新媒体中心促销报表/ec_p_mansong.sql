CREATE TABLE ec_p_mansong (
   mansong_id number(10),
   mansong_name varchar2(150),
   quota_id number(10),
   start_time number(10),
   end_time number(10) ,
   member_id number(10) ,
   store_id number(10) ,
   member_name varchar2(150) ,
   store_name varchar2(150) ,
   state number(1),
   remark varchar2(600),
   mansong_web number(2),
   mansong_app number(2),
   mansong_wx number(2) ,
   mansong_3g number(2) ,
   mansong_num number(10),
   mansong_advertising varchar2(600) ,
   isshop_cart number(2) ,
   isgoods_details number(2) ,
   mat_type number(2) ,
   goods_type number(2),
   min_level number(11),
   min_level_t varchar2(60) ,
   isall_details number(5) ,
   app_minato_single_url varchar2(1500) ,
   web_minato_single_url varchar2(1500) 
 ) ;
-- Add comments to the columns 
comment on column ec_p_mansong.mansong_id
  is '���ͻ���';
comment on column ec_p_mansong.mansong_name
  is '�����';
comment on column ec_p_mansong.quota_id
  is '�ײͱ��';
comment on column ec_p_mansong.start_time
  is '���ʼʱ��';
comment on column ec_p_mansong.end_time
  is '�����ʱ��';
comment on column ec_p_mansong.member_id
  is '�û����';
comment on column ec_p_mansong.store_id
  is '���̱��';
comment on column ec_p_mansong.member_name
  is '�û���';
comment on column ec_p_mansong.store_name
  is '��������';
comment on column ec_p_mansong.state
  is '�״̬(1-����/2-�ѽ���/3-����Ա�ر�/6-��ͣ/7-��ɾ��)';
comment on column ec_p_mansong.remark
  is '��ע';
comment on column ec_p_mansong.mansong_web
  is '�����ж��Ƿ��������ͣ�1�����ܣ�0��������';
comment on column ec_p_mansong.mansong_app
  is 'APP�ж��Ƿ��������ͣ�1�����ܣ�0��������';
comment on column ec_p_mansong.mansong_wx
  is '΢���ж��Ƿ��������ͣ�1�����ܣ�0��������';
comment on column ec_p_mansong.mansong_3g
  is '3g�ж��Ƿ��������ͣ�1�����ܣ�0��������';
comment on column ec_p_mansong.mansong_num
  is '���ʹ�����0Ϊ������';
comment on column ec_p_mansong.mansong_advertising
  is '�����';
comment on column ec_p_mansong.isshop_cart
  is '���ﳵ�Ƿ���ʾ�����';
comment on column ec_p_mansong.isgoods_details
  is '��Ʒ����ҳ�Ƿ���ʾ�����';
comment on column ec_p_mansong.mat_type
  is '������Ŀ���ͣ�0:�ޣ�1:ֻ����2:������';
comment on column ec_p_mansong.goods_type
  is '������Ʒ���ͣ�0:�ޣ�1:ֻ����2:������';
comment on column ec_p_mansong.min_level
  is '������ܵȼ�';
comment on column ec_p_mansong.min_level_t
  is '������ܵȼ�';
comment on column ec_p_mansong.isall_details
  is '�Ƿ���ʾ�����';
comment on column ec_p_mansong.app_minato_single_url
  is 'APP�յ�ҳ������';
comment on column ec_p_mansong.web_minato_single_url
  is 'WEB�յ�ҳ������';
 
