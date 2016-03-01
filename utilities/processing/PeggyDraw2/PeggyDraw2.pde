/**
 * PeggyDraw
 * v 2.0
 * by Windell H Oskay, Evil Mad Scientist Laboratories
 * portions by Matt Mets, http://cibomahto.com
 *  
 *
 * The output file will be saved in the PeggyDraw2/data/ directory, under the name PeggyProgram.pde
 *
 * Updated for Processing 3.0, February 2016
 */

boolean UsePeggy2SerialLibrary = false;     //Which Peggy library to use?


AnimationFrames frames;        // Storage for our frame stack
AnimationFrame copiedFrame;    // Reference to the copied frame

AnimationLoader loader;        // Functions to load/save animations

boolean SteadyRate = true;     // True if all frames have the same duration

int DataX,DataY;               // Offset to draw the data display at

int brightFillColor = 15;      // This is the color stored in the animation frame for 'on' pixels
int dimFillColor = 3;          // This is the color stored in the animation frame for 'off' pixels

boolean pendown = false;
int pencolor; 

// Number of columns and rows in our system
final int cols = 25;
final int rows = 25;

final int guiWidth = 500;
final int guiHeight = 150;

// Size of each cell in the grid 
final int cellSize = 20; //guiWidth/cols; 

// Display colors
// TODO: Make these constants?
int TextColor = 10;
int TextHighLight = 15;
int bgColor = 1;

boolean playing;
int startTime;

PFont font_MB24;
PFont font_ML16;

// Active buttons
SimpleButton clearButton;
SimpleButton fillButton;
SimpleButton invertButton;
SimpleButton copyButton;
SimpleButton pasteButton;
SimpleButton deleteButton;
SimpleButton addButton;
SimpleButton previousButton;
SimpleButton nextButton;
SimpleButton loadButton;
SimpleButton saveButton;
SimpleButton durationTypeButton;
SimpleButton durationPlusButton;
SimpleButton durationMinusButton;

SimpleButton playButton;

// Inactive buttons (used as text displays)
SimpleButton durationSlashText;

boolean overRect(int x, int y, int width, int height) 
{
  if (mouseX >= x && mouseX <= x+width &&  mouseY >= y && mouseY <= y+height) 
    return true; 
  else 
    return false;
}

void updateFrameDuration(int duration) {
  if (SteadyRate) {
    for (int i = 0; i < frames.getFrameCount(); i++) {
      frames.getFrame(i).setDuration(duration);
    }
  }
  else {
    frames.getCurrentFrame().setDuration(duration);
  }
}


void setup() {

  frames = new AnimationFrames(cols,rows);
  
  loader = new AnimationLoader();

  // TODO: make sure this size makes sense.
  //size(guiWidth, guiHeight + cellSize*rows, JAVA2D);
  size(500, 650);
  smooth();

  font_MB24  = loadFont("Miso-Bold-24.vlw");
  font_ML16  = loadFont("Miso-Light-16.vlw"); 


  colorMode(RGB, 15);    // Max value of R, G, B = 15.
  ellipseMode(CORNER);


  strokeWeight(1);   
  stroke(2);         // Set color: Gray outline for LED locations.

  DataX = 15;
  DataY = cellSize*rows +25;

  // Initialize the text buttons that act as our GUI

  int x,y;

  x = 110;
  y = cellSize*rows + 25;
  clearButton = new SimpleButton("Clear", x, y, font_MB24, 24, TextColor, TextHighLight);
  x += 75;
  fillButton = new SimpleButton("Fill", x, y, font_MB24, 24, TextColor, TextHighLight);
  x += 65;
  invertButton = new SimpleButton("Invert", x, y, font_MB24, 24, TextColor, TextHighLight);
  x += 85;
  copyButton = new SimpleButton("Copy", x, y, font_MB24, 24, TextColor, TextHighLight);
  x += 75;
  pasteButton = new SimpleButton("Paste", x, y, font_MB24, 24, TextColor, TextHighLight);

  x = 105;
  y = cellSize*rows + 65;
  deleteButton = new SimpleButton("-Frame", x, y, font_MB24, 24, TextColor, TextHighLight);
  x += 85;
  previousButton = new SimpleButton("<<", x, y, font_MB24, 24, TextColor, TextHighLight);
  x +=  45 + 30 + 25 + 45;
  nextButton = new SimpleButton(">>", x, y, font_MB24, 24, TextColor, TextHighLight);
  x += 60;
  addButton = new SimpleButton("+Frame", x, y, font_MB24, 24, TextColor, TextHighLight);

  x = 110;
  y = cellSize*rows + 105;
  // toggle button
  durationTypeButton = new SimpleButton("All frames:", x, y, font_MB24, 24, TextColor, TextHighLight);

  x += 170;
  // duration decrease button
  durationPlusButton = new SimpleButton("+", x, y, font_MB24, 24, TextColor, TextHighLight);

  x += 15;
  durationSlashText = new SimpleButton("/", x, y, font_MB24, 24, TextColor, TextColor);

  x += 15;
  durationMinusButton = new SimpleButton("-", x, y, font_MB24, 24, TextColor, TextHighLight);

  x = 375;
  loadButton = new SimpleButton("Load", x, y, font_MB24, 24, TextColor, TextHighLight);
  x += 65;
  saveButton = new SimpleButton("Save", x, y, font_MB24, 24, TextColor, TextHighLight);

  x = 110;
  y = cellSize*rows + 145;
  playButton = new SimpleButton("Play", x, y, font_MB24, 24, TextColor, TextHighLight);
  
  playing = false;
  
  // Finally, add an empty frame to the animation
  frames.addFrame(new AnimationFrame(cols, rows), 0);
}  // End Setup


void draw() {
  int mxin, myin;
  int i,j,x,y;

  background(bgColor);

  AnimationFrame currentFrame = frames.getCurrentFrame();

  // Draw the current frame
  for ( i = 0; i < currentFrame.width; i++) {
    for ( j = 0; j < currentFrame.height; j++) {
      if (currentFrame.getPixel(i, j) > 0)
        fill(brightFillColor); 
      else
        fill(dimFillColor);

      ellipse(i*cellSize + 1,  j*cellSize + 1, cellSize - 1 , cellSize- 1); 
    }
  }


  if ((mouseX > 0) && (mouseX < cols*cellSize) && (mouseY > 0) && (mouseY < rows*cellSize))
  {

    mxin = floor( mouseX / cellSize);
    myin = floor( mouseY / cellSize); 

    fill(8);  
    textFont(font_MB24, 24); 

    // Display the mouse position
    if (mxin > 9) 
      text(mxin, DataX - 10, DataY); 
    else
      text(mxin, DataX, DataY); 

    text(",", DataX + 10, DataY);

    if (myin > 9)
      text(myin, DataX + 15, DataY);
    else
      text(myin, DataX + 20, DataY);

    // If the user has the mouse button pressed, do a drawing action
    if(mousePressed && pendown)
    {
      if (pencolor == brightFillColor)
        currentFrame.setPixel(mxin, myin, brightFillColor);
      else
        currentFrame.setPixel(mxin, myin, 0);
    }
  }

  // Display the PeggyDraw logo
  fill(5);  
  textFont(font_ML16, 16); 

  x = 10;
  y = cellSize*rows + 110;  
  text("PeggyDraw 2", x, y); 
  
  // Draw the text buttons
  DrawButtons();  


  textFont(font_ML16, 16);
  fill(TextHighLight);
  String message = new String("");

  // Display mouseover text!
  if (clearButton.isSelected()) {
    message = "Erase this frame";
  }
  else if (fillButton.isSelected()) {
    message = "Fill this frame with dots";
  }
  else if (invertButton.isSelected()) {
    message = "Create the negative of this frame";
  }
  else if (copyButton.isSelected()) {
    message = "Don't tell the RIAA or MPAA";
  }
  else if (pasteButton.isSelected()) {
    message = "Less messy than a glue stick";
  }
  else if (deleteButton.isSelected()) {
    message = "DELETE this frame";
  }
  else if (addButton.isSelected()) {
    message = "Add a frame after this frame";
  }
  else if (previousButton.isSelected()) {
    message = "Go to Previous Frame";
  }
  else if (nextButton.isSelected()) {
    message = "Go to Next Frame";
  }
  else if (loadButton.isSelected()) {
    message = "Re-load a saved file";
  }
  else if (saveButton.isSelected()) {
    message = "Export program for Arduino";
  }
  else if (durationTypeButton.isSelected()) {
    message = "Toggle: All frames or just this one";
  }
  else if (durationPlusButton.isSelected()) {
    message = "Increase time per frame";
  }
  else if (durationMinusButton.isSelected()) {
    message = "Decrease time per frame";
  }

  if (message != "") {
    text(message, DataX, DataY-10, 75, 100);
  }

  // TODO: remove me
  textFont(font_MB24, 24); 
  fill(TextColor);

  x = 105;
  y = cellSize*rows + 65;
  x += 85;
  x += 45; 

  text(frames.getCurrentPosition() + 1, x, y); 
  x += 30;    
  text("/", x, y);
  x += 25;   
  text(frames.getFrameCount(), x, y);  

  y = cellSize*rows + 105;
  x = 110;

  x += 100; 

  if (currentFrame.getDuration() < 1000) {
    text(currentFrame.getDuration(), x, y);
    x += 35;
    text("ms", x, y);
  }
  else if (currentFrame.getDuration() < 10000)
  {
    x += 10;
    text(currentFrame.getDuration()/1000, x, y);
    x += 25;
    text("s", x, y);
  }
  else {
    text(currentFrame.getDuration()/1000, x, y);  
    x += 35;   
    text("s", x, y); 
  }

  if( playing ) {
    if (millis() > startTime + currentFrame.getDuration()) {
      startTime = millis();
      frames.setCurrentPosition((frames.getCurrentPosition() + 1)%frames.getFrameCount());
    }
  }
  
} // end main loop 


void mousePressed() {

  int mxin, myin;
  int x,y;

  AnimationFrame currentFrame = frames.getCurrentFrame();

  if ((mouseX > 0) && (mouseX < cols*cellSize) && (mouseY > 0) && (mouseY < rows*cellSize))
  {  // i.e., if we clicked within the LED grid
    mxin =    floor( mouseX / cellSize);
    myin =    floor( mouseY / cellSize);

    // if the dot is already in our color
    if (currentFrame.getPixel(mxin, myin) == brightFillColor)
      //   if (true)  // if the dot is already in our color
      pencolor = dimFillColor;        // We're erasing
    else
      pencolor = brightFillColor;     // We're drawing  

    pendown = true;
  }

  else
  {  // Check GUI buttons!

    if( clearButton.isSelected() ) {
      currentFrame.preset(0);
    }
    else if( fillButton.isSelected() ) {
      currentFrame.preset(brightFillColor);
    }
    else if( invertButton.isSelected() ) {
      // For each pixel in the frame, invert it...
      for ( int i = 0; i < currentFrame.width; i++) {
        for ( int j = 0; j < currentFrame.height; j++) {
          if (currentFrame.getPixel(i, j) > 0)
            currentFrame.setPixel(i, j, 0);
          else
            currentFrame.setPixel(i, j, brightFillColor);
        }
      }
    }
    else if( copyButton.isSelected() ) {
      // Store a copy of the current frame
      copiedFrame = new AnimationFrame(frames.getCurrentFrame());
    }
    else if( pasteButton.isSelected() ) {
      // Replace the current frame with our stored copy
      if (copiedFrame != null) {
        frames.replaceCurrentFrame(copiedFrame);
      }
    }
    else if( deleteButton.isSelected() ) {
      frames.removeFrame(frames.getCurrentPosition());
     
      // If we've deleted all the frames, make a new one 
      if (frames.getFrameCount() == 0) {
        frames.addFrame(new AnimationFrame(cols, rows), 0);
      }
    }
    else if( previousButton.isSelected() ) {
      frames.setCurrentPosition(frames.getCurrentPosition() - 1);
    }
    else if( nextButton.isSelected() ) {
      frames.setCurrentPosition(frames.getCurrentPosition() + 1);
    }
    else if( addButton.isSelected() ) {
      // Store the current duration so that we can copy it to the new frame
      int duration = frames.getCurrentFrame().getDuration();
      
      // Create the new frame
      AnimationFrame newFrame = new AnimationFrame(cols, rows);
      newFrame.setDuration(duration);
      
      // Then add it
      frames.addFrame(newFrame, frames.getCurrentPosition() + 1);
       
    }
    else if( durationTypeButton.isSelected() ) {
      if (SteadyRate) {
        SteadyRate = false;
        durationTypeButton.updateLabel("This frame: ");
      } 
      else {
        SteadyRate = true;
        durationTypeButton.updateLabel("All frames: ");
        updateFrameDuration(currentFrame.getDuration());
      }
    }
    else if( durationPlusButton.isSelected() ) {
      int duration = currentFrame.getDuration();
      if (duration <= 90)
        duration += 10;
      else if (duration <= 900)
        duration += 100;
      else if (duration <= 59000)
        duration += 1000;
      else
        duration = 60000;
        
      updateFrameDuration(duration);
    } 
    else if( durationMinusButton.isSelected() ) {
      int duration = currentFrame.getDuration();

      if (duration >= 2000 )
        duration -= 1000;
      else if (duration >= 200 )
        duration -= 100;
      else if (duration >= 30 )
        duration -= 10;
      else
        duration = 20;

      updateFrameDuration(duration);
    }     
    else if( loadButton.isSelected() ) {
      AnimationFrames newAnimation = loader.LoadAnimation("demo_load");
      frames = newAnimation;
    }
    else if( saveButton.isSelected() ) {
      loader.SaveAnimation("demo_save", frames);
      // TODO: Save out the data!
    }
    else if( playButton.isSelected() ) {
      if (playing) {
        playButton.updateLabel("Play");
        playing = false;
      }
      else {
        playButton.updateLabel("Pause");
        playing = true;
        startTime = millis();
      }
    }
  }
}

void mouseReleased() {
  pendown = false;
}