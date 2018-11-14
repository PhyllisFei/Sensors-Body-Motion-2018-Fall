class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  color clr;
  int size;

  int lifeSpan;
  int life = 0;
  boolean isDead;

  Particle(PVector pos_, PVector vel_, color clr_, int lifeSpan_, int size_) {
    pos = pos_;
    vel = vel_;
    clr = clr_;
    lifeSpan = lifeSpan_;
    size = size_;
    acc = new PVector(0,0,0);
  }
  
  Particle(PVector pos_, PVector vel_, PVector acc_, color clr_, int lifeSpan_, int size_) {
    pos = pos_;
    vel = vel_;
    clr = clr_;
    lifeSpan = lifeSpan_;
    size = size_;
    acc = acc_;
  }

  void update() {
    pos.add(vel.copy());
    vel.add(acc.copy());
    life++;
    isDead = (life > lifeSpan);
  }

  void display() {
    if (displayPoint) displayPoint();
    else displayBox();
  }
  void displayPoint() {
    pushStyle();
    stroke(clr, map(life, 0, lifeSpan, 255, 0));
    strokeWeight(size);
    point(pos.x, pos.y, pos.z);
    popStyle();
  }
  void displayBox() {
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(radians(frameCount)*2);
    rotateY(radians(frameCount)*2);
    fill(clr, map(life, 0, lifeSpan, 255, 0));
    noStroke();
    //box(map(life, 0, lifeSpan, size, 1));
    box(size);
    popStyle();
    popMatrix();
  }
}