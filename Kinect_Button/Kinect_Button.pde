import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import gab.opencv.*;

Kinect2 kinect2;
OpenCV opencv;


PImage depthImg;
PImage colorImg;
ArrayList<Particle> particles;

void setup() {
  size(1000, 800, P3D);
  setupPeasyCam();
  setupGui();
  particles = new ArrayList();
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initRegistered();
  kinect2.initDevice();

  depthImg = new PImage(kinect2.depthWidth, kinect2.depthHeight, ARGB);
  opencv = new OpenCV(this, depthImg);
}

void draw() {
  background(0);

  int[] rawDepth = kinect2.getRawDepth();
  int w = kinect2.depthWidth;
  int h = kinect2.depthHeight;

  resetStats();

  if (registeredColor) {
    colorImg = kinect2.getRegisteredImage();
    colorImg.loadPixels();
  }

  //first iteration of depthImg based on rawDepth
  depthImg.loadPixels();
  ArrayList <Integer> indexes = new ArrayList(); //indexes within the threshold
  for (int i=0; i < rawDepth.length; i++) {
    depthImg.pixels[i] = color(0, 0);
    if (rawDepth[i] >= thresholdMin && rawDepth[i] <= thresholdMax && rawDepth[i] != 0) {
      float brightness = map(rawDepth[i], thresholdMin, thresholdMax, 255, 1);
      indexes.add(i);
      //float b = map(rawDepth[i], thresholdMin, thresholdMax, 0, 255);
      depthImg.pixels[i] = color(brightness);
    }
  }

  depthImg.updatePixels();
  processOpenCV();
  opencvTemp = opencv.getSnapshot();
  opencvTemp.loadPixels();

  //second iteration for point cloud based on opencv
  for (Integer i : indexes) {
    int x = i % kinect2.depthWidth;
    int y = floor(i / kinect2.depthWidth);
    if (pointCloud && x%resolution == 0 && y%resolution == 0 && opencvTemp.pixels[i] != color(0)) {
      float pX = map(x, 0, w, -w/2, w/2) + offsetX;
      float pY = map(y, 0, h, -h/2, h/2);
      float pZ = map(rawDepth[i], 0, 4499, 900, -900) + offsetZ;
      

      //stats
      if (pZ>closestPoint.z) closestPoint.set(pX, pY, pZ);
      sumPoint.add(pX, pY, pZ);
      numOfPoints++;


      PVector point = new PVector(pX, pY, pZ);
      color clr;
      // color
      if (registeredColor) clr = colorImg.pixels[i];
      else clr = color(255);
      PVector vel = new PVector(0, 0, 0);

      //add particles
      if (!(point.x-offsetX < maxX && point.x-offsetX > minX && point.y < maxY && point.y > minY && point.z-offsetZ < maxZ && point.z-offsetZ > minZ)) {
        particles.add(new Particle(point, vel, clr, lifeSpan, particleSize));
      } else {
        numOfAreaPoints++;
        sumAreaPoint.add(point);
        clr = color(255, 0, 0);
        particles.add(new Particle(point, vel, clr, lifeSpan, particleSize));
      }
    }
  }
  processStats();

  //if the button is pressed
  if (numOfAreaPoints>buttonTrigger) {
    for (int i = 0; i < 4; i++) {
      PVector vel = new PVector(random(20)-10, -random(20), random(20)-10);
      PVector acc = new PVector(0, 1, 0);
      color clr = color(random(255), random(255), random(255));

      particles.add(new Particle(averagePoint, vel, acc, clr, 10, 10));
    }
  };

  indexes.clear();

  drawParticles();

  lights();
  if (guiToggle) drawGui();
  //println(particles.size());
  println(numOfAreaPoints);
}



void keyPressed() {
  if (key == ' ') guiToggle = !guiToggle;
}
