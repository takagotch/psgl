CREATE FUNCTION item_names() RETURNS SETOF text AS
$$
DECLARE
  myname text;
  min_id integer;
  max_id integer;
BEGIN
  SELECT INTO min_id min(id) FROM itemlist;
  SELECT INTO max_id max(id) FROM itemlist;
  FOR count IN min_id..max_id LOOP 
    SELECT INTO myname name FROM itemlist WHERE id = count;
    IF FOUND THEN
      RETURN NEXT myname;
    END IF;
  END LOOP;
  RETURN;
END;
$$
LANGUAGE PLpgSQL;


