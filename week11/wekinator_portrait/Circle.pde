class Circle {
  float x, y;
  float size;
  color c;
  int alpha;
  float speed;
  float directionX, directionY;

  Circle(float _x, float _y, float _size, PImage _cam) {
    x = _x;
    y = _y;
    size = _size;

    c = _cam.get(int(x), int(y));
    alpha = 100;
    directionX = random(-2, 3);
    directionY = random(-3, 2);
    speed = 0.4;
  }

  void update() {
    x = x + directionX*speed;
    y = y + directionY*speed;
    alpha -= 1.5;
    speed *= 1.02;
  }
  
  void display() {
    pushStyle();
    fill(c, 105);
    noStroke();
    ellipse(x, y, size, size);
    popStyle();
  }
  
  void displayIn( PGraphics p ) {
    p.pushStyle();
    p.fill(c, 105);
    p.noStroke();
    p.ellipse(x, y, size, size);
    p.popStyle();
  }
}
