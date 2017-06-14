public class Queue<T> {

  private Object[] queue;       // The underlying array
  private int size;             // The maximal capacity
  private int head      = 0;    // Pointer to head of queue
  private int tail      = 0;    // Pointer to tail of queue
  private boolean empty = true; // Whether the queue is empty or not

  /**
   * Implements a generic FIFO queue with only the two basic
   * operations, enqueue and dequeue that inserts and retrieves
   * and element respectively.
   * @param size the number of elements the queue can maximally hold
   */
  public Queue(int size) {
    this.queue = new Object[size];
    this.size  = size;
  }

  /**
   * Inserts an element into the queue.
   * @param elem the element to insert into the queue
   * @throws Exception when the queue is full
   */
  public void enqueue(T elem) throws Exception {
    // Check if the queue is full and throw exception
    if (head == tail && !empty) {
      throw new Exception("Cannot enqueue " + elem);
    }

    // The queue has space left, enqueue the item
    queue[tail] = elem;
    tail        = (tail + 1) % size;
    empty       = false;
  }

  /**
   * Removes an element from the queue and returns it.
   * @throws Exception when the queue is empty
   */
  public T dequeue() throws Exception {
    // Check if queue is empty and throw exception
    if (empty) {
      throw new Exception("The queue is empty");
    }

    // The queue is not empty, return element
    T elem = (T) queue[head];
    head   = (head + 1) % size;
    empty  = (head == tail);
    return elem;
  }
}