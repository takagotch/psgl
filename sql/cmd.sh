//CREATE OPERATOR,DROP OPERATOR
cd ~/src
gmake
cp complex.so /usr/local/pgsql/lib

CREATE FUNCTION complex_add(complex, complex)
  RETURNS complex
  AS '/usr/local/pgsql/lib/complex'
  LANGUAGE C;
CREATE FUNCTION

CREATE OPERAOR + (
  leftarg = complex,
  rigntarg = complex,
  procedure = complex_add,
  commurator = +);
CREATE OPERAOR

SELECT comp1, comp2, (comp1 + comp2) AS "comp1 + comp2"
  FROM complex_pair;

DROP OPERATOR + (complex, complex);
DROP OPERAROR

//

//
//
//
//




