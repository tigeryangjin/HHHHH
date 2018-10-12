------微刊专题
select count(distinct ip),count(distinct vid) from fact_page_view where visit_date_key between 20171001 and 20171002 
and url like '%wkzt%'

------微刊商品
select count(distinct ip),count(distinct vid) from fact_page_view where visit_date_key between 20171001 and 20171002 
and url like '%wksp%'


