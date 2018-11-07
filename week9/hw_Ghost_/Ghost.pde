class Ghost {
  PVector loc;
  PVector vel;
  PVector acc;
  float lifespan;
  PImage img;
  float mass;

  Ghost(PVector l, PImage img_, float m) {
    float vx = randomGaussian()*0.00001;
    float vy = randomGaussian()*0.005 - 2.0;
    
    acc = new PVector(0, 0);
    vel = new PVector(vx, vy);
    //vel = new PVector(vx, 0);
    loc = l.copy();
    
    lifespan = 180; //120.0;
    img = img_;
    mass = m;
  }

  void run() {
    update();
    render();
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }  

  void applyRestitution(float rest) {
    float value = 1.0 + rest;
    vel.mult(value);
  }

  void update() {
    //PVector mouse = new PVector(mouseX, mouseY);
    PVector Pos = new PVector(x, y);
    //PVector acc2 = PVector.sub(mouse, loc);
    PVector acc2 = PVector.sub(Pos, loc);

    vel.add(acc2);
    //vel.add(acc);
    loc.add(vel);
    lifespan -= 1.5; //1.5;
    acc.mult(0);
  }

  void render() {
    imageMode(CENTER);
    tint(255, lifespan);
    image(img, loc.x, loc.y);
  }

  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
