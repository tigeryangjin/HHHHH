Hi�� ���ܲ鵽ȥ��17��5�º�6�գ� APP ��������TOP 10 �ؼ�����ʲô�� 

-----
select SKW,count(1) from fact_search where  CREATE_DATE_KEY between 20170601 and 20170631
group by SKW 



-----
select  CREATE_DATE_KEY,count(1) from   fact_visitor_register where vid in(
select SNAME from ls_test1)  group by CREATE_DATE_KEY
