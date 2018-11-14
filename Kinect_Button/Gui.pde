import controlP5.*;
import java.util.*;
import peasy.*;

PeasyCam cam;
ControlP5 cp5;

boolean guiToggle;

int resolution;
int thresholdMin;
int thresholdMax;

int minX, maxX;
int minY, maxY;
int minZ, maxZ;
int buttonTrigger;

float monitorScale;

boolean pointCloud;
boolean pointCloudOfContours;
boolean registeredColor;
boolean displayStats;
boolean displayPoint;
boolean displayClosestPoint;

Slider2D offsetSlider2D;
float offsetX = 0;
float offsetZ = 0;

int lifeSpan;
int particleSize;



void setupPeasyCam() {
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(600);
  cam.setMaximumDistance(1500);
  cam.setDistance(1000);
}
void setupGui() {
  guiToggle = true;

  int sliderW = 100;
  int sliderH = 15;
  int startX = 10;
  int startY = 35;
  int spacing = 20;

  cp5 = new ControlP5( this );
  cp5.addSlider("thresholdMin")
    .setPosition(startX, startY+spacing*0)
    .setSize(sliderW, sliderH)
    .setRange(0, 4499)
    .setValue(1079)
    ;    
  cp5.addSlider("thresholdMax")
    .setPosition(startX, startY+spacing*1)
    .setSize(sliderW, sliderH)
    .setRange(0, 4499)
    .setValue(1304)
    ;
  cp5.addSlider("resolution")
    .setPosition(startX, startY+spacing*2)
    .setSize(sliderW, sliderH)
    .setRange(2, 10)
    .setValue(2)
    ;
  cp5.addSlider("monitorScale")
    .setPosition(startX, startY+spacing*3)
    .setSize(sliderW, sliderH)
    .setRange(0.1, 1.0)
    .setValue(0.5)
    ;
  cp5.addToggle("pointCloud")
    .setPosition(startX, startY+spacing*4)
    .setSize(sliderW, sliderH)
    .setValue(true)
    ;
  cp5.addToggle("registeredColor")
    .setPosition(startX, startY+spacing*8)
    .setSize(sliderW, sliderH)
    .setValue(false)
    ;
  cp5.addToggle("displayStats")
    .setPosition(startX + 200, startY+spacing*6)
    .setSize(sliderW, sliderH)
    .setValue(true)
    ;
  cp5.addToggle("displayClosestPoint")
    .setPosition(startX + 200, startY+spacing*4)
    .setSize(sliderW, sliderH)
    .setValue(true)
    ;
  offsetSlider2D = cp5.addSlider2D("offset")
    .setPosition(startX, startY+spacing*10)
    .setSize(sliderW, sliderW)
    .setMinMax(-1000, -1000, 1000, 1000)
    .setValue(0, 0)
    ;

  cp5.addToggle("displayPoint")
    .setPosition(startX, startY+spacing*17)
    .setSize(sliderW, sliderH)
    .setValue(true)
    ;
  cp5.addSlider("lifeSpan")
    .setPosition(startX, startY+spacing*19)
    .setSize(sliderW, sliderH)
    .setRange(2, 20)
    .setValue(2)
    ;
  cp5.addSlider("particleSize")
    .setPosition(startX, startY+spacing*20)
    .setSize(sliderW, sliderH)
    .setRange(1, 10)
    .setValue(2)
    ;

  cp5.addSlider("minX")
    .setPosition(startX, startY+spacing*24)
    .setSize(sliderW, sliderH)
    .setRange(-640/2, 640/2)
    .setValue(-6)
    ;    
  cp5.addSlider("maxX")
    .setPosition(startX, startY+spacing*25)
    .setSize(sliderW, sliderH)
    .setRange(-640/2, 640/2)
    .setValue(51)
    ;    
  cp5.addSlider("minY")
    .setPosition(startX, startY+spacing*26)
    .setSize(sliderW, sliderH)
    .setRange(-480/2, 480/2)
    .setValue(9)
    ;    
  cp5.addSlider("maxY")
    .setPosition(startX, startY+spacing*27)
    .setSize(sliderW, sliderH)
    .setRange(-480/2, 480/2)
    .setValue(43)
    ;   
  cp5.addSlider("minZ")
    .setPosition(startX, startY+spacing*28)
    .setSize(sliderW, sliderH)
    .setRange(-900, 900)
    .setValue(100)
    ;    
  cp5.addSlider("maxZ")
    .setPosition(startX, startY+spacing*29)
    .setSize(sliderW, sliderH)
    .setRange(-900, 900)
    .setValue(-100)
    ;

  cp5.addSlider("buttonTrigger")
    .setPosition(startX, startY+spacing*30)
    .setSize(sliderW, sliderH)
    .setRange(100, 1000)
    .setValue(100)
    ;    


  cp5.setAutoDraw(false);
}

void drawGui() {
  // updateGUI
  if (mouseX < 320) cam.setActive(false);
  else  cam.setActive(true);
  offsetX = offsetSlider2D.getArrayValue()[0];
  offsetZ = offsetSlider2D.getArrayValue()[1];


  // draw GUI and DepthImage
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();

  pushStyle();
  fill(255);
  cp5.draw();
  text(frameRate, 10, 20);

  drawDepthImage();
  popStyle();

  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void drawDepthImage() {
  pushStyle();
  pushMatrix();
  translate(width, 0);
  scale(monitorScale);
  //image(kinect2.getDepthImage(), -kinect2.depthWidth, 0, kinect2.depthWidth, kinect2.depthHeight);
  image(depthImg, -2*kinect2.depthWidth, 0, kinect2.depthWidth, kinect2.depthHeight);
  image(opencv.getOutput(), -kinect2.depthWidth, 0, kinect2.depthWidth, kinect2.depthHeight);
  pushStyle();
  popMatrix();
}
