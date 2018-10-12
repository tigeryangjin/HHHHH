---会员池  
select  count(distinct(MEMBER_KEY))from fact_page_view  where
 visit_date_key between 20180401 and 20180531  ;


---新增会员

select count(1)from  fact_ecmember  where MEMBER_TIME between 20180501 and 20180531 ;

---流失会员


select count(distinct(MEMBER_KEY)) from fact_session where  
START_DATE_KEY   between 20180301 and 20180331  
and  MEMBER_KEY  not in (
select distinct(MEMBER_KEY) from  fact_session where  
START_DATE_KEY   between 20180401 and 20180531  
) 
;

---唤醒会员

select  count(distinct(MEMBER_KEY)) from fact_session where  
START_DATE_KEY   between 20180501 and 201804531   
and member_key in

(select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME<=20180231  ) 
and member_key not in 
(select distinct(MEMBER_KEY) from  fact_session where  
START_DATE_KEY   between  20180301 and 20180431   
);

