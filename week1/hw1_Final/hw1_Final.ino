void setup() {
  Serial.begin(4800);               // starts the serial monitor
}

void loop() {
  float splitVal = analogRead(A0);       // reads the value of the sharp sensor
  Serial.println(splitVal);            // prints the value of the sensor to the serial monitor

  if (splitVal <= 20) {
    digitalWrite(2, HIGH);
    digitalWrite(4, HIGH);
    digitalWrite(7, HIGH);
    delay(500);
    digitalWrite(2, LOW);
    digitalWrite(4, LOW);
    digitalWrite(7, LOW);
    delay(500);
  }
  if (splitVal <= 45 && splitVal >= 20 ) {
    digitalWrite(2, HIGH);
    digitalWrite(4, HIGH);
    digitalWrite(7, HIGH);
  }
  if (splitVal <= 75 && splitVal >= 45 ) {
    digitalWrite(2, HIGH);
    digitalWrite(4, HIGH);
    digitalWrite(7, LOW);
  }
  if (splitVal <= 100 && splitVal >= 75 ) {
    digitalWrite(2, HIGH);
    digitalWrite(4, LOW);
    digitalWrite(7, LOW);
  }
  if (splitVal > 100) {
    digitalWrite(2, LOW);
    digitalWrite(4, LOW);
    digitalWrite(7, LOW);
  }
}
