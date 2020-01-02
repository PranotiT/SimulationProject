class Sensor {
  PVector position = new PVector();

  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    noStroke();
    fill(200, 200, 0);
    //fill(10, 100, 150);
    box(2, 25, 2);
    translate(0, -15, 0);
    box(10, 4, 10);
    popMatrix();
  }
}