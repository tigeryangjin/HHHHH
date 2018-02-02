SELECT * FROM DIM_EC_GOOD;
SELECT * FROM DIM_GOOD;
SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%UPDATE%DIM_GOOD%';
SELECT DISTINCT LENGTH(A.ITEM_CODE) FROM DIM_GOOD A;
SELECT DISTINCT LENGTH(A.ITEM_CODE) FROM DIM_EC_GOOD A;

select *
  from (select cast(0 as string) as user, cast(0 as string) as item
          from dual
        union all
        select cast(0 as string) as user, cast(1 as string) as item
          from dual
        union all
        select cast(1 as string) as user, cast(0 as string) as item
          from dual
        union all
        select cast(1 as string) as user, cast(1 as string) as item
          from dual) a;
