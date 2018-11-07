float currValue = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int knobValue = analogRead(A0);

  int constrainedValue = constrain(knobValue, 500, 800);

  int mappedValue = map(constrainedValue, 500, 800, 0, 255);

  //mappedValue is the destination
  currValue += (mappedValue - currValue) * .1;
  analogWrite(3, currValue);

//  prevReading = mappedValue;
}
