class ZButton
{
  float x, y, len, wid;
  String text;
  boolean isPressed;
  boolean shown;
  
  ZButton(float x1, float y1, float x2, float y2, String t)
  {
    x = x1;
    wid = x2;
    y = y1;
    len = y2;
    text = t;
    isPressed = false;
    shown = false;
  }
  
  void show()
  {
    shown = true;
    stroke(50);
    strokeWeight(1);
    fill(255);
    if(clicked())
    {
      fill(230); 
    }
    rect(x, y, wid, len, 7);
    textFont(f,26);
    fill(0);
    if(isOver())
    {
      fill(100); 
    }
    text(text, x + wid / 2 - 7 * text.length(), y + len / 2 + 6);
  }
  
  boolean isOver()
  {
    if(mouseX > x && mouseX < x + wid && mouseY > y && mouseY < y + len)
    {
      return true; 
    }
    else return false;
  }
  
  boolean clicked()
  {
    if(isOver() && mousePressed == true)
    {
      return true;
    }
    else return false;
  }
}
