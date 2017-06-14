Servo xAxis = new Servo();
SmoothServo smoothXAxis;

void setup()
{
  size(500, 500, FX2D);

  // max speed = 180 ms per 60° -> 0.3333° per 1ms
  smoothXAxis = new SmoothServo(xAxis, 60.0 / 180.0, 0.05);
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
  int target = 9; //(int)random(0, 180);

  println("Moving to " + target + "°");

  smoothXAxis.moveTo(target, 0.5);
}