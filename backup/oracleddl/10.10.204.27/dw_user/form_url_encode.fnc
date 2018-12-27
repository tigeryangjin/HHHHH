???create or replace function dw_user.form_url_encode(data    IN VARCHAR2,charset IN VARCHAR2) return  VARCHAR2 is
begin
  RETURN utl_url.escape(data, TRUE, charset); -- note use of TURE
end form_url_encode;
/

