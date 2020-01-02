class Area2 {
  PVector position = new PVector();

  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    noStroke();
    fill(200, 200, 0);
    //fill(10, 100, 150);
    box(dept, heigh, widt);
    popMatrix();
  }
}