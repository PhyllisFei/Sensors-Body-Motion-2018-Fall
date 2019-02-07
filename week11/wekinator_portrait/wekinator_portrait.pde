import oscP5.*;
import netP5.*;
import processing.video.*;

OscP5 oscP5;
NetAddress dest;
Capture cam;

float x, y;
PGraphics pg;

ArrayList<Circle> circles = new ArrayList<Circle>();

void setup() {
  size(640, 480, P3D);
  noStroke();

  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448);  

  cam = new Capture(this, 640, 480);
  cam.start();

  pg = createGraphics(cam.width, cam.height);
}

void draw() {
  background(0);

  if ( cam.available() ) {
    cam.read();
    cam.updatePixels();
  }

  PImage camImg = cam.copy();

  float drawX = map(x, 0, 1, 0, width);
  //float drawY = map(y, 0, 1, 0, height);

  //circles.add( new Circle( drawX-100, drawX-100, random(5), camImg) );
  circles.add( new Circle( drawX, random(drawX*.5, drawX*1.5), random(5), camImg) );
  circles.add( new Circle( random(drawX*.5, drawX*1.5), drawX, random(5), camImg) );
  circles.add( new Circle( random(drawX*.5, drawX*1.5), random(drawX*.5, drawX*1.5), random(5), camImg) );
  //circles.add( new Circle( drawX+100, drawX+100, random(5), camImg) );
  //circles.add( new Circle( drawX+300, drawX+300, random(5), camImg) );

  pg.beginDraw();
  for (int i=0; i<circles.size(); i++) {
    circles.get(i).update();
    circles.get(i).displayIn( pg );
  }
  pg.endDraw();

  for (int i=circles.size()-1; i>=0; i--) {
    if (circles.get(i).alpha <= 0) {
      circles.remove(i);
    }
  }

  image(pg, 0, 0);
  image(cam, 0, 0, cam.width * 0.2, cam.height * 0.2);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
  //if (theOscMessage.checkAddrPattern("/wek/output_3") == true) {
    if (theOscMessage.checkTypetag("f")) { //????
      x = theOscMessage.get(0).floatValue();
      //y = theOscMessage.get(1).floatValue();
    }
  }
  //if (theOscMessage.checkAddrPattern("/wek/output_4") == true) {
    //if (theOscMessage.checkTypetag("f")) { //????
      //y = theOscMessage.get(3).floatValue();
      //y = theOscMessage.get(1).floatValue();
  //  }
  //}
}
