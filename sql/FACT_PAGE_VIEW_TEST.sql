--1.
CREATE TABLE FACT_PAGE_VIEW_YJ AS 
SELECT * FROM FACT_PAGE_VIEW T WHERE T.VISIT_DATE_KEY=20170524;

--2. Create/Recreate indexes 
create index FACT_PAGE_VIEW_YJ_I1 on FACT_PAGE_VIEW_YJ (IP_INT)
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

--3.
SELECT B.IP_CITY, COUNT(1)
  FROM (SELECT A.IP, A.IP_INT, get_ip_city(A.IP_INT) IP_CITY
          FROM FACT_PAGE_VIEW_YJ A) B
 GROUP BY B.IP_CITY;
 
SELECT T.IP_CITY, COUNT(1) FROM DIM_IP_GEO T GROUP BY T.IP_CITY;
SELECT T.IP_START, T.IP_END, COUNT(1)
  FROM DIM_IP_GEO T
 GROUP BY T.IP_START, T.IP_END
HAVING COUNT(1) > 1;
