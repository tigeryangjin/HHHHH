---Ð¡Ã×Ö±²¥

select COUNT(DISTINCT(VID)) ,COUNT(1) from fact_page_view s where s.visit_date_key=20161121
 and s.page_name='WZT2' AND S.PAGE_VALUE='GqgWSl1hR1cvBVC'

AND S.APPLICATION_KEY>20 

SELECT * FROM FACTEC_ORDER W WHERE W.ADD_TIME=20161121  AND W.ORDER_FROM=77 

SELECT COUNT(1),COUNT(DISTINCT(IP)) FROM fact_page_view WHERE 
visit_date_key=20161121 and page_name='Good' AND ip in (
select DISTINCT(ip) from fact_page_view s where s.visit_date_key=20161121 and s.page_name='WZT2' AND S.PAGE_VALUE='GqgWSl1hR1cvBVC'

AND S.APPLICATION_KEY>20
) AND APPLICATION_KEY>20



select count(1),count(distinct(vid)) from fact_page_view aa where
  aa.visit_date_key between 20161103 and 20161127 and aa.page_name='Video_home'

730743  164759



select * from factec_order where  ADD_TIME=20161123 and ORDER_AMOUNT>20000
select count(distinct(vid)),APPLICATION_KEY,LEVEL1,LEVEL2  from 
(SELECT a.vid as vid ,CREATE_DATE_KEY,APPLICATION_KEY,LEVEL1,LEVEL2 FROM (
SELECT VID,CREATE_DATE_KEY,APPLICATION_KEY FROM FACT_VISITOR_REGISTER WHERE CREATE_DATE_KEY>20160401 AND APPLICATION_KEY IN(30,40)
) A LEFT JOIN (
select VID,LEVEL1,LEVEL2 from fact_visitor_active where LEVEL1 IN ('SEM','DSP','CPS')  
GROUP BY  VID,LEVEL1,LEVEL2)B
ON A.VID=B.VID) where LEVEL1 is not null   group by APPLICATION_KEY,LEVEL1,LEVEL2
