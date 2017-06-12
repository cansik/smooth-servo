/*
  SmoothServo.cpp - Library for smooth motion servo control.
  Created by Florian Bruggisser, June 12, 2017.
  Released into the public domain.
*/

#ifndef SmoothServo_h
#define SmoothServo_h

#include <Servo.h>

class SmoothServo
{
public:
	SmoothServo(Servo servo);
	void test();
private:
	Servo _servo;
};

#endif

