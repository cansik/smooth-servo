class AccelerationServoTask extends ServoTask
{
  public AccelerationServoTask(int targetPosition, int duration)
  {
    super(targetPosition, duration, ServoTaskType.ACCELERATION);
  }
  
  @Override
  public int nextPosition(int currentPosition)
  {
    return 0;
  }
}