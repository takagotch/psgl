CREATE FUNCTION item_names() RETURNS SETOF text AS
$$
  DECLARE
    myname text;
    count integer;
    max_id integer;
  BEGIN
    SELECT INTO count min(id) FROM itemlist;
    SELECT INTO max_id(id) FROM itemlist;

    LOOP
      EXIT WHEN max_id < count;
      SELECT INTO myname name FROM itemlist WHERE id = count;
      IF FOUND THEN
      RETURN NEXT myname;
    END IF;
    
    count := count + 1;
    END LOOP;
  END;
$$
LANGUAGE PLpgSQL;

