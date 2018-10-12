SELECT * FROM dim_good_cost_tmp;
select * from dim_good_cost;

--dim_good_cost
select to_number(yy.matnr) as item_code,
       yy.pb00 as cost_price,
       yy.zp01 as sale_price,
       yy.datab as report_date,
       yy.datbi as valid_date,
       to_number(to_char(sysdate, 'yyyymmdd')) as create_date
  from (select matnr, max(pricenum) as maxpricenum
          from new_ztmm023 aa
         where aa.datbi >= '20990101'
           and aa.datab <= to_char(sysdate, 'yyyymmdd')
         group by matnr) xx,
       (select distinct matnr,
                        pb00,
                        zp01,
                        datab,
                        max(datbi) as datbi,
                        pricenum
          from new_ztmm023 aa
         where aa.datbi >= '20990101'
           and aa.datab <= to_char(sysdate, 'yyyymmdd')
         group by aa.matnr, aa.pb00, zp01, datab, aa.pricenum) yy
 where xx.matnr = yy.matnr
   and xx.maxpricenum = yy.pricenum;

--dim_good_cost_tmp
select to_number(yy.matnr) as item_code,
       yy.pb00 as cost_price,
       yy.zp01 as sale_price,
       yy.datab as report_date,
       yy.datbi as valid_date,
       to_number(to_char(sysdate, 'yyyymmdd')) as create_date
  from (select matnr, max(pricenum) as maxpricenum
          from new_ztmm023 aa
         where aa.datbi < '20990101'
           and aa.datbi >= to_char(sysdate, 'yyyymmdd')
           and aa.datab <= to_char(sysdate, 'yyyymmdd')
         group by matnr) xx,
       (select distinct matnr,
                        pb00,
                        zp01,
                        datab,
                        max(datbi) as datbi,
                        pricenum
          from new_ztmm023 aa
         where aa.datbi < '20990101'
           and aa.datbi >= to_char(sysdate, 'yyyymmdd')
           and aa.datab <= to_char(sysdate, 'yyyymmdd')
         group by aa.matnr, aa.pb00, aa.zp01, datab, aa.pricenum) yy
 where xx.matnr = yy.matnr
   and xx.maxpricenum = yy.pricenum;

select matnr, max(pricenum) as maxpricenum
  from new_ztmm023 aa
 where aa.datbi < '20990101'
   and aa.datbi >= to_char(sysdate, 'yyyymmdd')
   and aa.datab <= to_char(sysdate, 'yyyymmdd')
 group by matnr;
