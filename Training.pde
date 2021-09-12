class Training
{
  private Matrix input;
  private Matrix output;
  private float label;

  public Training(Matrix i, Matrix o)
  {
    input = i;
    output = o;
  }

  public float getLabel()
  {
    float max = 0;
    for (int j = 0; j < output.rows; j++)
    {
      float n = output.getNum(j, 0);
      if (n > max)
      {
        max = n;
        label = j;
      }
    }
    return label;
  }
}
