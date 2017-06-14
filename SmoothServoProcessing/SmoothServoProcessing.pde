Servo xAxis = new Servo();
SmoothServo smoothXAxis;

void setup()
{
  size(500, 500, FX2D);
  smoothXAxis = new SmoothServo(xAxis);
}

void draw()
{
  background(255);

  // update smooth servo
  smoothXAxis.update();

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
  int target = (int)random(0, 180);
  int time = 500;

  println("Moving to " + target + "° in " + time + "ms!");

  smoothXAxis.moveTo(target, time);
}