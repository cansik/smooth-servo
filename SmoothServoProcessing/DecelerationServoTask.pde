class DecelerationServoTask extends ServoTask
{
  public DecelerationServoTask(int targetPosition, int duration)
  {
    super(targetPosition, duration, ServoTaskType.DECELERATION);
  }

  @Override
    public int nextPosition(int currentPosition)
  {
    return 0;
  }
}