--1.
DROP INDEX GS_GOODS_KEY;
--2.
CALL YJ_OPTIMIZATION.ALTER_TABLE_SHRINK_SPACE('FACT_GOODS_SALES');
--3.
create index GS_GOODS_KEY on FACT_GOODS_SALES(TO_NUMBER(SUBSTR(TO_CHAR(GOODS_KEY),
                                                               1,
                                                               6))) 
  tablespace BDUDATAORDER 
	pctfree 10 
	initrans 2 
	maxtrans 255 
	storage(initial 64K next 1M
          minextents 1
          maxextents
          unlimited);
