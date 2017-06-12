#include <SmoothServo.h>
#include <Servo.h>

Servo myServo;
SmoothServo servo(myServo);

void setup() {
  servo.test();
}

void loop() {

}
