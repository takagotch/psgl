CREATE FUNCTION get_customer_name (idx int) RETURNS text AS
$$
  DECLARE
    select_data RECORD;
  BEGIN
    SELECT * INTO select_data FROM customerlist WHERE id = idx;
    RETURN select_data.name;
  END;
$$
LANGUAGE PLpgSQL;


CREATE FUNCTION get_customer_name (int) RETURNS text AS
'
DECLARE
  idx ALIAS FOR $1;
  select_data RECORD;
BEGIN
  SELECT * INTO select_data FROM customerlist WHERE id = idx;
  RETURN select_data.name;
END;
'
LANGUAGE PLpgSQL;


