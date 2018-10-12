Hi， 你能查到去年17年5月和6日， APP 搜索最多的TOP 10 关键词是什么吗？ 

-----
select SKW,count(1) from fact_search where  CREATE_DATE_KEY between 20170601 and 20170631
group by SKW 



-----
select  CREATE_DATE_KEY,count(1) from   fact_visitor_register where vid in(
select SNAME from ls_test1)  group by CREATE_DATE_KEY
