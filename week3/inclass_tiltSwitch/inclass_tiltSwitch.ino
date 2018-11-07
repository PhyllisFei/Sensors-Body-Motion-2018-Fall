const int tiltSwitch = 2;
int counter = 0;

void setup() {
  pinMode(tiltSwitch, INPUT);
  Serial.begin(9600);
}

void loop() {
  int tiltReading = digitalRead (tiltSwitch);
  
  if (tiltReading == 0) {
    counter++;
  } else {
    counter = 0;
  }
  
  if (counter > 100) {
    Serial.println("on");
  } else {
    Serial.println("off");
  }

}
