import java.util.List;
import java.util.Collections;
import java.util.Arrays;
import java.io.*;

Matrix m1;
Matrix m2;
Net n;
Training t1;
Training t2;
Training t3;
Training t4;
MnistMatrix[] squares;
MnistMatrix[] testsRaw;
Training[] inputTrainings;
Training[] tests;
ZButton guess;
ZButton reset;
PFont f;

void setup()
{
  size(308, 408);
  f = createFont("Arial", 26, true);
  guess = new ZButton(width / 2 - 100, 20, 200, 40, " Submit Guess");
  guess.shown = true;
  reset = new ZButton(width / 2 - 60, 20, 120, 40, "RESET ");
  background(255);

  int[] sizes = {784, 30, 10};
  n = new Net(sizes, .5);

  //Matrix[] inputTrainings = new Matrix[60000];
  //Matrix[] inputLabels = new Matrix[60000];
  inputTrainings = new Training[60000];
  tests = new Training[10000];
  try {
    squares = loadTraining();
    testsRaw = loadTesting();
  }
  catch(IOException e) {
    System.out.println("You messed up");
  }

  for (int i = 0; i < inputTrainings.length; i++)
  {
    inputTrainings[i] = new Training(null, null);
    inputTrainings[i].input = new Matrix(784, 1);
    for (int j = 0; j < 784; j++)
    {
      if (squares[i] != null)
      {
        inputTrainings[i].input.setNum(j, 0, squares[i].getValue(j/28, j%28)/255.0);
      }
    }
    inputTrainings[i].output = new Matrix(10, 1);
    inputTrainings[i].output.setNum(squares[i].getLabel(), 0, 1.0);
  }
  for (int i = 0; i < tests.length; i++)
  {
    tests[i] = new Training(null, null);
    tests[i].input = new Matrix(784, 1);
    for (int j = 0; j < 784; j++)
    {
      if (testsRaw[i] != null)
      {
        tests[i].input.setNum(j, 0, testsRaw[i].getValue(j/28, j%28)/255.0);
      }
    }
    tests[i].output = new Matrix(10, 1);
    tests[i].output.setNum(testsRaw[i].getLabel(), 0, 1.0);
  }

  System.out.println("Data loaded");
  System.out.println();
  n.train(inputTrainings, 1, 100);
  System.out.println();
  System.out.println("Done training!");
}

void draw()
{
  if (guess.shown) guess.show();
  else { 
    fill(255);
    noStroke();
    rect(width/2-100, 10, 201, 51);
  }
  if (reset.shown) reset.show();
  stroke(0);
  strokeWeight(25);
  line(0, 85, width, 85);
  if (mousePressed == true && !guess.isOver()) {
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}

public MnistMatrix[] loadTraining() throws IOException {
  MnistMatrix[] mnistMatrix = new MnistDataReader().readData(dataPath("") +"/train-images.idx3-ubyte", dataPath("") +"/train-labels.idx1-ubyte");
  return mnistMatrix;
}

public MnistMatrix[] loadTesting() throws IOException {
  MnistMatrix[] mnistMatrix = new MnistDataReader().readData(dataPath("") +"/t10k-images.idx3-ubyte", dataPath("") +"/t10k-labels.idx1-ubyte");
  return mnistMatrix;
}




public static float dotProduct(float[] i, float[] j)
{
  float sum = 0;
  for (int n = 0; n < i.length; n++)
  {
    sum += i[n]*j[n];
  }
  return sum;
}

void mousePressed()
{
  if (guess.clicked() && guess.shown)
  {
    Matrix t = captureScreen();
    text("My guess: " + n.getGuess(t), width/2-30, height-6);
    guess.shown = false;
    reset.shown = true;
  } else if (reset.clicked() && reset.shown)
  {
    background(255);
    guess.shown = true;
    reset.shown = false;
  }
}

Matrix captureScreen()
{
  Matrix screen = new Matrix(784, 1);
  int res = width/28;
  loadPixels();
  for (int i = 0; i < 784; i++)
  {
    float avg = 0;
    for (int r = 100+res*(i/28); r < 100+res+res*(i/28); r++)
    {
      for (int w = res*(i%28); w < res*(i%28)+res; w++)
      {
        avg+=255-pixels[w+r*width]&0xff;
      }
    }

    screen.setNum(i, 0, (avg/(res*res))/255f);
    for (int r = 100+res*(i/28); r < 100+res+res*(i/28); r++)
    {
      for (int w = res*(i%28); w < res*(i%28)+res; w++)
      {
        set(w, r, color(255-(avg/(res*res))));
      }
    }
  }
  
  return screen;
}
