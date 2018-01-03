#开团数
select * from ec_group_purchase_task where
 add_time > UNIX_TIMESTAMP('2017-10-20');

#成团数
select * from ec_group_purchase_task where 
add_time > UNIX_TIMESTAMP('2017-10-20')
and task_state in ( 10 );

#参与人数
select * from ec_group_purchase_task_member where 
add_time > UNIX_TIMESTAMP('2017-10-20') ;

#支付
select * from ec_group_purchase_task_member where
add_time > UNIX_TIMESTAMP('2017-10-20')
and join_state in (1,6)


#新的SQL语句
#开团数
select * from ec_group_purchase_task_member where
is_creator = 1
and add_time > UNIX_TIMESTAMP('2017-10-20')
and join_state in (1,6);

#成团数
select * from ec_group_purchase_task where 
 # rule_id = '80'
add_time > UNIX_TIMESTAMP('2017-10-20');


#参团数
select * from ec_group_purchase_task_member where
is_creator = 0
and add_time > UNIX_TIMESTAMP('2017-10-20')
and join_state in (1,6);