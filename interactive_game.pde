import peasy.PeasyCam;
PeasyCam cam;

PFont Font1;

// Snake game Source: http://mathtician.weebly.com/snake-game.html 
int areaWidth = 10, areaHeight = 10; // Size of playing area
ArrayList<Segment> snake = new ArrayList<Segment>(); // List of segments (snake)
float cellWidth, cellHeight; // Width and height of segments/food 
int headDir = DOWN; // Direction of head
int xFood = int(areaWidth/2), yFood = int(areaHeight/2); // Coordinates of food
int headX, headY; // Coordinates of head (makes reading code easier)
int highScore; // Highscore (longest snake)

final int FLOOR_LEVEL = 300;

//sensor area box dimensions
int widt = 50;
int heigh = 0; 
int dept=100;

//Placing sensors on the 4 sides of the floor
Sensor left, right, back, front;
Area l, r;
Area2 b, f;

//Placing multiple people on the floor
Person[] p; 
char[] title = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'};
int selectedPerson = -1;
boolean personMoved=true;

int moveLeft=0;
int moveUp=0;
int moveDown=0;
int moveRight=0;
int keyC = DOWN;

void setup() {
  size(600, 600, P3D);
  camera(width/2, (height/2)-100, 500, width/2, (height/2)-100, 0, 0, 0.1, 0);
  //cam = new PeasyCam(this, 800);

  Font1 = createFont("Arial Bold", 36);

  int maxPersons = 12;
  p = new Person[maxPersons];
  //create new instances of person
  for (int i = 0; i < p.length; i++) {
    p[i] = new Person(title[i]);
  }

  noStroke(); // Don't outine squares
  fill(0);
  //fill(199, 21, 133); // Black snake/food
  frameRate(8);
  cellWidth = 200/areaWidth; // Define cell width/height
  cellHeight = 200/areaHeight;
  snake.add(new Segment(0, 0)); // Initialize snake
  textSize(16); // Set font size in pixels

  //initialize a random position for the persons
  for (int i=0; i<maxPersons; i++) {
    p[i].position.set(random((width/2)-200, (width/2)+200), FLOOR_LEVEL, random(-100, 100));
  }

  //create a new sensor
  left=new Sensor();
  right=new Sensor();
  back=new Sensor();
  front=new Sensor();

  //create new sensor area
  l=new Area();
  r=new Area();
  b=new Area2();
  f=new Area2();

  //coordinate position of the sensors on the floor
  left.position.set((width/2)-200, (height/2)-10, 0);
  right.position.set((width/2)+200, (height/2)-10, 0);
  back.position.set((width/2), (height/2)-10, -100);
  front.position.set((width/2), (height/2)-10, 100);

  //position of new areas
  l.position.set((width/2)-200+widt/2, (height/2)-4, 0);
  r.position.set((width/2)+200-widt/2, (height/2)-4, 0);
  b.position.set((width/2), (height/2)-4, (-100+dept/4));
  f.position.set((width/2), (height/2)-4, (100-dept/4));
}

void draw() {
  float mDeltaTime = 1.0 / frameRate;

  background(255);
  lights(); 

  //displays the sensor
  left.display();
  right.display();
  back.display();
  front.display();

  //display sensor area
  l.display();
  r.display();
  b.display();
  f.display();

  //create the game area
  stroke(20); 
  noFill();

  pushMatrix();
  translate(300, 150);
  box(200, 200, 2); 
  popMatrix();

  //create the floor
  pushMatrix();
  //fill(12, 240, 116);
  fill(20);
  stroke(100);
  //stroke(0, 100, 100);
  translate((width/2), (height/2));
  box(400, 5, 200); // floor
  popMatrix();

  //display the person along with a character
  for (int i = 0; i < p.length; i++) {
    p[i].display();
  }

  // size of field = cellWidth(20px)*areaWidth(10), ...
  translate(200, 50);

  fill(20);
  //fill(255, 215, 0); //purple fill
  rect(xFood*cellWidth, yFood*cellHeight, cellWidth, cellHeight); // Draw food
  headX = snake.get(0).x; // Set headX and headY
  headY = snake.get(0).y;
  for (int c = 1; c < snake.size(); c++) // Check all segments except head
    if (snake.get(c).x == headX && snake.get(c).y == headY) { // If the head has run into any other segment
      int tmpSize = snake.size(); // Set a temporary snake size
      for (int c2 = tmpSize-1; c2 > 0; c2--) // Remove all segments but the head
        snake.remove(c2);
    }

  checkCases();

  if (snake.get(0).x == xFood && snake.get(0).y == yFood) { // If snake reaches food
    snake.add(new Segment(xFood, yFood)); // Add another segment
    xFood = int(random(areaWidth)); // Move food to random place
    yFood = int(random(areaHeight));
  }
  snake.remove(snake.size()-1); // Remove tail of snake
  for (int c = 0; c < snake.size(); c++)
    snake.get(c).update(); // Draw snake
  if (snake.size() > highScore) // If there's a new highscore
    highScore = snake.size(); // Change the highscore to the new record

  fill(20);
  //fill(60, 179, 113);
  textSize(15);
  text("Score: " + snake.size() + "\nHighscore: " + highScore, 255, 16);
}

void keyPressed() {
  checkKeyForPerson(); //and activate that person
}

void mouseMoved() {
  if (selectedPerson >= 0 && p[selectedPerson].movable) {
    p[selectedPerson].position.set(constrain(mouseX, width/2-200, width/2+200), FLOOR_LEVEL, constrain(mouseY, (height/2)-400, (height/2)-200));
  }
}

void mousePressed() {
  if (selectedPerson >= 0 && p[selectedPerson].movable) {
    p[selectedPerson].movable = false;
    makePreviousLocationZero();
    checkPersonLocation();
  }
}

void checkKeyForPerson() {
  for (int i=0; i<title.length; i++) {
    if (keyCode==title[i]) {
      p[i].movable = true;
      if (selectedPerson >= 0) {
        p[selectedPerson].movable = false;
      }
      selectedPerson = i;
      return;
    }
  }
}

//check new location
void checkPersonLocation() {
  //check left box
  if (p[selectedPerson].position.x>l.position.x && p[selectedPerson].position.x<(l.position.x+widt) && p[selectedPerson].position.z>l.position.z && p[selectedPerson].position.z<(l.position.z+dept)) {
    println("left");
    moveLeft=1;
    keyC=LEFT;
  } 

  //check right box
  else if (p[selectedPerson].position.x>r.position.x && p[selectedPerson].position.x<(r.position.x+widt) && p[selectedPerson].position.z>r.position.z && p[selectedPerson].position.z<(r.position.z+dept)) {
    println("right");
    moveRight=1;
    keyC=RIGHT;
  } 

  //check down box
  else if (p[selectedPerson].position.x>f.position.x && p[selectedPerson].position.x<(f.position.x+dept) && p[selectedPerson].position.z>f.position.z && p[selectedPerson].position.z<(f.position.z+widt)) {
    println("front");
    moveDown=1;
    keyC=DOWN;
  } 

  //check back box
  else if (p[selectedPerson].position.x>b.position.x && p[selectedPerson].position.x<(b.position.x+dept) && p[selectedPerson].position.z>b.position.z && p[selectedPerson].position.z<(b.position.z+widt)) {
    println("back");
    moveUp=1;
    keyC=UP;
  }
}

void makePreviousLocationZero() {
  moveLeft=0;
  moveUp=0;
  moveDown=0;
  moveRight=0;
}

void checkCases() {
  if (personMoved==true) {
    if ((moveUp==1 && headDir != DOWN)|| (moveLeft==1 && headDir != RIGHT) || (moveDown==1 && headDir != UP) || (moveRight==1 && headDir != LEFT)) 

      headDir = keyC;
    switch(headDir) { // Add segment
    case LEFT:
      snake.add(0, new Segment(headX-1, headY)); // Add a new segment to its left
      if (snake.get(0).x == -1)  // If the snake has gone out of the left side
        snake.get(0).x = areaWidth-1; // Teleport it to the right side
      break;
    case UP: // If the head is going up
      snake.add(0, new Segment(headX, headY-1)); // Add a new segment above it
      if (snake.get(0).y == -1) // If the snake has gone out of the top
        snake.get(0).y = areaHeight-1; // Teleport it to the bottom
      break;
    case DOWN: // If the head is going down
      snake.add(0, new Segment(headX, headY+1)); // Add a new segment below it
      if (snake.get(0).y == areaHeight) // If the snake has gone out of the bottom
        snake.get(0).y = 0; // Teleport it to the top
      break;
    case RIGHT: // If the head is going right
      snake.add(0, new Segment(headX+1, headY)); // Add a new segment to its right
      if (snake.get(0).x == areaWidth) // If the snake has gone out of the right side
        snake.get(0).x = 0; // Teleport it to the left side
      break;
    }
  }
}