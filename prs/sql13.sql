CREATE FUNCTION item_names() RETURNS SETOF text AS
$$
  DECLARE
    names text;
    unbound_cursor refcursor;
    tmp_name itemlist.name%TYPE;
  BEGIN
    OPEN unbound_cursor FOR SELECT name FROM itemlist;
    LOOP
      FETCH unbound_cursor INTO tmp_name;
      EXIT WHEN NOT FOUND;
      names := tmp_name;
      RETURN NEXT names;
    END LOOP;
    CLOSE unbound_cursor;
    RETURN;
  END;
$$
LANGUAGE PLpgSQL;



CREATE FUNCTION item_names() RETURNS SETOF SETOF text AS
$$
  DECLARE
    names text; 
    bound_cursor CURSOR FOR SELECT name FROM itemlist;
    tmp_name itemlist.name%TYPE;
    OPEN bound_cursor;
    LOOP
      FETCH bound_cursor INTO tmp_name;
      EXIT WHEN NOT FOUND;
      names := *tmp_name;
      RETURNS NEXT names;
    END LOOP;
    CLOSE bound_cursor;
    RETURN;
  END;
$$
LANGUAGE PLpgSQL;



