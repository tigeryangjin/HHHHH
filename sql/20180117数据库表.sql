SELECT A.owner,
       A.table_name,
       B.COMMENTS,
       REGEXP_SUBSTR(B.COMMENTS, 'yangjin') DEVELOPER,
       (select MAX(last_ddl_time)
          from user_objects
         where object_name = A.table_name) LAST_DDL_TIME
  FROM ALL_ALL_TABLES A, ALL_TAB_COMMENTS B
 WHERE A.owner = B.OWNER
   AND A.table_name = B.TABLE_NAME
   AND A.owner IN ('DW_USER', 'ML')
 ORDER BY A.owner, A.table_name;

--TMP
UPDATE ALL_TAB_COMMENTS A SET A.COMMENTS=A.COMMENTS||'by yangjin' WHERE A.OWNER='ML';

SELECT * FROM ALL_ALL_TABLES A WHERE A.owner = 'DW_USER';
SELECT * FROM ALL_TABLES A WHERE A.OWNER = 'DW_USER';
SELECT * FROM user_tables;

SELECT * FROM ALL_ALL_TABLES A WHERE A.owner = 'DW_USER';
select * from all_tab_comments;
SELECT * FROM USER_OBJECTS;

select uat.table_name as ����,
       (select last_ddl_time
          from user_objects
         where object_name = uat.table_name) as ����޸�����
  from user_all_tables uat;
