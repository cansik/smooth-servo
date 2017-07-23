class ServoTask
{
  ServoState state;
  ServoTaskStatus status = ServoTaskStatus.CREATED;

  float velocity;
  float acceleration;

  int startPosition;
  int targetPosition;

  float accelerationTarget;
  float linearMotionTarget;
  float decelerationTarget;

  float duration;
  int startTime;

  float accelerationTime;
  float linearMotionTime;
  float decelerationTime;

  float accelerationPath;
  float linearMotionPath;
  float decelerationPath;

  float brakeTarget;
  float brakeTime;
  float brakePath;

  int direction;

  boolean shouldBrake = false;

  public ServoTask(int targetPosition, float velocity, float acceleration)
  {
    this.targetPosition = targetPosition;
    this.velocity = velocity;
    this.acceleration = acceleration;

    this.state = ServoState.ACCELERATION;
  }

  public void start(int startPosition)
  {
    status = ServoTaskStatus.RUNNING;

    this.startPosition = startPosition;
    this.startTime = millis();

    // caluclate time and path
    accelerationTime = calculateMotionTime(0, velocity, acceleration);
    decelerationTime = calculateMotionTime(velocity, 0, acceleration);

    accelerationPath = calculateMotionPath(0, accelerationTime, acceleration);
    decelerationPath = calculateMotionPath(velocity, decelerationTime, acceleration * -1);

    duration = 0;

    // calculate positions
    int pathLength = abs(targetPosition - startPosition);
    direction = getSign(targetPosition - startPosition);

    linearMotionPath = max(0, pathLength - (accelerationPath + decelerationPath));
    linearMotionTime = linearMotionPath / velocity;

    // recalculate accelerationTime if no linear motion possible
    if (linearMotionPath == 0)
    {
      accelerationPath = pathLength / 2;
      decelerationPath = pathLength / 2;

      accelerationTime = calculateMotionTime(acceleration, accelerationPath);
      decelerationTime = calculateMotionTime(acceleration, decelerationPath);
    }

    duration = accelerationTime + linearMotionTime + decelerationTime;

    accelerationTarget = startPosition + (direction * accelerationPath);
    linearMotionTarget = accelerationTarget + (direction * linearMotionPath);
    decelerationTarget = linearMotionTarget + (direction * decelerationPath);

    println("New Task:");

    println("acceleration: " + acceleration);
    println("maxVelocity: " + velocity);

    println("AccP: " + accelerationPath);
    println("LinP: " + linearMotionPath);
    println("DecP: " + decelerationPath);

    println("----");

    println("AccT: " + accelerationTime);
    println("LinT: " + linearMotionTime);
    println("DecT: " + decelerationTime);

    println("----");

    println("Start: " + startPosition);
    println("Target: " + targetPosition);

    println("AccS: " + accelerationTarget);
    println("LinS: " + linearMotionTarget);
    println("DecS: " + decelerationTarget);

    println("---");
    println("duration: " + duration);
  }

  public void stop()
  {
    // difference to break start
    int position = nextPosition(0);
    float diffToBreak = linearMotionTarget - position;

    shouldBrake = true;

    if (state == ServoState.LINEARMOTION)
    {
      startTime = millis();
      startPosition = position;
      brakeTime = calculateMotionTime(velocity, 0, acceleration);
      brakePath = calculateMotionPath(velocity, brakeTime, acceleration * -1);
      brakeTarget = startPosition + (direction * brakePath);

      state = ServoState.BRAKE;

      println("Stopping, current: " + position + " diff: " + diffToBreak);
    }
  }

  public int nextPosition(int currentPosition)
  {
    // fix for 0 or 1 motion
    if (abs(targetPosition - startPosition) < 2)
    {
      status = ServoTaskStatus.FINISHED;
      return targetPosition;
    }

    switch(state)
    {
    case ACCELERATION:
      return acceleration();

    case LINEARMOTION:
      return linearMotion();

    case DECELERATION:
      return deceleration();

    case BRAKE:
      return brake();
    }

    return 0;
  }

  // t = current time, b = start value, c = change in value, d = duration

  public int acceleration()
  {
    float t = millis() - startTime;
    float b = startPosition;
    float c = accelerationTarget - startPosition;
    float d = accelerationTime;

    // check state switch
    if (t >= d)
    {
      state = ServoState.LINEARMOTION;
      if (shouldBrake)
      {
        stop();
      }
    }

    return Math.round(easeInQuad(t, b, c, d));
  }

  public int linearMotion()
  {
    float t = millis() - (startTime + accelerationTime);
    float b = accelerationTarget;
    float c = linearMotionTarget - accelerationTarget;
    float d = linearMotionTime;

    // check state switch
    if (t >= d)
    {
      state = ServoState.DECELERATION;
      println("changing to deceleration state");
    }

    if (d <= 0)
    {
      // skip linear motion
      return deceleration();
    }

    return Math.round(linearTween(t, b, c, d));
  }

  public int deceleration()
  {
    float t = millis() - (startTime + accelerationTime + linearMotionTime);
    float b = linearMotionTarget;
    float c = decelerationTarget - linearMotionTarget;
    float d = decelerationTime;

    // check state switch
    if (t >= d)
    {
      status = ServoTaskStatus.FINISHED;
    }

    return Math.round(easeOutQuad(t, b, c, d));
  }

  public int brake()
  {
    float t = millis() - startTime;
    float b = startPosition;
    float c = brakeTarget - startPosition;
    float d = brakeTime;

    // check state switch
    if (t >= d)
    {
      status = ServoTaskStatus.FINISHED;
    }

    return Math.round(easeOutQuad(t, b, c, d));
  }

  private int getSign(int n)
  {
    return n >= 0 ? 1 : -1;
  }

  private float calculateMotionTime(float vI, float vF, float a)
  {
    return Math.abs((vF - vI) / a);
  }

  private float calculateMotionPath(float vI, float t, float a)
  {
    return Math.round(((vI * t) + (0.5 * a * Math.pow(t, 2))));
  }

  private float calculateMotionTime(float a, float d)
  {
    return Math.round(Math.sqrt(2 * d / a));
  }
}