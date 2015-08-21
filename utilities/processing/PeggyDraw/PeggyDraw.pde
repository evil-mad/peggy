/**
 * PeggyDraw
 * v 1.0
 * by Windell H Oskay, Evil Mad Scientist Laboratories
 * 
 * Incorporates example code taken from several of the Processing example sketches. 
 * 
 */
 


class Button
{
  int x, y;
  int w, h;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;   

  void pressed() {
    if(over && mousePressed) {
      pressed = true;
    } 
    else {
      pressed = false;
    }    
  }

  boolean overRect(int x, int y, int width, int height) {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }
}

class ImageButtons extends Button 
{
  PImage base;
  PImage roll;
  PImage down;
  PImage currentimage;

  ImageButtons(int ix, int iy, int iw, int ih, PImage ibase, PImage iroll, PImage idown) 
  {
    x = ix;
    y = iy;
    w = iw;
    h = ih;
    base = ibase;
    roll = iroll;
    down = idown;
    currentimage = base;
  }

  void update() 
  {
    over();
    pressed();
    if(pressed) {
      currentimage = down;
    } 
    else if (over){
      currentimage = roll;
    } 
    else {
      currentimage = base;
    }
  }

  void over() 
  {
    if( overRect(x, y, w, h) ) {
      over = true;
    } 
    else {
      over = false;
    }
  }

  void display() 
  {
    image(currentimage, x, y);
  }
}






void mousePressed() {

  int mxin, myin;

  if ((mouseX > 0) && (mouseX < cols*cellSize) && (mouseY > 0) && (mouseY < rows*cellSize))
  {  // i.e., if we clicked within the LED grid
    mxin =    floor( mouseX / cellSize);
    myin =    floor( mouseY / cellSize);

    if ((GrayArray[myin*cols + mxin]) == InkWellColor)  // if the dot is already in our color
        pencolor = 0;                // We're erasing
    else
      pencolor = InkWellColor;     // We're drawing  

    pendown = true;
  }


  // Handle other interface bits here as well!
  if ( buttonErase.over ) {  // Erase screen!
    while (j < 625){
      GrayArray[j] = 0;
      j++; 
    }


    stroke(2);         // Set color: Gray outline for LED locations.
    strokeWeight(2);   
    fill(0);  
    for (int i = 0; i < cols; i++) {
      // Begin loop for rows
      for (int j = 0; j < rows; j++) {

        ellipse(i*cellSize + 1,  j*cellSize + 1, cellSize - 1 , cellSize- 1); 

      }
    }
  } 

  if ( buttonFill.over ) {  // Fill screen!
    while (j < 625){
      GrayArray[j] = 15;
      j++; 
    }


    stroke(2);         // Set color: Gray outline for LED locations.
    strokeWeight(2);   
    fill(15);  
    for (int i = 0; i < cols; i++) {
      // Begin loop for rows
      for (int j = 0; j < rows; j++) {

        ellipse(i*cellSize + 1,  j*cellSize + 1, cellSize - 1 , cellSize- 1); 

      }
    }
  } 

  if ( buttonSave.over ) {  //Save output file


    String comma = ",";
  

    // header = concat(header, footer);

    for (int i = 0; i < rows; i++) {
      // Begin loop for rows

      rowdata = 0;

      for (int j = 0; j < cols; j++) {

        if (GrayArray[i*cols + j] > 0)
        {
          rowdata += (1 << j);  
        }

      }

      if (i == (rows - 1))
        header = append(header, str(rowdata));
      else
          header = append(header, str(rowdata) + ',');

      //    OneRow[0] = str(rowdata);
      //    OneRow[i] = str(rowdata);// + ',';
      //  println(str(rowdata) + ',');
      //      println(OneRow[i]);


    }

    FileOutput = concat(header, footer);


    File outputDir = new File(sketchPath, "PeggyProgram"); 
    if (!outputDir.exists()) 
      outputDir.mkdirs(); 

    saveStrings("PeggyProgram/PeggyProgram.pde", FileOutput);   
    //Note: "/" apparently works as a path separator on all systems.




    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) { 



      }
    }

  }

}


void mouseReleased() {
  pendown = false;
}







// Size of each cell in the grid 
int cellSize = 20; 

// Number of columns and rows in our system
int cols = 25;
int rows = 25;

String[] header;
String[] RowData;
String[] footer;
String[] FileOutput; 
String[] OneRow; 

int[] GrayArray = new int[625];
int Brightness;
int j;
byte k; 
boolean pendown = false;
int pencolor;
int InkWellColor;

int rowdata;

ImageButtons buttonErase, buttonFill, buttonSave;



void setup() { 

  size(cellSize*cols, cellSize*rows + 125 , JAVA2D);


  PImage b = loadImage("erase_b.jpg");
  PImage r = loadImage("erase_r.jpg");
  PImage d = loadImage("erase_d.jpg");

  int x = 50 - b.width/2;
  int y = cellSize*rows + 20 - b.height/2; 
  int w = b.width;
  int h = b.height;
  buttonErase = new ImageButtons(x, y, w, h, b, r, d);


  b = loadImage("fill_b.jpg");
  r = loadImage("fill_r.jpg");
  d = loadImage("fill_d.jpg");

  x = 50 - b.width/2;
  y = cellSize*rows + 50 - b.height/2; 
  w = b.width;
  h = b.height;
  buttonFill = new ImageButtons(x, y, w, h, b, r, d);


  b = loadImage("save_b.jpg");
  r = loadImage("save_r.jpg");
  d = loadImage("save_d.jpg");

  x = width - (50 + b.width/2);
  y = cellSize*rows + 50 - b.height/2; 
  w = b.width;
  h = b.height;
  buttonSave = new ImageButtons(x, y, w, h, b, r, d);


  header = loadStrings("PeggyHeader.txt");
  footer = loadStrings("PeggyFooter.txt");




  colorMode(RGB, 15);    // Max value of R, G, B = 15.
  ellipseMode(CORNER);

  stroke(2);         // Set color: Gray outline for LED locations.
  strokeWeight(2); 
  smooth();

  imageMode(CORNER);

  j = 0;
  k = 0;

  while (j < 625){
    GrayArray[j] = 0;
    j++; 
  }

  InkWellColor = 15;



  background(0);

  stroke(2);         // Set color: Gray outline for LED locations.
  strokeWeight(2);   
  fill(10);   

  for (int i = 0; i < cols; i++) {
    // Begin loop for rows
    for (int j = 0; j < rows; j++) {

      ellipse(i*cellSize + 1,  j*cellSize + 1, cellSize - 1 , cellSize- 1); 
    }
  }



  fill(0);   
  for (int i = 0; i < cols; i++) {
    // Begin loop for rows
    for (int j = 0; j < rows; j++) {

      ellipse(i*cellSize + 1,  j*cellSize + 1, cellSize - 1 , cellSize- 1); 
    }
  }






}  // End Setup








void draw() {    

  int mxin, myin;

  buttonErase.update();
  buttonFill.update();
  buttonSave.update();

  buttonErase.display(); 
  buttonFill.display(); 
  buttonSave.display(); 


  if( pendown) {

    if ((mouseX > 0) && (mouseX < cols*cellSize) && (mouseY > 0) && (mouseY < rows*cellSize))
    {    // i.e., if we clicked within the LED grid
      mxin =    floor( mouseX / cellSize);
      myin =    floor( mouseY / cellSize);


      stroke(2);         // Set color: Gray outline for LED locations.
      strokeWeight(2);    

      GrayArray[myin*cols + mxin] = pencolor;   

      fill(pencolor);   
      //      ellipse(mxin*cellSize,  myin*cellSize, cellSize, cellSize); 
      ellipse(mxin*cellSize + 1,  myin*cellSize + 1, cellSize - 1 , cellSize- 1); 

    }
  }
 


} // end main loop
