//int number = 0;
//ArrayList<DataType> variableName = new ArrayList<DataType>();
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

ArrayList<Ball> balls = new ArrayList<Ball>();

float x, y;

void setup() {
  size(500, 600);
  background(0);

  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448);  
}

void draw() {
  background(0);

  float drawX = map(x, 0, 1, 0, width);
  //float drawY = map(y, 0, 1400, 0, height);

  balls.add( new Ball(drawX, drawX));
  
  println(drawX);

  for (int i=0; i<balls.size(); i++) {
    Ball b = balls.get(i);
    b.move();
    b.checkEdges();
    b.display();
  }

  for (int i=balls.size()-1; i>=0; i--) {
    Ball b = balls.get(i);
    if (b.isDone==true) {
      balls.remove(i);
    }
  }

  fill (255);
  text(balls.size(), 10, 20);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if(theOscMessage.checkTypetag("f")) { //????
    x = theOscMessage.get(0).floatValue();
    println(x);
    //y = theOscMessage.get(3).floatValue();
    }
  }
}
