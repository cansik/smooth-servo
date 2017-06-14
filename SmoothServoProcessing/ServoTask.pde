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

  int direction;

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

    duration = accelerationTime + linearMotionTime + decelerationTime;

    accelerationTarget = startPosition + (direction * accelerationPath);
    linearMotionTarget = accelerationTarget + (direction * linearMotionPath);
    decelerationTarget = linearMotionTarget + (direction * decelerationPath);

    println("New Task:");

    println("acceleration: " + acceleration);
    println("maxVelocity: " + velocity);

    println("duration: " + duration);

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
  }

  public int nextPosition(int currentPosition)
  {
    switch(state)
    {
    case ACCELERATION:
      return acceleration();

    case LINEARMOTION:
      return linearMotion();

    case DECELERATION:
      return deceleration();
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
      //status = ServoTaskStatus.FINISHED;
      println("changing to linear motion state");
    }

    return Math.round(easeInSine(t, b, c, d));
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
      //status = ServoTaskStatus.FINISHED;
      println("changing to deceleration state");
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

    return Math.round(easeOutSine(t, b, c, d));
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
    return (float)((vI * t) + (0.5 * a * Math.pow(t, 2)));
  }
}