class SmoothServo
{
  final int ACCELERATION_TIME = 250;
  final int DECELERATION_TIME = 250;

  Queue<ServoTask> tasks = new Queue<ServoTask>(30);
  ServoTask task = null;

  Servo servo;

  int servoPosition;

  public SmoothServo(Servo servo)
  {
    this.servo = servo;

    // init servo to have same position
    servoPosition = 90;
    servo.write(servoPosition);
  }

  public void moveTo(int position, int time) throws Exception
  {
    int linearMotionTime = time - (ACCELERATION_TIME + DECELERATION_TIME);

    // add tasks
    tasks.enqueue(new AccelerationServoTask(position, ACCELERATION_TIME));

    if (linearMotionTime > 0)
      tasks.enqueue(new AccelerationServoTask(position, linearMotionTime));

    tasks.enqueue(new AccelerationServoTask(position, DECELERATION_TIME));
  }

  public void stop()
  {
  }

  public void stop(int time)
  {
  }

  public void update() throws Exception
  {
    //  check if we need a new task from the queue
    if (task == null 
      || task.status == ServoTaskStatus.FINISHED 
      || task.status == ServoTaskStatus.CANCELED)
    {
      if (tasks.empty)
        return;

      // get new task from queue
      task = tasks.dequeue();
    }

    // update task
    servoPosition = task.nextPosition(servoPosition);
    servo.write(servoPosition);
  }
}