class Matrix
{
  private int rows;
  private int cols;
  private float[][] nums;

  public Matrix(float[][] n)
  {
    rows = n.length;
    cols = n[0].length;
    nums = new float[rows][cols];
    for(int i = 0; i < rows; i++)
    {
      for(int j = 0; j < cols; j++)
      {
        nums[i][j] = n[i][j]; 
      }
    }
  }
  
  public Matrix(Matrix m)
  {
    rows = m.rows;
    cols = m.cols;
    nums = new float[rows][cols];
    for(int i = 0; i < rows; i++)
    {
      for(int j = 0; j < cols; j++)
      {
        nums[i][j] = m.nums[i][j]; 
      }
    }
  }
  
  public Matrix(int r, int c)
  {
    rows = r;
    cols = c;
    nums = new float[rows][cols];
  }

  public Matrix multiply(float a)
  {
    Matrix m = new Matrix(nums);
    for (int i = 0; i < rows * cols; i++)
    {
      m.nums[i / cols][i % cols] *= a;
    }
    return m;
  }

  public Matrix multiply(Matrix m)
  {
    float[][] nnums = new float[rows][m.cols];
    for (int i = 0; i < nnums.length; i++)
    {
      for (int j = 0; j < nnums[0].length; j++)
      {
        nnums[i][j] = dotProduct(this.getrow(i), m.getcol(j));
      }
    }
    return new Matrix(nnums);
  }

  public Matrix addMatrix(Matrix m)
  {
    float[][] nnums = new float[rows][cols];
    for (int i = 0; i < nnums.length; i++)
    {
      for (int j = 0; j < nnums[0].length; j++)
      {
        nnums[i][j] = nums[i][j] + m.nums[i][j];
      }
    }
    return new Matrix(nnums);
  }

  public Matrix sigmoid()
  {
    float[][] nnums = new float[rows][cols];
    for (int i = 0; i < nnums.length; i++)
    {
      for (int j = 0; j < nnums[0].length; j++)
      {
        nnums[i][j] = 1/(1+exp(-1*nums[i][j]));
      }
    }
    return new Matrix(nnums);
  }

  public Matrix dsigmoid()
  {
    float[][] nnums = new float[rows][cols];
    for (int i = 0; i < nnums.length; i++)
    {
      for (int j = 0; j < nnums[0].length; j++)
      {
        nnums[i][j] = exp(-1*nums[i][j])/(pow(1+exp(-1*nums[i][j]), 2));
      }
    }
    return new Matrix(nnums);
  }

  public Matrix hadamardProduct(Matrix m)
  {
    float[][] nnums = new float[rows][cols];
    for (int i = 0; i < nnums.length; i++)
    {
      for (int j = 0; j < nnums[0].length; j++)
      {
        nnums[i][j] = nums[i][j]*m.nums[i][j];
      }
    }
    return new Matrix(nnums);
  }

  public Matrix getTranspose()
  {
    float[][] nnums = new float[cols][rows];
    for (int i = 0; i < nnums.length; i++)
    {
      for (int j = 0; j < nnums[0].length; j++)
      {
        nnums[i][j] = nums[j][i];
      }
    }
    return new Matrix(nnums);
  }

  public float[] getrow(int n)
  {
    return nums[n];
  }

  public float[] getcol(int n)
  {
    float[] col = new float[rows];
    for (int i = 0; i < rows; i++)
    {
      col[i] = nums[i][n];
    }
    return col;
  }

  public float getNum(int row, int col)
  {
    return nums[row][col];
  }
  
  public void setNum(int row, int col, float value)
  {
    nums[row][col] = value; 
  }

  public String toString()
  {
    String s = "";
    for (float[] row : nums)
    {
      for (float num : row)
      {
        s = s + num + " ";
      }
      s = s + "\n";
    }
    return s;
  }
}
