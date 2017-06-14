class ServoTask
{
  final int ACCELERATION_TIME = 250;
  final int DECELERATION_TIME = 250;

  final int ACCELERATION_PATH = 20;
  final int DECELERATION_PATH = 20;

  ServoState state;
  ServoTaskStatus status = ServoTaskStatus.CREATED;

  int startPosition;
  int targetPosition;

  int accelerationTarget;
  int linearMotionTarget;
  int decelerationTarget;

  int duration;
  int startTime;

  int linearMotionTime;

  int direction;

  public ServoTask(int targetPosition, int duration)
  {
    this.targetPosition = targetPosition;
    this.duration = duration;
    this.state = ServoState.ACCELERATION;
  }

  public void start(int startPosition)
  {
    status = ServoTaskStatus.RUNNING;

    this.startPosition = startPosition;
    this.startTime = millis();

    // calculate positions
    int pathLength = abs(targetPosition - startPosition);
    direction = getSign(targetPosition - startPosition);

    int linearMotionPath = max(0, pathLength - (ACCELERATION_PATH + DECELERATION_PATH));
    linearMotionTime = duration - (ACCELERATION_TIME + DECELERATION_TIME);

    accelerationTarget = startPosition + (direction * ACCELERATION_PATH);
    linearMotionTarget = accelerationTarget + (direction * linearMotionPath);
    decelerationTarget = linearMotionTarget + (direction * DECELERATION_PATH);

    println("New Task:");
    println("Start: " + startPosition);
    println("Target: " + targetPosition);

    println("Acc: " + accelerationTarget);
    println("Lin: " + linearMotionTarget);
    println("Dec: " + decelerationTarget);
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
    int t = millis() - startTime;
    int b = startPosition;
    int c = accelerationTarget - startPosition;
    int d = ACCELERATION_TIME;

    // check state switch
    if (t >= d)
    {
      state = ServoState.LINEARMOTION;
      println("changing to linear motion state");
    }

    return Math.round(easeInQuad(t, b, c, d));
  }

  public int linearMotion()
  {
    int t = millis() - (startTime + ACCELERATION_TIME);
    int b = accelerationTarget;
    int c = linearMotionTarget - accelerationTarget;
    int d = linearMotionTime;

    // check state switch
    if (t >= d)
    {
      state = ServoState.DECELERATION;
      println("changing to deceleration state");
    }

    return Math.round(linearTween(t, b, c, d));
  }

  public int deceleration()
  {
    int t = millis() - (startTime + ACCELERATION_TIME + linearMotionTime);
    int b = linearMotionTarget;
    int c = decelerationTarget - linearMotionTarget;
    int d = DECELERATION_TIME;

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
}