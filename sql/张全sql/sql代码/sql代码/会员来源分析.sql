-----ȥ��Q1��Ա����
truncate table ls_test;
insert into ls_test 

 (
select MEMBER_BP as ssid,(case 
   when   M_LABEL_DESC='�ƹ�'  then '�ƹ�����'
   when   M_LABEL_DESC='ɨ��'  then '�ڲ�����'
   when   M_LABEL_DESC='��Ȼ' and  REGISTER_RESOURCE='TV' then '�ڲ�����'
     ELSE '��Ȼ����'  end )  as sname,1  from  (
select MEMBER_BP,M_LABEL_DESC,REGISTER_RESOURCE from (
select  MEMBER_KEY  from fact_session where START_DATE_KEY between 20170401 and 20170431
and MEMBER_KEY in (select MEMBER_CRMBP from fact_ecmember  where MEMBER_TIME between 20170401 and 20170431)
 group by  MEMBER_KEY ) a left join 
 (select MEMBER_KEY,max(M_LABEL_DESC) M_LABEL_DESC from  member_label_link_v where M_LABEL_DESC in ('ɨ��','��Ȼ','�ƹ�') 
  group by MEMBER_KEY )
 b on a.member_key=b.MEMBER_KEY
 left join ( select MEMBER_BP,REGISTER_RESOURCE from dim_member) c on a.member_key=c.member_bp)
 group by MEMBER_BP,(case 
   when   M_LABEL_DESC='�ƹ�'  then '�ƹ�����'
   when   M_LABEL_DESC='ɨ��'  then '�ڲ�����'
   when   M_LABEL_DESC='��Ȼ' and  REGISTER_RESOURCE='TV' then '�ڲ�����'
     ELSE '��Ȼ����'  end )  );
 ------- ��Ծ��Ա      ������Ա  �������  ��������
    
  select SNAME,count(1) from ls_test
  
  group by SNAME;
  
  
  ------------ ƽ����Ծ����
  select avg(num1),SNAME  from(
  select MEMBER_KEY,count(1) num1 from (
  select MEMBER_KEY,START_DATE_KEY from fact_session where START_DATE_KEY between 20170401 and 20170431
  group by MEMBER_KEY,START_DATE_KEY) group by  MEMBER_KEY)
  a left join ls_test b on a.member_key=b.ssid  group by SNAME;
  
    ------------ ���λ�Ծʱ��
  select avg(num1),SNAME  from(
  select MEMBER_KEY,avg(LIFE_TIME) num1 from (
  select MEMBER_KEY,sum(LIFE_TIME) LIFE_TIME,START_DATE_KEY from fact_session where START_DATE_KEY between 20170401 and 20170431
  group by MEMBER_KEY,START_DATE_KEY) group by  MEMBER_KEY)
  a left join ls_test b on a.member_key=b.ssid  group by SNAME;
  
  -------������Ա  �������  ��������
  select SNAME,count(1),sum(num1),sum(num2),sum(num3) from (
  select MEMBER_KEY,count(1) num1,sum(order_amount) num2,sum(GOODS_NUM) num3 from factec_order where add_time  between 20170401 and 20170431
 --- and order_from !=76
  and order_state>10
  and STORE_ID=1  group by MEMBER_KEY)  a 
  left join ls_test b on a.member_key=b.ssid  group by SNAME;
  
-------ҳ�����
select avg(num1),avg(num2),avg(num3),count(distinct MEMBER_KEY),page_name,SNAME from (

select MEMBER_KEY,page_name,count(distinct visit_date_key)  num1,count(1) num2,sum(PAGE_STAYTIME_KEY) num3
 from fact_page_view where visit_date_key  between 20170401 and 20170431
 group by  MEMBER_KEY,page_name)  a 
  join ls_test b on a.member_key=b.ssid   group by page_name,SNAME;
  
