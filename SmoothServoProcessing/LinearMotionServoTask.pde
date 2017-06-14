class LinearMotionServoTask extends ServoTask
{
  public LinearMotionServoTask(int targetPosition, int duration)
  {
    super(targetPosition, duration, ServoTaskType.LINEARMOTION);
  }

  @Override
    public int nextPosition(int currentPosition)
  {
    return 0;
  }
}