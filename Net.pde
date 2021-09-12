class Net
{
  private int[] shape;
  private Matrix[] weights;
  private Matrix[] biases;
  private float trainingRate;
  private Matrix[] z; //z value of each node
  private Matrix[] a;
  private Matrix[] gradWeights;
  private Matrix[] gradBiases;
  private Matrix output;

  public Net(int[] s, float r)  //instantiates net with random weights and biases
  {
    trainingRate = r;
    shape = s;
    z = new Matrix[s.length];
    a = new Matrix[s.length];
    for (int i = 0; i < shape.length; i++)
    {
      z[i] = new Matrix(shape[i], 1);
      a[i] = new Matrix(shape[i], 1);
    }
    weights = new Matrix[s.length-1];//actually instantiate weights and biases!
    gradWeights = new Matrix[s.length-1];
    for (int i = 0; i < weights.length; i++)
    {
      float[][] inst = new float[s[i+1]][s[i]];
      for (int j = 0; j < inst.length; j++)
      {
        for (int k = 0; k < inst[0].length; k++)
          inst[j][k] = randomGaussian()/((float)Math.sqrt(s[i]));
      }
      weights[i] = new Matrix(inst);
      gradWeights[i] = new Matrix(s[i+1], s[i]);
    }
    biases = new Matrix[s.length-1];
    gradBiases = new Matrix[s.length-1];
    for (int i = 0; i < biases.length; i++)
    {
      biases[i] = new Matrix(s[i+1], 1);
      gradBiases[i] = new Matrix(s[i+1], 1);
    }
  }

  public void train(Training[] tData, int reps, int batchSize)
  {
    List<Training> temp = Arrays.asList(tData);
    Collections.shuffle(temp);
    for (int i = 0; i < temp.size(); i++)
    {
      tData[i] = temp.get(i);
    }
    for (int e = 0; e < reps; e++)
    {
      for (int i = 0; i < tData.length/batchSize; i++)
      {
        Training[] batch = new Training[batchSize];
        for (int j = i*batchSize; j < i*batchSize+batchSize; j++)
        {
          batch[j-i*batchSize] = tData[j];
        }
        trainBatch(batch, trainingRate);
      }
      System.out.println("E" + e + ": " + n.test(tests));
    }
  }

  public float test(Training[] tData)
  {
    float correct = 0;
    for (Training t : tData)
    {
      if (getGuess(t.input) == t.getLabel())
      {
        correct++;
      }
    }
    return correct/tData.length;
  }

  public Matrix predict(Matrix a)
  {
    Matrix input = a;
    z[0] = input;
    this.a[0] = input;
    for (int i = 0; i < shape.length-1; i++)
    {
      z[i+1] = (weights[i].multiply(input)).addMatrix(biases[i]);
      input = z[i+1].sigmoid();
      this.a[i+1] = input;
    }
    output = input;
    return output;
  }

  public int getGuess(Matrix t)
  {
    predict(t);
    float max = 0;
    int guess = 0;
    for (int j = 0; j < output.rows; j++)
    {
      float n = output.getNum(j, 0);
      if (n > max)
      {
        max = n;
        guess = j;
      }
    }
    return guess;
  }

  public float calcCostBinary(Training t)
  {
    predict(t.input);
    float cost = 0;
    for (int i = 0; i < output.rows; i++)
    {
      cost += (float)(pow(t.output.getNum(i, 0)-output.getNum(i, 0), 2)*.5);
    }
    return cost;
  }
  
  public float calcCostEntropy(Training t)
  {
    predict(t.input);
    float cost = 0;
    for(int i = 0; i < output.rows; i++)
    {
      float yi = t.output.getNum(i,0);
      float ai = output.getNum(i,0);
      cost += (float)(yi*log(ai)+(1-yi)*log(1-ai));
    }
    return -cost;
    
  }

  private Matrix gradCostA(Training t)
  {
    return output.addMatrix(t.output.multiply(-1));
  }

  public void backprop(Training t)
  {
    Matrix[] errors = new Matrix[shape.length-1];
    errors[errors.length-1] = 
      gradCostA(t).hadamardProduct(z[shape.length-1].dsigmoid());
    //initial error
    for (int i = errors.length-2; i >=0; i--)
    {
      errors[i] = ((weights[i+1].getTranspose()).multiply(errors[i+1])).
        hadamardProduct(z[i+1].dsigmoid());
    }
    for(int i = 0; i < shape.length-1; i++)
    {
      gradWeights[i] = errors[i].multiply(a[i].getTranspose());
      gradBiases[i] = errors[i];
    }
  }

  public float trainBatch(Training[] batch, float lRate)
  {
    float totalCost = 0;
    Matrix[] delW = new Matrix[weights.length];
    Matrix[] delB = new Matrix[biases.length];
    for (int i = 0; i < shape.length-1; i++)
    {
      delW[i] = new Matrix(weights[i].rows, weights[i].cols);
      delB[i] = new Matrix(biases[i].rows, biases[i].cols);
    }
    for (Training t : batch)
    {
      totalCost += calcCostBinary(t);
      backprop(t);
      for (int i = 0; i < shape.length-1; i++)
      {
        delW[i] = delW[i].addMatrix(gradWeights[i]);
        delB[i] = delB[i].addMatrix(gradBiases[i]);
      }
      for (int i = 0; i < shape.length-1; i++)
      {
        weights[i] = weights[i].addMatrix(delW[i].multiply(-1*lRate/batch.length));
        biases[i] = biases[i].addMatrix(delB[i].multiply(-1*lRate/batch.length));
      }
    }
    return totalCost;
  }
}
