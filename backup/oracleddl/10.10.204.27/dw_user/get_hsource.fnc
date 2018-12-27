???create or replace function dw_user.get_hsource(hmsccode in varchar2) return number is
  hmscsourceid number;
begin

  select nvl(max(a.hmsc_source_id), 0)
    into hmscsourceid
    from dim_vid_hmsc a
   where a.hmsc_code = hmsccode;

  return(hmscsourceid);

end get_hsource;
/

