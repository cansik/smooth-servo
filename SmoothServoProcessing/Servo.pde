class Servo
{
  int position = 90;

  public Servo()
  {
  }

  public void write(int position)
  {
    this.position = position;

    OscMessage msg = new OscMessage("/1/servo");

    msg.add((float)map(position, 0, 180, 0, 1));
    oscP5.send(msg, broadCast);
  }

  public void render()
  { 
    fill(89, 171, 227);
    noStroke();
    rectMode(CENTER);
    rotate(radians(90 + position));
    rect(0, 50, 30, 100, 7);

    fill(89, 171, 227);
    noStroke();
    ellipse(0, 0, 30, 30);

    noFill();
    stroke(0);
    ellipse(0, 0, 15, 15);
  }
}