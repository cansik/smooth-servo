Servo xAxis = new Servo();

void setup()
{
  size(500, 500, FX2D);
}

void draw()
{
  background(255);

  // draw line
  stroke(0);
  strokeWeight(1);
  line(0, height / 2, width, height / 2);

  pushMatrix();
  translate(width / 2, height / 2);
  xAxis.render();
  popMatrix();

  // fps
  fill(0);
  text("Position: " + xAxis.position + "°", 20, 20);
}

void keyPressed()
{
   xAxis.write((int)random(0, 180));
}