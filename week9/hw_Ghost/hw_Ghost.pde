GhostSystem ghost;

void setup() {
  size(960, 640);
  PImage img = loadImage("whitesmoke.png");
  img.resize(120, 120);
  ghost = new GhostSystem(0, new PVector(width/2, height/2), img);
}

void draw() {
  background(0);
  
  float dx = map(mouseX, 0, width, -0.2, 0.2);
  PVector wind = new PVector(dx, 0);
  ghost.applyForce(wind);
  ghost.run();
  
  //for (int i = 0; i < 2; i++) {
    ghost.addGhost();
  //}
}
