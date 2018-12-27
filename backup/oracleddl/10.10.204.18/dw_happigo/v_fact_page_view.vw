???create or replace force view dw_happigo.v_fact_page_view as
select "ID","PAGE_VIEW_KEY","VID","IP","URL","PAGE_KEY","PAGE_NAME","PAGE_VALUE","LAST_PAGE_KEY","HMSC_KEY","HMSC","HMMD","HMPL","HMKW","HMCI","APPLICATION_KEY","APPLICATION_NAME","IP_GEO_KEY","VISIT_DATE_KEY","VISIT_DATE","PAGEBEGIN_TIME","PAGEEND_TIME","PAGE_STAYTIME_KEY","PAGE_STAYTIME","VISITOR_KEY","SESSION_KEY","MEMBER_KEY","HOUR_KEY","HOUR","CHANNEL_KEY","VER_KEY","VER_NAME","AGENT" from fact_page_view T where visit_date >= to_date('20150101','yyyymmdd');
