-----��Ա��ת���'΢�š�
select  (case when END_ACTIVE_VID like '%iphone%' then 'APP'
                when END_ACTIVE_VID like '%android%' then 'APP'
                when END_ACTIVE_VID like '%wxoeNKj%' then 'WX'
                 ELSE 'qita' end  ),count(1),REGISTER_RESOURCE,
                   (CASE WHEN FIRST_ACTIVE_DATE_KEY=END_ACTIVE_DATE_KEY THEN '��ʧ'
                   ELSE '����'  END )  from  dim_member where 
FIRST_ACTIVE_DATE_KEY  between 20180101 and 20180331 and FIRST_ACTIVE_VID like '%wxoeNKjj%'
group by  (case when END_ACTIVE_VID like '%iphone%' then 'APP'
                when END_ACTIVE_VID like '%android%' then 'APP'
                when END_ACTIVE_VID like '%wxoeNKj%' then 'WX'
                 ELSE 'qita' end  ),REGISTER_RESOURCE,
                   (CASE WHEN FIRST_ACTIVE_DATE_KEY=END_ACTIVE_DATE_KEY THEN '��ʧ'
                   ELSE '����'  END );
                   

-----��Ա��ת���'APP��
select  (case when END_ACTIVE_VID like '%iphone%' then 'APP'
                when END_ACTIVE_VID like '%android%' then 'APP'
                when END_ACTIVE_VID like '%wxoeNKj%' then 'WX'
                 ELSE 'qita' end  ),count(1),REGISTER_RESOURCE,
                   (CASE WHEN FIRST_ACTIVE_DATE_KEY=END_ACTIVE_DATE_KEY THEN '��ʧ'
                   ELSE '����'  END )  from  dim_member where 
FIRST_ACTIVE_DATE_KEY  between 20180101 and 20180331
 and( FIRST_ACTIVE_VID like '%iphone%' OR  FIRST_ACTIVE_VID like '%android%') 
group by  (case when END_ACTIVE_VID like '%iphone%' then 'APP'
                when END_ACTIVE_VID like '%android%' then 'APP'
                when END_ACTIVE_VID like '%wxoeNKj%' then 'WX'
                 ELSE 'qita' end  ),REGISTER_RESOURCE,
                   (CASE WHEN FIRST_ACTIVE_DATE_KEY=END_ACTIVE_DATE_KEY THEN '��ʧ'
                   ELSE '����'  END )  ;           
