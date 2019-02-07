const int tiltSwitch = 2;
int counter = 0;

void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ;
  }
  pinMode(tiltSwitch, INPUT);
  establishContact();
}

void loop() {
  if (Serial.available() > 0) {
    counter = Serial.read();
    int tiltReading = digitalRead (tiltSwitch);
    Serial.println(tiltReading);

    if (tiltReading == 0) {
      counter+=300;
      
    } else {
      counter = 0;
    }
  }

//  if (counter > 100) {
//    Serial.println("on");
//  } else {
//    Serial.println("off");
//  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("0");   // send an initial string
    delay(300);
  }
}
