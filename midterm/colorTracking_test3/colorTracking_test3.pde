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

int track=1;
int trackAmount = 4;

SoundFile[] soundfiles = new SoundFile[trackAmount];
float[] volumes = new float[trackAmount];
float[] volumeDestinations = new float[trackAmount];


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

  for (int i=0; i<soundfiles.length; i++) {
    String name = "soundfile";
    name+=str(i);
    name+=".aif";
    println(name);
    soundfiles[i] = new SoundFile(this, name);
    soundfiles[i].loop();
    soundfiles[i].amp(0);
    volumes[i]=0;
    volumeDestinations[i]=0;
  }
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

  boolean stillPlaying = false;
  for (int i=0; i<soundfiles.length; i++) {
    //set volume
    volumes[i]=smoothing(volumes[i], volumeDestinations[i]);
    soundfiles[i].amp(volumes[i]);
    //continuously fade volume out
    //volumeDestinations[i]-=.1;
    //constrian the fade out to 0
    volumeDestinations[i] = constrain(volumeDestinations[i], 0, 1);
    //check to see if any sound is still playing
    if (volumeDestinations[i]>0)
      stillPlaying = true;
    //changeTracks(track);
  }
  changeTracks(track);


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
      
      track = 0;
      
      // blue: 52, 69, 130
      if ( r > 52 - threshold && r < 52 + threshold
        && g > 69 - threshold && g < 69 + threshold
        && b > 130 - threshold && b< 130 + threshold) {       
        track = 1;
        //changeTracks(track);       
      }

      // yellow: 220, 180, 39
      else if ( r > 220 - threshold && r < 220 + threshold
        && g > 180 - threshold && g < 180 + threshold
        && b > 39 - threshold && b< 39 + threshold) {     
        track = 2;
        //changeTracks(track);       
      }


      // orange: 203, 63, 51
      else if ( r > 203 - threshold && r < 203 + threshold
        && g > 63 - threshold && g < 63 + threshold
        && b > 51 - threshold && b< 51 + threshold) {
        track = 3;
        //changeTracks(track);
      }


      // green: 59, 97, 61
      else if ( r > 59 - threshold && r < 59 + threshold
        && g > 97 - threshold && g < 97 + threshold
        && b > 61 - threshold && b < 61 + threshold) {
        track = 4;
        //changeTracks(track);
      } //else 
      //track = 2;
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

void mousePressed() {
  trackingColor = cam.get(mouseX, mouseY);
}
