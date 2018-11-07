import processing.sound.*;
import processing.serial.*;     // import the Processing serial library

Serial myPort;                  // The serial port
int track=1;
int trackAmount = 5;

SoundFile[] soundfiles = new SoundFile[trackAmount];
float[] volumes = new float[trackAmount];
float[] volumeDestinations = new float[trackAmount];


float bgcolor;      // Background color
float fgcolor;      // Fill color
float xpos, ypos;         // Starting position of the ball

void setup() {
  size(640, 480);

  // List all the available serial ports
  // if using Processing 2.1 or later, use Serial.printArray()
  printArray(Serial.list());

  //soundfile = new SoundFile(this, "vibraphon.aiff");

  // I know that the first port in the serial list on my Mac is always my
  // Arduino board, so I open Serial.list()[0].
  // Change the 0 to the appropriate number of the serial port that your
  // microcontroller is attached to.
  myPort = new Serial(this, Serial.list()[8], 9600);

  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');

  // draw with smooth edges:
  smooth();

  for (int i=0; i<soundfiles.length; i++) {
    String name = "soundfile";
    name+=str(i);
    name+=".wav";
    println(name);
    soundfiles[i] = new SoundFile(this, name);
    soundfiles[i].loop();
    soundfiles[i].amp(0);
    volumes[i]=0;
    volumeDestinations[i]=0;
  }
}

void draw() {
  background(bgcolor);
  fill(fgcolor);
  // Draw the shape
  ellipse(xpos, ypos, 20, 20);

  boolean stillPlaying = false;
  for (int i=0; i<soundfiles.length; i++) {
    //set volume
    volumes[i]=smoothing(volumes[i], volumeDestinations[i]);
    soundfiles[i].amp(volumes[i]);
    //continuously fade volume out
    volumeDestinations[i]-=.1;
    //constrian the fade out to 0
    volumeDestinations[i] = constrain(volumeDestinations[i], 0, 1);
    //check to see if any sound is still playing
    if (volumeDestinations[i]>0)
      stillPlaying = true;
  }
  changeTracks(track);
}

// serialEvent method is run automatically by the Processing applet whenever
// the buffer reaches the  byte value set in the bufferUntil()
// method in the setup():

void serialEvent(Serial myPort) {
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
  myString = trim(myString);

  // split the string at the commas and convert the sections into integers:
  int sensors[] = int(split(myString, ','));

  // print out the values you got:
  for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
    print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t");
  }
  // add a linefeed after all the sensor values are printed:
  println();
  //if (sensors.length > 1) {
  //  xpos = map(sensors[0], 0, 1023, 0, width);

  //  //ypos = map(sensors[0], 0, 1023, 0, height);
  //  fgcolor = sensors[1];
  //}
  track = 0;
  if (sensors[0] < 100) track = 0;
  else if (sensors[0] < 200) track = 2;
  else if (sensors[0] < 300) track = 3;
  else if (sensors[0] < 400) track = 4;
  else if (sensors[0] < 500) track = 5;
  else track=1;



  // send a byte to ask for more data:
  myPort.write("A");
}

void changeTracks(int which) {

  //playing only one sound at a time
  for (int i=0; i<soundfiles.length; i++) {
    volumeDestinations[i]=0;
  }
  if (which!=0)
    volumeDestinations[which-1]=1;
}

float smoothing(float current, float destination) {
  current += (destination-current)*.5;
  return current;
}
