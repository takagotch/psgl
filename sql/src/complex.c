
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






