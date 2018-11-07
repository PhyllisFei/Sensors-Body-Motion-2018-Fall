GhostSystem ghost;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
//NetAddress myRemoteLocation;
float x, y;

PVector wind;

void setup() {
  //size(1280, 800);
  fullScreen();
  //frameRate(15);
  PImage img = loadImage("whitesmoke.png");
  x = 0;
  y = 0;
  img.resize(120, 120);

  wind = new PVector(0, 0);

  ghost = new GhostSystem(0, new PVector(width/2, height/2), img);
  oscP5 = new OscP5(this, 12000);
}

void draw() {
  background(0);
  //float dx = map(x, 0, width, -0.2, 0.2);
  //float dx = map(mouseX, 0, width, -0.2, 0.2);
  //wind = new PVector(dx, 0);
  //ghost.applyForce(wind);
  ghost.run();


  //PVector mousePos = new PVector(mouseX, mouseY);
  //PVector ghostOri = ghost.origin.copy();
  //PVector force = ghostOri.sub(mousePos);
  //for (int i = 0; i < 2; i++) {
  ghost.addGhost();
  //ghost.applyForce(force.mult(1));
  //}
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  float tempx=theOscMessage.get(0).floatValue();
  float tempy=theOscMessage.get(1).floatValue();
  x=map(tempx,0,640,0,1280);
  y=map(tempy,0,480,0,800);
}
