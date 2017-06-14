class SmoothServo
{
  Queue<ServoTask> tasks = new Queue<ServoTask>(30);
  ServoTask task = null;

  Servo servo;

  int servoPosition;

  // max speed per seconds
  float maxVelocity;
  float maxAcceleration;

  public SmoothServo(Servo servo, float maxVelocity, float maxAcceleration)
  {
    this.servo = servo;
    this.maxVelocity = maxVelocity;
    this.maxAcceleration = maxAcceleration;

    // init servo to have same position
    servoPosition = 90;
    servo.write(servoPosition);
  }

  public void moveTo(int targetPosition)
  {
    moveTo(targetPosition, maxVelocity);
  }

  public void moveTo(int targetPosition, float velocity)
  {
    moveTo(targetPosition, maxVelocity, maxAcceleration);
  }

  public void moveTo(int targetPosition, float velocity, float acceleration)
  {
    tasks.enqueue(new ServoTask(targetPosition, velocity * maxVelocity, acceleration * maxAcceleration));
  }

  public void stop()
  {
  }

  public void update()
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
      task.start(servoPosition);

      graph = new int[2000];
      gp = 0;
      s1 = -1;
      s2 = -1;
    }

    // update task
    servoPosition = task.nextPosition(servoPosition);
    servo.write(servoPosition);

    if (s1 == -1 && task.state == ServoState.LINEARMOTION)
      s1 = gp;

    if (s2 == -1 && task.state == ServoState.DECELERATION)
      s2 = gp;

    graph[gp++] = servoPosition;

    // check if task is finished
    if (task.status == ServoTaskStatus.FINISHED || task.status == ServoTaskStatus.CANCELED)
    {
      println("task finished!");
      task = null;
    }
  }
}