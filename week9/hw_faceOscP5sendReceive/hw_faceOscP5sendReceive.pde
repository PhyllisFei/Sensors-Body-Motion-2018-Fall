/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
PFont f;
String message="";

float sizeMouth, centerPos, openEyeL, openEyeR;

void setup() {
  size(640, 480);
  background(0); 
  //f = createFont("FranklinGoth-ExtCondensed", 32);
  //textFont(f, 32);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 8338);
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1", 1234);

  smooth();
  noFill();
}


void draw() {
  fill(0, 30);
  rect(0, 0, width, height);

  pushMatrix();
  pushStyle();
  translate(width/2, height/2);
  fill(255);
  ellipse(0, 0, 250, 300);
  ellipse(-50, -50, 20, map(openEyeL, 2, 3.5, 0, 30));
  ellipse(50, -50, 20, map(openEyeR, 2, 3.5, 0, 30));
  popStyle();
  popMatrix();

  if (sizeMouth>1.3) {
    pushMatrix();
    pushStyle();
    translate(width/2, height/2+50);

    float circleResolution = map(sizeMouth, 0, 400, 15, 100);
    float radius = map(sizeMouth, 0, 20, 5, 200);
    //float radius = map(sizeMouth, 0, 4, 80, 200);
    float angle = TWO_PI/circleResolution;

    strokeWeight(2);
    stroke(255, 0, 0, 180);

    beginShape();
    for (int i=0; i<=circleResolution; i++) {
      float x = cos(angle*i) * radius;
      float y = sin(angle*i) * radius/2;
      vertex(x, y);
    }
    vertex(cos(angle*0) * radius/2, sin(angle*0) * radius);
    vertex(cos(angle*0) * radius, sin(angle*0) * radius/2);
    endShape();
    popStyle();
    popMatrix();
  }
}


void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  if ( theOscMessage.checkAddrPattern("/gesture/mouth/height") == true ) {
    //print("### received an osc message.");
    //print(" addrpattern: "+theOscMessage.addrPattern());
    //print(" message: "+theOscMessage.get(0).floatValue());
    //println(" typetag: "+theOscMessage.typetag());

    //scaleSize += (theOscMessage.get(0).floatValue()*.3-scaleSize)*.1;
    sizeMouth = theOscMessage.get(0).floatValue();
  }

  if ( theOscMessage.checkAddrPattern("/gesture/eye/left") == true ) {
    openEyeL = theOscMessage.get(0).floatValue();
  }
  if ( theOscMessage.checkAddrPattern("/gesture/eye/right") == true ) {
    openEyeR = theOscMessage.get(0).floatValue();
  }
}
