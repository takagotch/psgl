user_id INTEGER;
quantity NUMBERIC(5);
url TEXT;

CREATE FUNCTION get_customer_data (idx int) RETURNS customerlist AS
$$
  DECLARE
    customer_data customerlisr%ROWTYPE;
  BEGIN
    SELECT * INTO customer_data FROM customerlist WHERE id = idx;
    RETURN customer_data;
  END;
$$
LANGUAGE PLpgSQL;

CREATE FUNCTION get_customer_name (idx int) RETURNS text AS
$$
  DECLARE
	customer_data customerlist%ROWTYPE;
  BEGIN
	SELECT * INTO customer_data FROM customerlist WHERE id = idx;
	RETURN customer_data;
  END;
$$
LANGUAGE PLpgSQL;





CREATE FUNCTION get_customer_data (int) RETURNS customerlist AS
'
  DECLARE
    idx ALIAS FOR $1;
    customer_data customerlist%ROWTYPE;
  BEGIN
    SELECT * INTO customer_name FROM customerlist WHERE id = idx;
    RETURN customer_name;
  END;
'
LANGUAGE PLpgSQL;

CREATE FUNCTION get_customer_name (int) RETURNS text AS
'
  DECLARE
    idx ALIAS FOR $1;
     customer_name customerlist.name%TYPE;
  BEGIN
    SELECT name INTO customer_name FROM customerlist WHERE id = idx;
    RETURN customer_name;
  END;
'
LANGUAGE PLpgSQL;






