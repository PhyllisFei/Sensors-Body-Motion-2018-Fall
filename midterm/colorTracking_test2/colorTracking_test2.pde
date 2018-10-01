import processing.video.*;
import ddf.minim.*;

Capture cam;
PImage trackingImg;
color trackingColor;
float trackingX;
float trackingY;
float avgX = 0;
float avgY = 0;

int threshold = 25;

//int track=1;
//int trackAmount = 4;
//SoundFile[] soundfiles = new SoundFile[trackAmount];

Minim minim;
AudioPlayer s1, s2, s3, s4;

int numsounds = 5;

void setup() {
  size(640, 480);
  background(0);
  noStroke();

  //***** camera setup
  cam = new Capture(this, width, height);
  cam.start();
  trackingImg = createImage(width, height, ARGB);

  //***** soundfile
  smooth();
  //for (int i=1; i<soundfiles.length; i++) {
  //  String name = "soundfile";
  //  name+=str(i);
  //  name+=".aif";
  //  soundfiles[i] = new SoundFile(this,  name);
  //  soundfiles[i].loop();
  //}

  minim = new Minim(this);
  s1 = minim.loadFile("1.aif", 1024);
  s2 = minim.loadFile("2.aif", 1024);
  s3 = minim.loadFile("3.aif", 1024);
  s4 = minim.loadFile("4.aif", 1024);
}

void draw() {
  if (cam.available()) {
    cam.read();
    cam.loadPixels();
  }

  float sumX = 0;
  float sumY = 0;
  int count = 0;

  int h = cam.height;
  int w = cam.width;
  trackingImg.loadPixels();

  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      int index = x+y*w;

      float r = red(cam.pixels[index]);
      float g = green(cam.pixels[index]);
      float b = blue(cam.pixels[index]);

      if ( r > red(trackingColor) - threshold &&  r < red(trackingColor) + threshold
        && g > green(trackingColor) - threshold && g < green(trackingColor) + threshold
        && b > blue(trackingColor) - threshold &&  b < blue(trackingColor) + threshold)
      {
        //trackingImg.pixels[index] = color(255);     
        sumX += x;
        sumY += y;
        count++;
        println(red(trackingColor), green(trackingColor), blue(trackingColor));
      } else {
        trackingImg.pixels[index] = color(0, 0);
      }
      
      // blue: 37, 48, 106
      if ( r > 37 - threshold && r < 37 + threshold
        && g > 48 - threshold && g < 48 + threshold
        && b > 74 - threshold && b< 74 + threshold) {
        //track = 1;
        //file[0].play(0.5, 1.0);
        s1.play();
        println('a');
      }
      //// yellow: 220, 180, 39
      //if ( r > 220 - threshold && r < 220 + threshold
      //  && g > 180 - threshold && g < 180 + threshold
      //  && b > 39 - threshold && b< 39 + threshold) {
      //  //track = 2;
      //  file[1].play(0.5, 1.0);
      //}
      //// orange: 203, 63, 51
      //if ( r > 203 - threshold && r < 203 + threshold
      //  && g > 63 - threshold && g < 63 + threshold
      //  && b > 51 - threshold && b< 51 + threshold) {
      //  //track = 3;
      //  file[2].play(0.5, 1.0);
      //}
      //// green: 59, 97, 61
      //if ( r > 59 - threshold && r < 59 + threshold
      //  && g > 97 - threshold && g < 97 + threshold
      //  && b > 61 - threshold && b < 61 + threshold) {
      //  //track = 4;
      //  file[3].play(0.5, 1.0);
      //}
    }
  }

  //trackingImg.updatePixels();
  image(cam, 0, 0);
  image(trackingImg, 0, 0);

  if (count > 0) {
    avgX = sumX / count;
    avgY = sumY / count;
  }

  trackingX = lerp(trackingX, avgX, 0.2);
  trackingY = lerp(trackingY, avgY, 0.2);

  //***** show the center position of the tracking area
  fill(255);
  stroke(255, 100);
  ellipse(avgX, avgY, 10, 10);

  //***** show the picked color
  fill(trackingColor);
  rect(10, 10, 50, 50);
  fill(255);
  text(threshold, 70, 20);

  ////show the lerped circle
  //noStroke();
  //fill(255, 255, 0);
  //ellipse(trackingX, trackingY, 10, 10);
}

void mousePressed() {
  trackingColor = cam.get(mouseX, mouseY);
}


//void keyPressed() {
//  if (keyCode == LEFT) {
//    threshold --;
//  } else if (keyCode == LEFT) {
//    threshold ++;
//  }
//  threshold = constrain(threshold, 0, 100);
//}
