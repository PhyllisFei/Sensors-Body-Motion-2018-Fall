import processing.serial.*;
import processing.sound.*;

Serial myPort;
SoundFile file;

float xpos, ypos;

void setup() {
  size(640, 480);
  printArray(Serial.list());

  myPort = new Serial(this, Serial.list()[8], 9600);
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');

  file = new SoundFile(this, "vibraphon.aiff");  

  smooth();
}

void draw() {
  background(0);
  ellipse(xpos, ypos, 20, 20);
}

void serialEvent(Serial myPort) {
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
  myString = trim(myString);

  // split the string at the commas and convert the sections into integers:
  int sensors[] = int(split(myString, ','));

  for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
    print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t");
  }
  println();

  if (sensors[0] == 1) {
    if (!file.isPlaying()) {
      file.loop();
    }
  }

  // send a byte to ask for more data:
  myPort.write("A");
}

float smoothing(float current, float destination) {
  current += (destination-current)*.5;
  return current;
}
