void drawParticles() {
  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    p.display();
    p.update();

    if (p.isDead) {
      particles.remove(p);
      i--;
    }
  }
}
