SELECT *
  FROM (select VID, VISIT_DATE
          from fact_page_view
         where visit_date_key = 20180101
           and page_name = 'TV_QRC') a
  LEFT JOIN (SELECT TV_START_TIME, TV_END_TIME, ITEM_CODE
               FROM DIM_TV_GOOD
              where TV_STARTDAY_KEY = 20180101) b
    on a.VISIT_DATE between b.TV_START_TIME and b.TV_END_TIME;

SELECT A.JUAN_NAME CODE_TITLE, A.JUAN_NO CODE
  FROM ML.YANGJIN_JUAN A
 WHERE A.JUAN_NAME = '40ÔªÏÖ½ðÈ¯'
 ORDER BY A.JUAN_NAME, A.JUAN_NO;
