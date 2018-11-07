class GhostSystem {
  ArrayList<Ghost> ghosts;
  PVector origin;
  PImage img;
  float mass;

  GhostSystem(int num, PVector v, PImage img_) {
    ghosts = new ArrayList<Ghost>();
    //v = new PVector(-width/2, -height/2);
    origin = v.copy();
    img = img_;
    
    for (int i = 0; i < num; i++) {
      ghosts.add(new Ghost(origin, img, 1));
    }
  }

  void run() {
    for (int i = ghosts.size()-1; i >= 0; i--) {
      Ghost g = ghosts.get(i);
      g.run();
      if (g.isDead()) {
        ghosts.remove(i);
      }
    }
  }

  void applyForce(PVector dir) {
    // Enhanced loop!!!
    for (Ghost g : ghosts) {
      g.applyForce(dir);
    }
  }  

  void addGhost() {
    ghosts.add(new Ghost(origin, img, 1));
  }
}
