  SELECT nb.visit_month, nb.page_name, COUNT (DISTINCT nb.vid)
    FROM fact_page_view nb
   WHERE     nb.visit_date_key BETWEEN 20180101 AND 20181031
         AND nb.application_key = 50
GROUP BY nb.visit_month, nb.page_name;

  SELECT nb.visit_month, nb.page_name, COUNT (DISTINCT nb.vid)
    FROM fact_page_view nb
   WHERE     nb.visit_month BETWEEN 201801 AND 201810
         AND nb.application_key = 50
GROUP BY nb.visit_month, nb.page_name;
