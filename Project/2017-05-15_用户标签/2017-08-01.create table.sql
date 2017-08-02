-- Create table
create table MEMBER_LABEL_LINK
(
  member_key          NUMBER(10),
  m_label_id          NUMBER(5),
  m_label_type_id     NUMBER(5),
  create_date         NUMBER(5),
  create_user_id      VARCHAR2(50),
  last_update_date    DATE,
  last_update_user_id VARCHAR2(50)
)
partition by range (m_label_type_id)
(
  partition M_Label_type_id_1 values less than (1),
  partition M_Label_type_id_2 values less than (2),
  partition M_Label_type_id_3 values less than (3),
  partition M_Label_type_id_4 values less than (4)
    
);
-- Add comments to the table 
comment on table MEMBER_LABEL_LINK
  is '会员标签映射表';
-- Add comments to the columns 
comment on column MEMBER_LABEL_LINK.member_key
  is '会员编号';
comment on column MEMBER_LABEL_LINK.m_label_id
  is '会员标签ID';
comment on column MEMBER_LABEL_LINK.m_label_type_id
  is '标签类型ID';
comment on column MEMBER_LABEL_LINK.create_date
  is '创建日期';
comment on column MEMBER_LABEL_LINK.create_user_id
  is '创建人员ID';
comment on column MEMBER_LABEL_LINK.last_update_date
  is '最后修改日期';
comment on column MEMBER_LABEL_LINK.last_update_user_id
  is '最后修改人员ID';
