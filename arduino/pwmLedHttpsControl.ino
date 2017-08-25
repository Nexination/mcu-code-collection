// Use ESP8266 wifi
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
// Use os_timer for ESP8266
#include <user_interface.h>

const char* ssid = "YourSsid";
const char* password = "YourPassword";

const char* host = "pastebin.com";
const int httpsPort = 443;

// User button on ESP8266
const int button = 16;

// The order of the pins on the ESP8266, D1, D2, D3
const int g = 5;
const int r = 4;
const int b = 0;

// Pulse setup
int fade = 5;
int brightness = 0;
int activeLed = 3;
int previousLed = 0;
int tenMiliTimer = 0;

os_timer_t myTimer;

// Function to scan pastebin for data 0 = Red, 1 = Green, 2 = Yellow, 3 = Off
void scanStatus() {
  WiFiClientSecure client;
  if (!client.connect(host, httpsPort)) {
    Serial.println("connection failed");
    return;
  }

  String url = "/raw/czZ2mXad";
  Serial.println(host + url);

  client.print(String("GET ") + url + " HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" +
               "User-Agent: BuildFailureDetectorESP8266\r\n" +
               "Connection: close\r\n\r\n");
         
  while (client.connected()) {
    String line = client.readStringUntil('\n');
    if (line == "\r") {
      Serial.println("headers received");
      break;
    }
  }
  
  String line = client.readStringUntil('\n'); // Skip the encoding mark
  line = client.readStringUntil('\n');\
  previousLed = activeLed;
  activeLed = line.toInt();
}

// Function for pulse cycling
void cycleLed() {
  brightness = brightness + fade;
  String colour[] = {"R", "G", "Y", "A"};

  if(activeLed == 0) {
    analogWrite(r, brightness);
    analogWrite(g, 0);
  } else if(activeLed == 1) {
    analogWrite(r, 0);
    analogWrite(g, brightness);
  } else if(activeLed == 2) {
    analogWrite(r, brightness);
    analogWrite(g, brightness);
  } else if(activeLed == 3) {
    analogWrite(r, 0);
    analogWrite(g, 0);
  }

  Serial.print(colour[activeLed]);

  if (brightness <= 0 || brightness >= 255) {
    fade = -fade;
  }
}

// Checks for input on the user button, but doesn't do anything but reset it
void buttonCheck() {
  if (digitalRead(button) == LOW) {
    scanStatus();
    pinMode(button, OUTPUT);
    digitalWrite(button, HIGH);
    pinMode(button, INPUT);
  }
}

// Timer function that handles all timer values
void timerCallback(void *pArg) {
  if(tenMiliTimer % 3 == 0) {
    cycleLed();
  }
  
  if(tenMiliTimer >= 1000) {
    tenMiliTimer = 0;
  }
  tenMiliTimer += 1;
}

void setup() {
  // Setup button and LED's, plus reset
  pinMode(r, OUTPUT);
  pinMode(g, OUTPUT);
  pinMode(b, OUTPUT);
  digitalWrite(r, 0);
  digitalWrite(g, 0);
  digitalWrite(b, 0);
  pinMode(button, INPUT);

  // Set up wifi
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  // Set up os timers
  os_timer_setfn(&myTimer, timerCallback, NULL);
  os_timer_arm(&myTimer, 10, true);
  Serial.println("WiFi:" + WiFi.localIP().toString());
}

// Loop that executes button presses and rescans the webpage every 10 seconds
void loop() {
  if(tenMiliTimer >= 999) {
    scanStatus();
    Serial.println("Scanned");
  }
  buttonCheck();
}
