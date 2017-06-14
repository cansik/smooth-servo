class SmoothServo
{
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

  public void moveTo(int targetPosition, int time)
  {
    tasks.enqueue(new ServoTask(targetPosition, time));
  }

  public void stop()
  {
  }

  public void stop(int time)
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
    }

    // update task
    servoPosition = task.nextPosition(servoPosition);
    servo.write(servoPosition);
    
    // check if task is finished
    if(task.status == ServoTaskStatus.FINISHED || task.status == ServoTaskStatus.CANCELED)
    {
       println("task finished!");
       task = null; 
    }
  }
}