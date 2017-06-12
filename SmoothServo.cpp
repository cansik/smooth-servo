/*
  SmoothServo.cpp - Library for smooth motion servo control.
  Created by Florian Bruggisser, June 12, 2017.
  Released into the public domain.
*/

#include <Servo.h>
#include "SmoothServo.h"


SmoothServo::SmoothServo(Servo servo)
{
	_servo = servo;
}

void SmoothServo::test()
{
	delay(5000);
}
