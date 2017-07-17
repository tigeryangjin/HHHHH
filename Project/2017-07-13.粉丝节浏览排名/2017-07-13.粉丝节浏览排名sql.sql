/*
application_key=50 20170101-20170330
浏览页面排名
商品分类排名
*/

--页面浏览人数
select b.page_name, count(b.member_key)
  from (select a.page_name, a.page_value, a.member_key
          from fact_page_view a
         where a.visit_date_key between 20170101 and 20170330
           and a.application_key = 50
           and a.member_key <> 0) b
 group by b.page_name
 order by count(b.member_key) desc;

--商品浏览排名
select c.page_name,
       d.item_code,
       d.goods_name,
       d.matdl,
       d.matdlt,
       c.member_count
  from (select b.page_name, b.page_value, count(b.member_key) member_count
          from (select a.page_name, a.page_value, a.member_key
                  from fact_page_view a
                 where a.visit_date_key between 20170101 and 20170330
                   and a.application_key = 50
                   and a.page_name = 'Good'
                   and a.member_key <> 0
                   and a.page_value =
                       translate(a.page_value,
                                 '0' ||
                                 translate(a.page_value, '#0123456789', '#'),
                                 '0')) b
         group by b.page_name, b.page_value) c,
       dim_good d
 where c.page_value = d.goods_commonid
 order by c.member_count desc;
