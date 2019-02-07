import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;
import processing.sound.*;


Capture video;
OpenCV opencv;
PImage src;
ArrayList<Contour> contours;

// <1> Set the range of Hue values for our filter
//ArrayList<Integer> colors;
int maxColors = 4;
int[] hues;
int[] colors;
int rangeWidth = 10;
int colorToChange = -1;

color c;

PImage[] outputs;

SoundFile[] file;
int numsounds = 4;

void setup() {
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, video.width, video.height);
  contours = new ArrayList<Contour>();

  size(830, 480, P2D);

  colors = new int[maxColors];
  hues = new int[maxColors];

  hues[0] = 22; //yellow
  hues[1] = 5; //orange
  hues[2] = 65; //green
  hues[3] = 119; //blue

  outputs = new PImage[maxColors];
  video.start();

  file = new SoundFile[numsounds];
  for (int i = 0; i < numsounds; i++) {
    file[i] = new SoundFile(this, (i+1) + ".wav");
  }
}

void draw() {
  background(150);

  if (video.available()) {
    video.read();
  }

  // <2> Load the new frame of our movie in to OpenCV
  opencv.loadImage(video);

  // Tell OpenCV to use color information
  opencv.useColor();
  src = opencv.getSnapshot();

  // <3> Tell OpenCV to work in HSV color space.
  opencv.useColor(HSB);


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
      print("color ");
      print(i);
      print(" amount: ");
      println(count);
      if (count>10000) {
        print("color ");
        print(i);
        println(" is present!");
      }
      image(outputs[i], width-src.width/4, i*src.height/4, src.width/4, src.height/4);

      noStroke();

      fill(colors[i]);
      rect(src.width, i*src.height/4, 30, src.height/4);
      
      
      if(i==0 && !file[0].isPlaying()){
        file[0].play(); //bird
      }
      //if(i==1 && !file[1].isPlaying()){
      //  file[1].play(); //leaves
      //}
      //if(i==2 && !file[2].isPlaying()){
      //  file[2].play(); //sea
      //}
      //if(i==3 && !file[3].isPlaying()){
      //  file[0].play();
      //}
    }
  }
  println();
  // Print text if new color expected
  textSize(20);
  stroke(255);
  fill(255);

  if (colorToChange > -1) {
    text("click to change color " + colorToChange, 10, 25);
  } else {
    text("press key [1-4] to select color", 10, 25);
  }
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
    println(outputs[i]);
  }

  // <7> Find contours in our range image.
  //     Passing 'true' sorts them by descending area.
  //if (outputs[0] != null) {

  //  opencv.loadImage(outputs[0]);

  //  contours = opencv.findContours(true, true);
  //}
}


//void mousePressed() {
//  if (colorToChange > -1) {

//    color c = get(mouseX, mouseY);
//    println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));

//    int hue = int(map(hue(c), 0, 255, 0, 180));

//    colors[colorToChange-1] = c;
//    hues[colorToChange-1] = hue;

//    println("color index " + (colorToChange-1) + ", value: " + hue);
//  }
//}

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

//void playSound() {
//  //yellow
//  if (red(c)==248 && green(c)==220 && blue(c)==54) {
//    file[0].play();
//  }
//  //green
//  if (red(c)==77 && green(c)==124 && blue(c)==90) {
//    file[1].play();
//  }
//  //orange
//  if (red(c)==233 && green(c)==82 && blue(c)==60) {
//    file[2].play();
//  }
//  //blue
//  if (red(c)==37 && green(c)==44 && blue(c)==87) {
//    file[3].play();
//  }
//}
