SELECT * FROM DIM_GOOD T WHERE T.ITEM_CODE IN (189327, 199749);


SELECT * FROM FACTEC_ORDER;
SELECT * FROM FACT_EC_ORDER_2;

SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%FACTEC_ORDER%';

CREATE TABLE FACT_EC_ORDER_STATE AS
SELECT A.ORDER_ID, A.ORDER_STATE FROM FACTEC_ORDER A WHERE 1 = 2;

