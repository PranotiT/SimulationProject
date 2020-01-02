

class Segment {
  int x, y; // Coordinates of segment
  Segment(int tmpX, int tmpY) { // Constructor function (initializes variables)
    x = tmpX;
    y = tmpY;
  }
  void update() {
    rect(x*cellWidth, y*cellHeight, cellWidth, cellHeight); // Draw the segment
  }
}