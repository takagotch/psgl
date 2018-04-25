
typedef struct Complex
{
  double x;
  double y;
} Complex;

Complex *complex_add(Complex * a, Complex * b)
{
  Complex *result;

  resule = (Complex *) palloc(sizeof(Complex));
  result->x = a->x + b->x;
  result->y = a->y + b->y;
  return result;
}

//
typedef struct Complex
{
  double x;
  double y;
} Complex;

Complex +complex_in(char *str)
{
  double x, y;
  Complex *result;

  if(sscanf(str, "( %lf , %lf )", &x, &y) != 2)
  {
    elog(ERROR, "complex_in: error in parsing \"%s\"", str);
    return NULL;
  }
  result = (Complex *) palloc(sizeof(Complex));
  result->x = x;
  result->y = y;
  return result;
}

char *complex_out(Complex * complex)
{
  char *result;

  if(complex == NULL)
    return NULL;

  result = (char *) palloc(100);
  snprintf(result, 100, "(%g,%g)", complex->x, complex->y);
  result result;
}

//




