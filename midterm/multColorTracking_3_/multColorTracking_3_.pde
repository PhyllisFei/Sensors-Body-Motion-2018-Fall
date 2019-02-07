import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;
import processing.sound.*;

//Capture video;
Capture cam;
OpenCV opencv;

PImage src;
PImage[] outputs;

int maxColors = 4;
int[] hues;
int[] colors;
int rangeWidth = 10;
int colorToChange = -1;
color c;

int trackAmount = 4;
SoundFile[] files = new SoundFile[trackAmount];
float[] volumes = new float[trackAmount];
float[] volumeDestinations = new float[trackAmount];

void setup() {
  //video = new Capture(this, 640, 480);
  //opencv = new OpenCV(this, video.width, video.height);
  cam = new Capture(this, 640, 480, Capture.list()[3]);
  opencv = new OpenCV(this, cam.width, cam.height);

  size(830, 480, P2D);

  colors = new int[maxColors];
  hues = new int[maxColors];

  //hues[0] = 23; //yellow; bird
  //hues[1] = 4; //orange; leaves
  //hues[2] = 58; //green; sea
  //hues[3] = 106; //blue; cricket 
  
  hues[0] = 5; //red; bird
  hues[1] = 54; //green; leaves
  hues[2] = 113; //blue; sea
  hues[3] = 1; //red; cricket 

  printArray(hues);

  outputs = new PImage[maxColors];
  //video.start();
  cam.start();

  for (int i = 0; i < trackAmount; i++) {
    String name = "soundfile";
    name+=str(i);
    name+=".wav";
    println(name);
    files[i] = new SoundFile(this, name);
    files[i].loop();
    files[i].amp(0);
    volumes[i]=0;
    volumeDestinations[i]=0;
  }
}

void draw() {
  background(150);
  //if (video.available()) {
  //  video.read();
  //}
  //opencv.loadImage(video);
  if (cam.available()) {
    cam.read();
  }
  opencv.loadImage(cam);

  // Tell OpenCV to use color information
  opencv.useColor();
  src = opencv.getSnapshot();
  // <3> Tell OpenCV to work in HSV color space.
  opencv.useColor(HSB);

  boolean stillPlaying = false;
  for (int i=0; i<files.length; i++) {
    //set volume
    volumes[i]=smoothing(volumes[i], volumeDestinations[i]);
    files[i].amp(volumes[i]);
    //continuously fade volume out
    volumeDestinations[i]-=.1;
    //constrian the fade out to 0
    volumeDestinations[i] = constrain(volumeDestinations[i], 0, 1);
    //check to see if any sound is still playing
    if (volumeDestinations[i]>0)
      stillPlaying = true;
  }
  detectColors();

  // Show images
  image(src, 0, 0);
  for (int i=0; i<outputs.length; i++) {
    if (outputs[i] != null) {
      int count=0;
      outputs[i].loadPixels();
      for (int j=0; j<outputs[i].pixels.length; j++) {
        if (brightness(outputs[i].pixels[j])>200)
          count++;
      }
      //print("color ");
      //print(i);
      //print(" amount: ");
      //println(count);
      if (count>10000) {
        print("color ");
        print(i);
        println(" is present!");

        //if (i==0) track=1; //bird
        //if (i==1) track=2; //leaves
        //if (i==2) track=3; //sea
        //if (i==3) track=4; //cricket
        //track = i;
        changeTracks(i);
      }
      image(outputs[i], width-src.width/4, i*src.height/4, src.width/4, src.height/4);

      if (mousePressed) {
        c = get(mouseX, mouseY);

        if (colorToChange > -1) {
          println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));

          int hue = int(map(hue(c), 0, 255, 0, 180));

          colors[colorToChange-1] = c;
          hues[colorToChange-1] = hue;

          println("color index " + (colorToChange-1) + ", value: " + hue);
        }
      }

      fill(colors[i]);
      noStroke();
      rect(src.width, i*src.height/4, 30, src.height/4);
    }
  }

  //println();
  //textSize(20);
  //stroke(255);
  //fill(255);
  //if (colorToChange > -1) {
  //  text("click to change color " + colorToChange, 10, 25);
  //} else {
  //  text("press key [1-4] to select color", 10, 25);
  //}
}


void detectColors() {
  for (int i=0; i<hues.length; i++) {
    if (hues[i] <= 0) continue;
    opencv.loadImage(src);
    opencv.useColor(HSB);

    // <4> Copy the Hue channel of our image into 
    //     the gray channel, which we process.
    opencv.setGray(opencv.getH().clone());

    int hueToDetect = hues[i];
    //println("index " + i + " - hue to detect: " + hueToDetect);

    // <5> Filter the image based on the range of 
    //     hue values that match the object we want to track.
    opencv.inRange(hueToDetect-rangeWidth/2, hueToDetect+rangeWidth/2);

    //opencv.dilate();
    opencv.erode();

    // TO DO:
    // Add here some image filtering to detect blobs better

    // <6> Save the processed image for reference.
    outputs[i] = opencv.getSnapshot();
  }

  // <7> Find contours in our range image.
  //     Passing 'true' sorts them by descending area.
  //if (outputs[0] != null) {
  //  opencv.loadImage(outputs[0]);
  //  contours = opencv.findContours(true, true);
  //}
}

void changeTracks(int which) {
  //playing only one sound at a time
  //for (int i=0; i<files.length; i++) {
  //  volumeDestinations[i]=0;
  //}
  //if (which!=0)
  volumeDestinations[which]=1;
}

float smoothing(float current, float destination) {
  current += (destination-current)*.5;
  return current;
}

void keyPressed() {
  if (key == '1') {
    colorToChange = 1;
  } else if (key == '2') {
    colorToChange = 2;
  } else if (key == '3') {
    colorToChange = 3;
  } else if (key == '4') {
    colorToChange = 4;
  }
}

void keyReleased() {
  colorToChange = -1;
}
