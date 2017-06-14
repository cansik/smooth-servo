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

  public ServoTask(int targetPosition, int duration)
  {
    this.targetPosition = targetPosition;
    this.duration = duration;
    this.state = ServoState.ACCELERATION;
  }

  public void start(int startPosition)
  {
    this.startPosition = startPosition;
    this.startTime = millis();

    // calculate positions
    int pathLength = abs(targetPosition - startPosition);
    
  }

  public int nextPosition(int currentPosition)
  {
    switch(state)
    {
    case ACCELERATION:
      return acceleration(currentPosition);

    case LINEARMOTION:
      return linearMotion(currentPosition);

    case DECELERATION:
      return deceleration(currentPosition);
    }

    return 0;
  }

  public int acceleration(int currentPosition)
  {
    return currentPosition;
  }

  public int linearMotion(int currentPosition)
  {
    return currentPosition;
  }

  public int deceleration(int currentPosition)
  {
    return currentPosition;
  }
}