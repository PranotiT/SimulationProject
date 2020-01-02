//to place "people" on the floor
//mesh object library
import de.hfkbremen.mesh.*;
import de.hfkbremen.mesh.examples.*;
import de.hfkbremen.mesh.sandbox.*;
//importing the individual mesh
ModelData mModelData = ModelLoaderOBJ.parseModelData(OBJMan.DATA);
Mesh individual = mModelData.mesh(); //placed ioutside class- cannot be changed. Place inside class to have a different mesh each time - like a kid, woman, etc

class Person {
  float scale=0.1;
  PVector position = new PVector(); //can be used in the Person constructor. but here not really necessary
  char mTitle;
  boolean movable;

  Person(char pTitle) {
    mTitle = pTitle;
  }

  void display() {
    noStroke();
    pushMatrix();
    translate(position.x, position.y, position.z); //state
    scale(scale, -scale, scale); //state
    if (movable) {
      fill(200, 0, 0);
    } else {
      fill(255);
    }
    individual.draw(g);

    translate(0, 510, 0); //move the alphabet to the head area
    rotate(radians(-180));

    scale(-1, 1); //to mirror the alphabet
    //fill(255, 0, 0);
    textFont(Font1);
    textSize(100);
    fill(25, 25, 112);
    text(mTitle, 0, 0, .1);

    popMatrix();
  }
}