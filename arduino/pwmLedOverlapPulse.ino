// The order of the pins on the board, D1, D2, D3
int g = 5;
int r = 4;
int b = 0;

// Set default brightness
int brightnessr = 0;
int brightnessg = 125;
int brightnessb = 250;
int fader = 5;
int fadeg = 5;
int fadeb = 5;

// Set all pins to output
void setup() {
  pinMode(r, OUTPUT);
  pinMode(g, OUTPUT);
  pinMode(b, OUTPUT);
}

// Pulse loop that cycles through each colour asynchronously
void loop() {
  analogWrite(r, brightnessr);
  analogWrite(g, brightnessg);
  analogWrite(b, brightnessb);

  brightnessr = brightnessr + fader;
  brightnessg = brightnessg + fadeg;
  brightnessb = brightnessb + fadeb;
  analogWrite(r, brightnessr);
  analogWrite(g, brightnessg);
  analogWrite(b, brightnessb);

  if (brightnessr <= 0 || brightnessr >= 255) {
    fader = -fader;
  }
  if (brightnessg <= 0 || brightnessg >= 255) {
    fadeg = -fadeg;
  }
  if (brightnessb <= 0 || brightnessb >= 255) {
    fadeb = -fadeb;
  }
  delay(30);
}
