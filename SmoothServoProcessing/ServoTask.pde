abstract class ServoTask
{
  ServoTaskType type;
  ServoTaskStatus status = ServoTaskStatus.CREATED;

  int startPosition;
  int targetPosition;

  int duration;
  int startTime;

  public ServoTask(int targetPosition, int duration, ServoTaskType type)
  {

    this.targetPosition = targetPosition;
    this.duration = duration;
    this.type = type;
  }

  public void start(int startPosition)
  {
    this.startPosition = startPosition;
    this.startTime = millis();
  }

  public abstract int nextPosition(int currentPosition);
}