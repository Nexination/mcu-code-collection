int motorPin1 = 8; // wire 1 (blue)
int motorPin2 = 9; // wire 2 (pink)
int motorPin3 = 10; // wire 3 (yellow)
int motorPin4 = 11; // wire 4 (orange)
//wire 5 (Red) is a VCC and should be put to 5V, with this setup it is not needed, but it is good to know if you make something like an 8 step spinup

int motorSpeed = 10;

void setup() {
  // They are set as outputs, so they output 5V that can drive the motor
  pinMode(motorPin1, OUTPUT);
  pinMode(motorPin2, OUTPUT);
  pinMode(motorPin3, OUTPUT);
  pinMode(motorPin4, OUTPUT);
}
void loop(){
  //ccw is short for counterclockwise
  ccw();
}
void ccw (){
  //To make it go clockwise, just set motorPin1 to low here
  digitalWrite(motorPin1, HIGH);
  digitalWrite(motorPin2, LOW);
  digitalWrite(motorPin3, LOW);
  digitalWrite(motorPin4, HIGH);
  delay(motorSpeed);
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, HIGH);
  digitalWrite(motorPin3, HIGH);
  digitalWrite(motorPin4, LOW);
  delay(motorSpeed);
}

