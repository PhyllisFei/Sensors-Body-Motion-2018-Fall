import processing.video.*;
import processing.sound.*;

Capture cam;
PImage trackingImg;
color trackingColor;
float trackingX;
float trackingY;
float avgX = 0;
float avgY = 0;

int threshold = 25;

SoundFile[] file;
int numsounds = 5;

boolean isTriggered1;
//boolean isTriggered2;
//boolean isTriggered3;
//boolean isTriggered4;

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

  file = new SoundFile[numsounds];
  for (int i = 0; i < numsounds; i++) {
    file[i] = new SoundFile(this, (i+1) + ".aif");
  }

  isTriggered1 = false;
  //isTriggered2 = false;
  //isTriggered3 = false;
  //isTriggered4 = false;
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

      if (mousePressed) {
        isTriggered1 = true;
        // blue: 37, 48, 106
        if ( r > 37 - threshold && r < 37 + threshold
          && g > 48 - threshold && g < 48 + threshold
          && b > 106 - threshold && b< 106 + threshold) {
          if (!file[0].isPlaying()) { 
            file[0].loop();
          }
        }



        // yellow: 220, 180, 39
        if ( r > 220 - threshold && r < 220 + threshold
          && g > 180 - threshold && g < 180 + threshold
          && b > 39 - threshold && b< 39 + threshold) {
          if (!file[1].isPlaying()) { 
            file[1].loop();
          }
        }


        // orange: 203, 63, 51
        //if ( r > 203 - threshold && r < 203 + threshold
        //  && g > 63 - threshold && g < 63 + threshold
        //  && b > 51 - threshold && b< 51 + threshold) {
        //  if (!file[2].isPlaying()) { 
        //    file[2].loop();
        //  }
        //}



        // green: 59, 97, 61
        //if ( r > 59 - threshold && r < 59 + threshold
        //  && g > 97 - threshold && g < 97 + threshold
        //  && b > 61 - threshold && b < 61 + threshold) {
        //  if (!file[3].isPlaying()) { 
        //    file[3].loop();
        //  }
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
}

void mousePressed() {
  trackingColor = cam.get(mouseX, mouseY);
}
