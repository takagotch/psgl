CREATE FUNCTION item_names () RETURNS SETOF text AS
$$
  DECLARE
    myname text;
    count integer;
    max_id integer;
  BEGIN
    SELECT INTO count min(id) FROM itemlist;
    SELECT INTO max_id max(id) FROM itemlist;

    WHILE count <= max_id LOOP
      SELECT INTO myname name FROM itemlist WHERE id = count;
      IF FOUND THEN
      RETURN NEXT myname;
    END IF;
    count := count + 1;
    END LOOP;
    RETURN;
  END;
$$
LANGUAGE PLpgSQL;

