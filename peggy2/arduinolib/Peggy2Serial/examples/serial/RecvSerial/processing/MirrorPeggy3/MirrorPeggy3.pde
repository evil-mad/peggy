/**
 * Video Mirror for Peggy
 * Based on the processing sketch "Mirror" by Daniel Shiffman. 
 * Modified by Windell H Oskay to adapt video to Peggy 2.0 
 * 
 * Also incorporates code from Jay Clegg, http://planetclegg.com/projects/
 *
 *
 * To use this file, please see http://www.evilmadscientist.com/article.php/peggy2twi
 *
 * You will need to edit the line below with your actual serial port name listed; search for "CHANGE_HERE"
 *
 */
  

import processing.video.*;
import processing.serial.*;

Serial peggyPort;
PImage peggyImage = new PImage(25,25);
byte [] peggyHeader = new byte[] 
    { (byte)0xde, (byte)0xad, (byte)0xbe,(byte)0xef,1,0 };
byte [] peggyFrame = new byte[13*25];

boolean SerialEnabled;      // Set to "false" until we have a successful connection.

// Size of each cell in the grid
int cellSize = 9;  
int cellSize2 = 34;  // was 20 

// Number of columns and rows in our system
int cols, rows;
int ColLo, ColHi;
// Variable for capture device
Capture video;

int xDisplay,yDisplay;
int xs, ys; 
float brightTot;
int pixelCt;
color c2;

int OutputPoint = 0;

//int GrayArray[625];
int[] GrayArray = new int[625];
int j;
byte k; 

int DataSent = 0;


// NEEDS TO HAVE YOUR ACTUAL SERIAL PORT LISTED!!!

void setup() {
    peggyPort = new Serial(this, "/dev/cu.usbserial-FTE5638J", 115200);    // CHANGE_HERE
     
    
    
    
    
    smooth();
    noStroke();
//  size(640, 480, P3D);
  size(cellSize2*25, cellSize2*25, JAVA2D);
  //set up columns and rows
  cols = 25; //width / cellSize;   
  ColLo = 4; //Was 4
  ColHi = 29; // Was 29
  rows = 25; //height / cellSize;
  colorMode(RGB, 255, 255, 255, 100);
  rectMode(CENTER);

  // Uses the default video input, see the reference if this causes an error
//  video = new Capture(this, width, height, 5);
    video = new Capture(this, 320, 240, 15);  //Last number is frames per second
  background(0);
  
j = 0;
k = 0;

while (j < 625){
  
  
   GrayArray[j] = 4;//k;
   
k++;

if (k > 15)
  k = 0;

j++;   
}
  
   
  
}



// render a PImage to the Peggy by transmitting it serially.  
// If it is not already sized to 25x25, this method will 
// create a downsized version to send...
void renderToPeggy(PImage srcImg)
{
  int idx = 0;
  
  PImage destImg = srcImg; 
    
  // iterate over the image, pull out pixels and 
  // build an array to serialize to the peggy
  for (int y =0; y < 25; y++)
  {
    byte val = 0;
    for (int x=0; x < 25; x++)
    {
      color c = destImg.get(x,y);
      int br = ((int)brightness(c))>>4;
      if (x % 2 ==0)
        val = (byte)br;
      else
      {
        val = (byte) ((br<<4)|val);
        peggyFrame[idx++]= val;
      }
    }
    peggyFrame[idx++]= val;  // write that one last leftover half-byte
  }
   
  peggyPort.write(peggyHeader);
  peggyPort.write(peggyFrame); 
}





void draw() { 
  if (video.available()) { 
    video.read(); 
    video.loadPixels(); 
    
    background(0, 0, 0);

//int MaxSoFar = 0;
int thisByte = 0;
int e,k;
int br2;

int idx = 0;

PImage img2 = createImage(25, 25, ARGB);



    // Begin loop for columns
    
    k = 0;
    for (int i = ColLo; i < ColHi;i++) {
      // Begin loop for rows
      for (int j = 0; j < rows;j++) {

        // Where are we, pixel-wise?
        int x = i * cellSize;
        int y = j * cellSize;
        
        int loc = (video.width - x - 1) + y*video.width; // Reversing x to mirror the image

        // Each rect is colored white with a size determined by brightness
        color c = video.pixels[loc]; 
        
        pixelCt = 0;
        brightTot = 0;
        
        for (int xs = x; xs < (x + cellSize); xs++) {
         for (int ys = y; ys < (y + cellSize); ys++) {
        
          pixelCt++;
          loc = (video.width - xs - 1) + ys*video.width;
          c2 = video.pixels[loc];
          brightTot += brightness(c2);
           
        } 
        } 
        
        brightTot /= pixelCt;
         
        xDisplay = (i-ColLo)*cellSize2 + cellSize2/2;
        yDisplay = j*cellSize2 + cellSize2/2;        
        
         
  
// Linear brightness:        
         br2 = int((brightTot + random(-4, 4)) / 8);
   
          idx = (j)*cols + (i-ColLo); 
         GrayArray[idx] = (int) br2;  //inverted image      
       
        br2 = br2*8;   
         
        fill(br2,br2,br2);         // 8-level with true averaging   
          ellipse(xDisplay+1, yDisplay+1, cellSize2-1, cellSize2-1);    
        
       img2.pixels[idx] = br2; 
  k++;  
  }
    }
    
     renderToPeggy(img2);
        
  }  // End if video available
} // end main loop
